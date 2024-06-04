import 'package:bucks_buddy/features/authentication/controllers/signup/signup_controller.dart';
import 'package:bucks_buddy/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bucks_buddy/features/authentication/screens/signup/widgets/terms_conditions_checkbox.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:bucks_buddy/utils/constants/text_strings.dart';

class TSignupForm extends StatelessWidget {
  const TSignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(SignupController());
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [

          /// Name
          TextFormField(
            controller: controller.name,
            validator: (value) => TValidator.validateEmptyText('Name', value),
            expands: false,
            decoration: InputDecoration(
              labelText: TTexts.name,
              prefixIcon: const Icon(Iconsax.user_edit),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields / 2),
          /// Username
          TextFormField(
            controller: controller.username,
            validator: (value) => TValidator.validateEmptyText('Username', value),
            expands: false,
            decoration: InputDecoration(
              labelText: TTexts.username,
              prefixIcon: const Icon(Iconsax.user_edit),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields / 2),

          /// Phone Number
          TextFormField(
            controller: controller.phoneNumber,
            validator: (value) => TValidator.validatePhoneNumber(value),
            decoration: InputDecoration(
              labelText: TTexts.phoneNo,
              prefixIcon: const Icon(Iconsax.call),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields / 2),

          /// Email
          TextFormField(
            controller: controller.email,
            validator: (value) => TValidator.validateEmail(value),
            decoration: InputDecoration(
              labelText: TTexts.email,
              prefixIcon: const Icon(Iconsax.direct),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
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
                  onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                  icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
                ),
              filled: true,
              fillColor: Colors.grey[200],
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections / 4),

          /// Terms&Conditions CheckBox
          const TTernsAndConditionCheckbox(),
          const SizedBox(height: TSizes.spaceBtwSections/2),

          //signup button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.signup(),
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
                TTexts.createAccount,
                style: TextStyle(
                    color: Colors.white), // Set the text color to white
              ),
            ),
          ),
        ],
      ),
    );
  }
}