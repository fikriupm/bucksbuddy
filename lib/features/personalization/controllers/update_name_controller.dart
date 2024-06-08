import 'package:bucks_buddy/data/repositories/user/user_repository.dart';
import 'package:bucks_buddy/features/personalization/controllers/user_controller.dart';
import 'package:bucks_buddy/features/personalization/screens/profile/profile.dart';
import 'package:bucks_buddy/utils/constants/image_strings.dart';
import 'package:bucks_buddy/utils/helpers/network_manager.dart';
import 'package:bucks_buddy/utils/popups/full_screen_loader.dart';
import 'package:bucks_buddy/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controller to manage user-related functionality.
class UpdateNameController extends GetxController {
  static UpdateNameController get instance => Get.find();

  final name = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());

  GlobalKey<FormState> updateUserNameFormkey = GlobalKey<FormState>();

  /// init user data when Home Screen appears
  @override
  void onInit() {
    initializeNames();
    super.onInit();
  }

  /// Fetch user record
  Future<void> initializeNames() async {
    name.text = userController.user.value.name; // Assuming 'name' field exists in the user model
  }

  Future<void> updateUserName() async {
    try {
      //start loading
      TFullScreenLoader.openLoadingDialog(
          'We are updating your information', TImages.verifyScreen);

      //Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //form validation
      if (!updateUserNameFormkey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //update name in firebase store
      Map<String, dynamic> updatedName = {
        'Name': name.text.trim()
      };
      await userRepository.updateSingleField(updatedName);

      //update the Rx user value
      userController.user.value.name = name.text.trim();

      //remove loader
      TFullScreenLoader.stopLoading();

      // show success message
      TLoaders.successSnackBar(
          title: 'Congratulations', message: 'Your Name has been updated.');

      // move to previous screen
      Get.off(() => const ProfileScreen());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
