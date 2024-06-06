
import 'package:bucks_buddy/data/repositories/user/user_repository.dart';
import 'package:bucks_buddy/features/authentication/models/user_model.dart';
import 'package:bucks_buddy/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final userRepository = Get.put(UserRepository());

  Future<void> saveUserRecord(UserCredential? userCredentials) async {
   try{
      if (userCredentials != null) {
        final name = userCredentials.user!.displayName ?? '';
        final username = UserModel.generateUserName(userCredentials.user!.displayName ?? '');

        //mapdata
        final user = UserModel(
          id: userCredentials.user!.uid, 
          name: name, 
          username: username, 
          phoneNumber: userCredentials.user!.phoneNumber ?? '', 
          email: userCredentials.user!.email ?? '', 
          profilePicture: userCredentials.user!.photoURL ?? ''
        );

        //save user data
        await userRepository.saveUserRecord(user);
      }
    } catch (e) {
      TLoaders.warningSnackBar(title: 'Data not saveed',
      message: 'Something went wrong while saving your information. You can re-save your data in your profile.');
    }
  }
 }