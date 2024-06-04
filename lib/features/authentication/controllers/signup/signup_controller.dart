import 'package:bucks_buddy/data/repositories/authentication/authentication_repository.dart';
import 'package:bucks_buddy/data/repositories/user/user_repository.dart';
import 'package:bucks_buddy/features/authentication/screens/signup/verify_email.dart';
import 'package:bucks_buddy/features/authentication/models/user_model.dart';
import 'package:bucks_buddy/utils/constants/image_strings.dart';
import 'package:bucks_buddy/utils/helpers/network_manager.dart';
import 'package:bucks_buddy/utils/popups/full_screen_loader.dart';
import 'package:bucks_buddy/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  ///Variables
  final hidePassword = true.obs; //Observable for hiding/showing password
  final privacyPolicy = true.obs; //Observable for privacy policy acceptance
  final email = TextEditingController(); //controller for email input
  final name = TextEditingController(); //controller for name input
  final username = TextEditingController(); //controller for username input
  final password = TextEditingController(); //controller for password input
  final phoneNumber =
      TextEditingController(); //controller for phone number input
  GlobalKey<FormState> signupFormKey =
      GlobalKey<FormState>(); // form key for form validation

  ///Signup
  Future<void> signup() async {
    try {
      //start laoding
      TFullScreenLoader.openLoadingDialog(
          'We are processing your information....', TImages.verifyScreen);

      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected){
        TFullScreenLoader.stopLoading();
        return;
      }

      //form valdation
      if (!signupFormKey.currentState!.validate()){
        TFullScreenLoader.stopLoading();
        return;
      } 
      //privacy policy check
      if (!privacyPolicy.value) {
        TLoaders.warningSnackBar(
          title: 'Accept Privacy Policy',
          message:
              'In order to create account, you must have to read and accept the Privacy Policy & Terms of Use',
        );
        return;
      }

      //register user in the firebase authentication & save user data in the firebase
      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              email.text.trim(), password.text.trim());

      //save authenticated user data in the firebase firestore
      final newUser = UserModel(
        id: userCredential.user!.uid,
        name: name.text.trim(),
        username: username.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        email: email.text.trim(),
        profilePicture: ' ',
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      //remove loader
      TFullScreenLoader.stopLoading();

      //show success message
      TLoaders.successSnackBar(title: 'Congratulations', message: 'Your account has been created! Verify email to continue');

      //move to verify email screen
      Get.to(() => VerifyEmailScreen(email: email.text.trim(),));
    } catch (e) {

      TFullScreenLoader.stopLoading();

      // show some generic error to the user
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } 
    // finally {
    //   //remove loader
    //   TFullScreenLoader.stopLoading();
    // }
  }
}
