import 'dart:io';
import 'package:bucks_buddy/data/repositories/authentication/authentication_repository.dart';
import 'package:bucks_buddy/features/authentication/models/user_model.dart';
import 'package:bucks_buddy/utils/exceptions/firebase_exceptions.dart';
import 'package:bucks_buddy/utils/exceptions/format_exceptions.dart';
import 'package:bucks_buddy/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

/// Repository class for user-related operations.
class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Function to save user data to Firestore.
  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).set(user.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Function to fetch user details based on user ID
  Future<UserModel> fetchUserDetails() async {
    try {
      //data in json, json called map, data in string, dynamic is value
      final documentSnapshot = await _db
          .collection("Users")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .get();
      if (documentSnapshot.exists) {
        return UserModel.fromJson(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Function to update user data in Firestore.
  Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
      await _db
          .collection("Users")
          .doc(updatedUser.id)
          .set(updatedUser.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// update any field in specific user in collection
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db
          .collection("Users")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .update(json);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// function to remove user data from firestore
  Future<void> removeUserRecord(String userId) async {
    try {
      await _db.collection("Users").doc(userId).delete();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Function to fetch all users from Firestore.
  Future<List<UserModel>> fetchAllUsers() async {
    try {
      final querySnapshot = await _db.collection("Users").get();
      if (querySnapshot.docs.isEmpty) {
        print('No users found in the collection.');
        return [];
      }
      return querySnapshot.docs.map((doc) => UserModel.fromJson(doc)).toList();
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.code}');
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      print('FormatException: $e');
      throw const TFormatException();
    } on PlatformException catch (e) {
      print('PlatformException: ${e.code}');
      throw TPlatformException(e.code).message;
    } catch (e) {
      print('Unknown exception: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  ///upload any image
  Future<String> uploadImage(String path, XFile image) async {
    try {
      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  //Function to add friends to user's friend list
  Future<void> addFriend(
      String userId, String friendId, String friendUsername) async {
    try {
      // Construct the friend object with id and username
      Map<String, String> friend = {
        'friendId': friendId,
        'friendUsername': friendUsername,
      };

      // Update the user's friends list to add the friend
      await _db.collection('Users').doc(userId).update({
        'friends': FieldValue.arrayUnion([friend]),
      });
    } catch (e) {
      throw 'Failed to add friend: $e';
    }
  }

  //Function to remove friend from user friends list
  Future<void> removeFriend(String userId, String friendId) async {
    try {
      // Update the user's friends list to remove the friendId
      await _db.collection('Users').doc(userId).update({
        'friends': FieldValue.arrayRemove([friendId]),
      });
    } catch (e) {
      throw 'Failed to remove friend: $e';
    }
  }

  //Function to retrieve current user's friends
  Future<List<String>> fetchCurrentUserFriends(String userId) async {
    try {
      final documentSnapshot = await _db.collection("Users").doc(userId).get();
      if (documentSnapshot.exists) {
        final userData = documentSnapshot.data();
        if (userData != null && userData['friends'] != null) {
          final List<dynamic> friendsData = userData['friends'];
          return friendsData
              .map<String>((friend) => friend['friendId'].toString())
              .toList();
        }
      }
      return [];
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
