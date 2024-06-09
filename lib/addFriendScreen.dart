import 'package:bucks_buddy/data/repositories/user/user_repository.dart';
import 'package:flutter/material.dart';
import 'FriendRepository.dart';
import 'package:bucks_buddy/features/authentication/models/user_model.dart';
import 'Friend.dart';

class FriendScreen extends StatefulWidget {
  @override
  _FriendScreenState createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  Future<List<UserModel>> _fetchUsers() async {
    return UserRepository.instance.fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend'),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final users = snapshot.data;
            if (users!.isEmpty) {
              return Center(
                child: Text('No users found'),
              );
            }
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user.name),
                  onTap: () {
                    // When a user is tapped, add them as a friend
                    Friend friend = Friend(
                      id: user.id, // You can use the user's ID as the friend's ID
                      name: user.name,
                      email: user.email,
                    );
                    FriendRepository.instance.addFriend(friend);
                    // Show a message or navigate to another screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${user.name} added as a friend!'),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
