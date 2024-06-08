import 'package:bucks_buddy/features/personalization/controllers/user_controller.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:bucks_buddy/utils/constants/text_strings.dart';
import 'package:bucks_buddy/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax/iconsax.dart';

class ReAuthLoginForm extends StatelessWidget {
  const ReAuthLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Re-Authenticate User'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Form(
              key: controller.reAuthFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///Email
                  TextFormField(
                    controller: controller.verifyEmail,
                    validator: TValidator.validateEmail,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Iconsax.direct_right),
                      labelText: TTexts.email,
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwInputFields,
                  ),

                  /// password
                  Obx(
                    () => TextFormField(
                      obscureText: controller.hidePassword.value,
                      controller: controller.verifyPassword,
                      validator: (value) =>
                          TValidator.validateEmptyText('Password', value),
                      decoration: InputDecoration(
                        labelText: TTexts.password,
                        prefixIcon: const Icon(Iconsax.password_check),
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
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          controller.reAuthenticateEmailAndPasswordUser(),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(
                            0xFFE9C401), // Set the text color to white
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
                        'Verify',
                        style: TextStyle(
                            color: Colors.white), // Set the text color to white
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
