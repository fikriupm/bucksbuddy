import 'package:cloud_firestore/cloud_firestore.dart';
import 'Friend.dart';

class FriendRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static FriendRepository get instance => FriendRepository();

  Future<void> addFriend(Friend friend) async {
    try {
      await _firestore.collection('friends').doc(friend.id).set(friend.toMap());
    } catch (e) {
      // Handle error
      print('Error adding friend: $e');
      throw e; // Rethrow the error for handling in the UI
    }
  }
}
