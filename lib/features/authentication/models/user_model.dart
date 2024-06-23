import 'package:bucks_buddy/utils/formatters/formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



/// Model class representing user data
class UserModel {
 // keep thosse values final which you do not want to update
 final String id;
 String name;
 final String username;
 String phoneNumber;
 final String email;
 String profilePicture;
 List<Map<String, String>> friends;


 //Constructor for UserModel
 UserModel({
   required this.id,
   required this.name,
   required this.username,
   required this.phoneNumber,
   required this.email,
   required this.profilePicture,
   this.friends = const [],
 });


 /// helper function to get the name
 String get fullName => name;


 ///Helper function to format phoneNumber
 String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);


 ///Static function to generate a username from full name
 static String generateUserName(String name) {
   String camelCaseUsername = name
       .replaceAll(' ', '')
       .toLowerCase(); // Combine name and convert to lowercase
   String usernameWithPrefix = "bb_$camelCaseUsername"; // Add "bb_" prefix
   return usernameWithPrefix;
 }


 /// static function to create an empty user model
 static UserModel empty() => UserModel(
     id: '',
     name: '',
     username: '',
     phoneNumber: '',
     email: '',
     profilePicture: '',
     friends: []);


 /// static function to JSON structure for storing data in firebase
 Map<String, dynamic> toJson() {
   return {
     'Name': name,
     'Username': username,
     'Email': email,
     'PhoneNumber': phoneNumber,
     'ProfilePicture': profilePicture,
     'friends': friends.map((friend) => {
            'friendId': friend['friendId'],
            'friendUsername': friend['friendUsername'],
            'friendProfilePicture': friend['friendProfilePicture'], 
          }).toList(),
   };
 }


 /// Factory method to create a UserModel from a Firebase document snapshot
 factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
   final data = document.data()!;
   List<Map<String, String>> friendsList = [];

   if (data['friends'] != null) {
      friendsList = List<Map<String, String>>.from(data['friends'].map((item) => {
            'friendId': item['friendId'].toString(),
            'friendUsername': item['friendUsername'].toString(),
            'friendProfilePicture': item['friendProfilePicture'].toString(), // Parse profile picture from Firestore data
          }));
    }


   return UserModel(
     id: document.id,
     name: data['Name'] ?? '',
     username: data['Username'] ?? '',
     phoneNumber: data['PhoneNumber'] ?? '',
     email: data['Email'] ?? '',
     profilePicture: data['ProfilePicture'] ?? '',
     friends: friendsList,
   );
 }
}



