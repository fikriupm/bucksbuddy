import 'package:bucks_buddy/common/styles/spacing_styles.dart';
import 'package:bucks_buddy/features/payment/controllers/payment_controller.dart';
import 'package:bucks_buddy/features/payment/screen/approval_screen.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:bucks_buddy/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecipientReferenceScreen extends StatelessWidget {
  final PaymentController paymentController = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DebtBuddy Pay'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: TSpacingStyle.paddingWithAppBarHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Details',
                    style: TextStyle(
                        fontSize: TSizes.lg, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                const Text('Enter Recipient reference'),
                const SizedBox(
                  height: TSizes.sm,
                ),
                TextField(
                  controller: paymentController.recipientReferenceInput,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  keyboardType: TextInputType.text,
                  onSubmitted: (value) =>
                      //nnti kene updated value ke firebase
                      paymentController.recipientReference(value),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                const Text('Enter Payment Details (Optional)'),
                const SizedBox(
                  height: TSizes.sm,
                ),
                TextField(
                  controller: paymentController.recipientOptionalInput,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  keyboardType: TextInputType.text,
                  onSubmitted: (value) =>
                      //nnti kene update kt firebase
                      paymentController.recipientOptional(value),
                ),
                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(() {
                      return Wrap(
                        spacing: 10,
                        children: [
                          ChoiceChip(
                            label: const Text('Food'),
                            onSelected: (selected) {
                              paymentController.choiceChipSelected('Food');
                            },
                            selected: paymentController.choiceSelected.value ==
                                'Food',
                            checkmarkColor: Color.fromARGB(255, 4, 4, 4),
                            selectedColor: Color.fromARGB(255, 186, 216, 11),
                            showCheckmark: true,
                          ),
                          ChoiceChip(
                            label: const Text('Personal'),
                            onSelected: (selected) {
                              paymentController.choiceChipSelected('Personal');
                            },
                            selected: paymentController.choiceSelected.value ==
                                'Personal',
                            checkmarkColor: Color.fromARGB(255, 4, 4, 4),
                            selectedColor: Color.fromARGB(255, 186, 216, 11),
                            showCheckmark: true,
                          ),
                          ChoiceChip(
                            label: const Text('Other'),
                            onSelected: (selected) {
                              paymentController.choiceChipSelected('Other');
                            },
                            selected: paymentController.choiceSelected.value ==
                                'Other',
                            checkmarkColor: Color.fromARGB(255, 4, 4, 4),
                            selectedColor: Color.fromARGB(255, 186, 216, 11),
                            showCheckmark: true,
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: TDeviceUtils.getBottomNavigationBarHeight(),
            left: TSizes.defaultSpace,
            right: TSizes.defaultSpace,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(ApprovalScreen());
                },
                child: const Text('Next'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
