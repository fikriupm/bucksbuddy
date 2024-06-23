import 'package:bucks_buddy/common/styles/spacing_styles.dart';
import 'package:bucks_buddy/features/payment/controllers/payment_controller.dart';
import 'package:bucks_buddy/navigation_menu.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:bucks_buddy/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentGeneratedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PaymentController paymentController = Get.put(PaymentController());

    return Scaffold(
      body: Stack(children: [
        Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const Text(
                  'DebtBuddy Pay',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                const Text('Payment Details', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('RM'),
                    const SizedBox(width: 15),
                    Obx(() {
                      return Text(
                        paymentController.amount.value.toString(),
                        style: const TextStyle(
                            fontSize: TSizes.fontSizeLg + 10,
                            fontWeight: FontWeight.w600),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 30),
                Obx(() {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Completed\nTime '),
                            Text(paymentController.date.value)
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Recipient \nReferences '),
                            Text(paymentController.recipientReferenceInput.text)
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Recipient Details '),
                              Text(
                                  paymentController.recipientOptionalInput.text)
                            ]),
                        const SizedBox(height: 30),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Payment Id '),
                              Text(paymentController.paymentId.value)
                            ]),
                        const SizedBox(height: 30),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('DebtTicket Id '),
                              Text(paymentController.debtTicketId.value)
                            ]),
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
                  Get.to(const NavigationMenu());
                } catch (e) {
                  Get.snackbar('Error', e.toString());
                }
              },
              child: const Text('Return to Menu'),
            ),
          ),
        )
      ]),
    );
  }
}
