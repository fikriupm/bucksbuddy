import 'package:bucks_buddy/features/authentication/controllers/login/login_controller.dart';
import 'package:bucks_buddy/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bucks_buddy/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:bucks_buddy/utils/constants/text_strings.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Form(
        key: controller.loginFormKey,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections / 2),
          child: Column(
            children: [
              ///Email
              TextFormField(
                controller: controller.email,
                validator: (value) => TValidator.validateEmail(value),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.user),
                  labelText: TTexts.id,
                  filled: true,
                  fillColor: Colors.grey[200], // Set the desired grey color
                ),
              ),
              // TextFormField
              const SizedBox(height: TSizes.spaceBtwInputFields / 2),

              /// password
              Obx(
                () => TextFormField(
                  controller: controller.password,
                  validator: (value) => TValidator.validatePassword(value),
                  obscureText: controller.hidePassword.value,
                  decoration: InputDecoration(
                    labelText: TTexts.password,
                    prefixIcon: const Icon(Iconsax.lock),
                    suffixIcon: IconButton(
                      onPressed: () => controller.hidePassword.value =
                          !controller.hidePassword.value,
                      icon: Icon(controller.hidePassword.value
                          ? Iconsax.eye_slash
                          : Iconsax.eye),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwInputFields / 100),

              // Remember Me & Forget Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Remember me
                  Row(
                    children: [
                      Obx(
                      () => Checkbox(
                          value: controller.rememberMe.value,
                          onChanged: (value) => controller.rememberMe.value = !controller.rememberMe.value),
                      ),
                      const Text(TTexts.rememberMe),
                    ],
                  ),

                  /// Forget Password
                  TextButton(
                      onPressed: () => Get.to(() => const ForgetPassword()),
                      child: const Text(TTexts.forgetPassword))
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields / 4),

              /// Sign in Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.emailAndPasswordLogIn(),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        const Color(0xFFE9C401), // Set the text color to white
                    // elevation: 0, // Remove the elevation effect
                    shape: RoundedRectangleBorder(
                      // Set the shape to a rounded rectangle
                      borderRadius: BorderRadius.circular(
                          30), // Adjust the border radius as needed
                    ),
                    side: const BorderSide(
                        color: Color(0xFFE9C401),
                        width: 2), // Customize the border color and width
                  ),
                  child: const Text(
                    TTexts.login,
                    style: TextStyle(
                        color: Colors.white), // Set the text color to white
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
