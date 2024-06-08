import 'package:bucks_buddy/common/widgets/appbar/appbar.dart';
import 'package:bucks_buddy/features/personalization/controllers/update_name_controller.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:bucks_buddy/utils/constants/text_strings.dart';
import 'package:bucks_buddy/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ChangeName extends StatelessWidget {
  const ChangeName({super.key});
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateNameController());
    return Scaffold(
      // Custom Appbar
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          'Change Name',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headings
            Text(
              'Use real name for easy verification. This name will appear on several pages.',
              style: Theme.of(context).textTheme.labelMedium,
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            // Text field and Button
            Form(
              key: controller.updateUserNameFormkey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.name,
                    validator: (value) => TValidator.validateEmptyText('Name', value),
                    decoration: const InputDecoration(
                      labelText: TTexts.name,
                      prefixIcon: Icon(Iconsax.user),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.updateUserName(),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
