import 'package:bucks_buddy/data/repositories/authentication/authentication_repository.dart';
import 'package:bucks_buddy/data/repositories/user/user_repository.dart';
import 'package:bucks_buddy/features/authentication/models/user_model.dart';
import 'package:bucks_buddy/features/authentication/screens/login/login.dart';
import 'package:bucks_buddy/features/personalization/screens/profile/widgets/re_authenticate_user_login_form.dart';
import 'package:bucks_buddy/utils/constants/image_strings.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:bucks_buddy/utils/helpers/network_manager.dart';
import 'package:bucks_buddy/utils/popups/full_screen_loader.dart';
import 'package:bucks_buddy/utils/popups/loaders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final profileLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;

  final hidePassword = false.obs;
  final imageUpLoading = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  /// fetch user record
  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  /// Check if debtor exists in Firestore
  Future<bool> doesDebtorExist(String debtorusername) async {
    try {
      profileLoading.value = true;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('Name', isEqualTo: debtorusername)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      TLoaders.warningSnackBar(
        title: 'Error',
        message: 'Error checking debtor existence: $e',
      );
      return false;
    } finally {
      profileLoading.value = false;
    }
  }

  ///save user record from any registration provider
  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {
      //first update Rx User and then check if user data is already stored. If not store new data
      await fetchUserRecord();

      //if no record already stored
      if (user.value.id.isEmpty) {
        if (userCredentials != null) {
          final name = userCredentials.user!.displayName ?? '';
          final username = UserModel.generateUserName(
              userCredentials.user!.displayName ?? '');

          //mapdata
          final user = UserModel(
              id: userCredentials.user!.uid,
              name: name,
              username: username,
              phoneNumber: userCredentials.user!.phoneNumber ?? '',
              email: userCredentials.user!.email ?? '',
              profilePicture: userCredentials.user!.photoURL ?? '');

          //save user data
          await userRepository.saveUserRecord(user);
        }
      }
    } catch (e) {
      TLoaders.warningSnackBar(
          title: 'Data not saveed',
          message:
              'Something went wrong while saving your information. You can re-save your data in your profile.');
    }
  }

  /// Deete account Warning
  void deleteAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(TSizes.md),
      title: 'Delete Account',
      middleText:
          'Are you sure you want to delete your account permanently? This action is not reversible and all of your data will be removed permanently.',
      confirm: ElevatedButton(
        onPressed: () async => deleteUserAccount(),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            side: const BorderSide(color: Colors.red)),
        child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
            child: Text('Delete')),
      ),
      cancel: OutlinedButton(
        child: const Text("Cancel"),
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
      ),
    );
  }

  /// Delete User Account
  void deleteUserAccount() async {
    try {
      TFullScreenLoader.openLoadingDialog('Processing', TImages.verifyScreen);

      /// First re-authenticate user
      final auth = AuthenticationRepository.instance;
      final provider =
          auth.authUser!.providerData.map((e) => e.providerId).first;
      if (provider.isNotEmpty) {
// Re Verify Auth Email
        if (provider == 'google.com') {
          await auth.signInWithGoogle();
          await auth.deleteAccount();
          TFullScreenLoader.stopLoading();
          Get.offAll(() => const LoginScreen());
        } else if (provider == 'password') {
          TFullScreenLoader.stopLoading();
          Get.to(() => const ReAuthLoginForm());
        }
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// RE-AUTHENTICATE before deleting
  Future<void> reAuthenticateEmailAndPasswordUser() async {
    try {
      TFullScreenLoader.openLoadingDialog('Processing', TImages.verifyScreen);
      //Check Internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }
      if (!reAuthFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance
          .reAuthenticateWithEmailAndPassword(
              verifyEmail.text.trim(), verifyPassword.text.trim());
      await AuthenticationRepository.instance.deleteAccount();
      TFullScreenLoader.stopLoading();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  //upload profile image
  uploadUserProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 70,
          maxHeight: 512,
          maxWidth: 512);
      if (image != null) {
        imageUpLoading.value = true;
        //upload image
        final imageUrl =
            await userRepository.uploadImage('Users/Images/Profile/', image);

        //update user image record
        Map<String, dynamic> json = {'ProfilePicture': imageUrl};
        await userRepository.updateSingleField(json);

        user.value.profilePicture = imageUrl;
        user.refresh();

        TLoaders.successSnackBar(
            title: 'Congratulations',
            message: 'Your Profile Image has been updated');
      }
    } catch (e) {
      TLoaders.warningSnackBar(
          title: 'Oh Snap!', message: 'Something went wrong:  $e');
    } finally {
      imageUpLoading.value = false;
    }
  }
}
