import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bucks_buddy/data/repositories/user/user_repository.dart';
import 'package:bucks_buddy/features/authentication/models/user_model.dart';


class FriendScreen extends StatefulWidget {
 @override
 _FriendScreenState createState() => _FriendScreenState();
}


class _FriendScreenState extends State<FriendScreen> {
 List<UserModel> _users = [];
 List<String> _currentUserFriends = [];
 List<UserModel> _nonFriends = [];
 bool _isLoading = true;


 @override
 void initState() {
   super.initState();
   _fetchData();
 }


 Future<void> _fetchData() async {
   try {
     _users = await UserRepository.instance.fetchAllUsers();
     print('Fetched users: ${_users.map((u) => u.toJson()).toList()}');
     _currentUserFriends = await UserRepository.instance.fetchCurrentUserFriends(FirebaseAuth.instance.currentUser?.uid ?? '');
     print('Fetched current user friends: $_currentUserFriends');
     _updateNonFriendsList();
   } catch (e) {
     print('Error fetching data: $e');
   } finally {
     setState(() {
       _isLoading = false;
     });
   }
 }


 void _updateNonFriendsList() {
var currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';
_nonFriends = _users.where((user) => user.id != currentUserUid).toList();
print('Non-friends: ${_nonFriends.map((u) => u.toJson()).toList()}');
setState(() {
});

}



 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       leading: IconButton(
         icon: Icon(Icons.arrow_back),
         onPressed: () {
           Navigator.of(context).pop();
         },
       ),
     ),
     body: _buildBody(),
   );
 }


 Widget _buildBody() {
   if (_isLoading) {
     return Center(
       child: CircularProgressIndicator(),
     );
   }


   if (_users.isEmpty) {
     return Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Text('No users found'),
           SizedBox(height: 20),
           Center(
             child: Padding(
               padding: const EdgeInsets.all(16.0),
               child: Image.asset(
                 'assets/logos/logo-main.png',
                 height: 80,
               ),
             ),
           ),
         ],
       ),
     );
   }


   return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
       Center(
         child: Padding(
           padding: const EdgeInsets.all(16.0),
           child: Image.asset(
             'assets/logos/logo-main.png',
             height: 80,
           ),
         ),
       ),
       _buildSection('Your Friends', _currentUserFriends, isFriendSection: true),
       _buildSection('Add a new friend', _nonFriends, isFriendSection: false),
     ],
   );
 }
   
   Widget _buildSection(String title, List<dynamic> items, {required bool isFriendSection}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            if (isFriendSection && item is String) {
              // Find the user corresponding to the friend ID
              final user = _users.firstWhere((user) => user.id == item, orElse: () => UserModel.empty());
              // Build the friend tile with a remove button
              return _buildFriendTile(user.name, () {
                _removeFriend(user.id, user.name, user.profilePicture);  // This call remains the same
              });
            } else if (!isFriendSection && item is UserModel) {
              // Build the non-friend tile with an add button
              return _buildFriendTile(item.name, () {
                _addFriend(item.id, item.name, item.profilePicture); 
              }, isAddButton: true);
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ],
 );
}





Widget _buildFriendTile(String friendName, VoidCallback onPressed, {bool isAddButton = false}) {
 return ListTile(
   title: Text(friendName),
   trailing: isAddButton
       ? ElevatedButton(
           onPressed: onPressed,
           style: ElevatedButton.styleFrom(
             foregroundColor: Colors.black,
             backgroundColor: Color(0xFFFFD600),
             padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
             visualDensity: VisualDensity.compact,
           ),
           child: Text(
             '+ Add',
             style: TextStyle(fontSize: 16),
           ),
         )
       : IconButton(
           icon: Icon(Icons.close),
           onPressed: onPressed,
         ),
 );
}




 Future<void> _addFriend(String friendId, String friendName, String friendProfilePicture) async {
 try {
   final currentUser = FirebaseAuth.instance.currentUser;
   if (currentUser != null) {
     // Fetch the current user's details to get their username
     final currentUserDetails = await UserRepository.instance.fetchUserDetails();
     final currentUserUsername = currentUserDetails.name;

     await UserRepository.instance.addFriend(
       currentUser.uid,
       friendId,
       friendName,
       currentUserUsername,
       friendProfilePicture,
     );
     setState(() {
       _currentUserFriends.add(friendId);
       _nonFriends.removeWhere((user) => user.id == friendId);
     });
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         content: Text('$friendName added as a friend!'),
       ),
     );
   }
 } catch (e) {
   print('Failed to add friend: $e');
   ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       content: Text('Failed to add $friendName as a friend!'),
     ),
   );
 }
}


 // Remove friends from list
Future<void> _removeFriend(String friendId, String friendName, String friendProfilePicture) async {
   try {
     final currentUser = FirebaseAuth.instance.currentUser;
     if (currentUser != null) {
       // Fetch the current user's details to get their username
       final currentUserDetails = await UserRepository.instance.fetchUserDetails();
       final currentUserUsername = currentUserDetails.name;


       // Remove friend from Firestore
       await UserRepository.instance.removeFriend(
         currentUser.uid,
         friendId,
         friendName,
         currentUserUsername,
         friendProfilePicture,
       );


       setState(() {
         _currentUserFriends.remove(friendId);
         final removedFriend = _users.firstWhere((user) => user.id == friendId, orElse: () => UserModel.empty());
         if (removedFriend != UserModel.empty()){
           _nonFriends.add(removedFriend);
         }
       });


       // Show success message
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text('$friendName removed from friends!'),
         ),
       );
     }
   } catch (e) {
     // Handle errors
     print('Failed to remove friend: $e');
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         content: Text('Failed to remove $friendName from friends!'),
       ),
     );
   }
 }
}
