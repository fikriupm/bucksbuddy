import 'package:bucks_buddy/features/authentication/controllers/forget_password/forget_password_controller.dart';
import 'package:bucks_buddy/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:bucks_buddy/utils/constants/text_strings.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Headings
            Text(TTexts.forgetPasswordTitle,
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text(TTexts.forgetPasswordSubTitle,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: TSizes.spaceBtwItems),

            /// Text field
            Form(
              key: controller.forgetPassworFormKey,
              child: TextFormField(
                controller: controller.email,
                validator: TValidator.validateEmail,
                decoration: const InputDecoration(
                    labelText: TTexts.email,
                    prefixIcon: Icon(Iconsax.direct_right)),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            /// Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.sendPasswordResetEmail(),
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
                  TTexts.submit,
                  style: TextStyle(
                      color: Colors.white), // Set the text color to white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
