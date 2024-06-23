import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:bucks_buddy/features/payment/controllers/payment_controller.dart';
import 'package:bucks_buddy/common/styles/spacing_styles.dart';
import 'package:bucks_buddy/utils/constants/image_strings.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';

class DebtBuddyPay extends StatelessWidget {
  final String debtTicketId;

  DebtBuddyPay({required this.debtTicketId});

  final PaymentController paymentController = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),
      body: Padding(
        padding: TSpacingStyle.paddingWithAppBarHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "DebtBuddy Pay",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            const Text(
              'Recipient Details',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Obx(
                () {
                  paymentController.fetchDebtTickeToPay(debtTicketId);
                  var debtTicket = paymentController.debtTicket.value;
                  // var user = paymentController.user.value;

                  if (debtTicket == null) {
                    return const Center(
                      child: Column(children: [
                        Text('No debt details found'),
                        SizedBox(
                          height: TSizes.spaceBtwInputFields,
                        ),
                        CircularProgressIndicator()
                      ]),
                    );
                  }

                  var data = debtTicket.data();
                  // var debt = user?.data();
                  // var bankDetails = userBankDetails?.data();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Image(
                            image: AssetImage(TImages.duitnow),
                            width: 50,
                            height: 50,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Phone Number',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${data?['phoneNumber'] ?? 'N/A'}',
                                      style: const TextStyle(
                                          fontSize: TSizes.fontSizeMd),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Name',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${data?['creditor'] ?? 'N/A'}',
                                      style: const TextStyle(
                                          fontSize: TSizes.fontSizeMd),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Account Number',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${data?['bankAccountNumber'] ?? 'N/A'}',
                                      style: const TextStyle(
                                          fontSize: TSizes.fontSizeMd),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Bank',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${data?['bankAccount'] ?? 'N/A'}',
                                      style: const TextStyle(
                                          fontSize: TSizes.fontSizeMd),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    paymentController.nextPagePaymentAmountScreen();
                  },
                  child: const Text('Next'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
