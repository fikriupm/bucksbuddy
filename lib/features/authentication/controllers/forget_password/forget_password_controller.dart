import 'package:bucks_buddy/data/repositories/authentication/authentication_repository.dart';
import 'package:bucks_buddy/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:bucks_buddy/utils/constants/image_strings.dart';
import 'package:bucks_buddy/utils/helpers/network_manager.dart';
import 'package:bucks_buddy/utils/popups/full_screen_loader.dart';
import 'package:bucks_buddy/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  /// Variable
  final email = TextEditingController();
  GlobalKey<FormState> forgetPassworFormKey = GlobalKey<FormState>();

  /// Send Reset Password Email
  sendPasswordResetEmail() async {
    try {
      //start loading
      TFullScreenLoader.openLoadingDialog(
          'Processing your Request...', TImages.verifyScreen);

      //Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //form validation
      if (!forgetPassworFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance
          .sendPasswordResetEmail(email.text.trim());

      //remove loader
      TFullScreenLoader.stopLoading();

      //show succss screen
      TLoaders.successSnackBar(
          title: 'Email Sent',
          message: 'Email Link Sent to Reset your Password'.tr);

      // Redirect
      Get.to(() => ResetPasswordScreen(email: email.text.trim()));
    } catch (e) {
      //remove laoder
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  resendPasswordResetEmail(String email) async {
    try {
      //start loading
      TFullScreenLoader.openLoadingDialog(
          'Processing your Request...', TImages.verifyScreen);

      //Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance
          .sendPasswordResetEmail(email);

      //remove loader
      TFullScreenLoader.stopLoading();

      //show succss screen
      TLoaders.successSnackBar(
          title: 'Email Sent',
          message: 'Email Link Sent to Reset your Password'.tr);

    } catch (e) {
      //remove laoder
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
