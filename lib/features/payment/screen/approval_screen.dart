import 'dart:ffi';

import 'package:bucks_buddy/features/payment/controllers/payment_controller.dart';
import 'package:bucks_buddy/features/payment/screen/payment_success_screen.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:bucks_buddy/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApprovalScreen extends StatelessWidget {
  final PaymentController paymentController = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DebtBuddy Pay'),
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Approval',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text('Payment Details', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'RM',
                      style: TextStyle(fontSize: TSizes.md),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      paymentController.paymentAmount.text,
                      style: const TextStyle(
                          fontSize: TSizes.lg + 6, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                const SizedBox(height: 50),
                Obx(() {
                  return Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Date: '),
                            Obx(() {
                              var date = paymentController.currentDate();
                              if (date.isNotEmpty) {
                                return Text(date);
                              } else {
                                return const Text('Error');
                              }
                            })
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Tranfser \nType'),
                            Text(paymentController.selectedMethod.value),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //read from previous screen
                            const Text('Recipient \nReferences: '),
                            Text(paymentController.recipientReferenceInput.text)
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Payment \nDetails: '),
                            Text(paymentController.recipientOptionalInput.text)
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Category: '),
                            Text(paymentController.choiceSelected.value)
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
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
                try {
                  //kt sini bru updated to firebase
                  paymentController.creditTransferApi();
                  Get.to(PaymentSuccessScreen());
                  //Get.snackbar('title', amount.toString());
                } catch (e) {
                  Get.snackbar('Error', e.toString());
                }
              },
              child: const Text('Pay now'),
            ),
          ),
        )
      ]),
    );
  }
}
