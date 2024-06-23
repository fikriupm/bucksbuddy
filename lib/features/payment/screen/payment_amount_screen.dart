import 'package:bucks_buddy/common/styles/spacing_styles.dart';
import 'package:bucks_buddy/features/payment/controllers/payment_controller.dart';
import 'package:bucks_buddy/utils/constants/image_strings.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:bucks_buddy/utils/device/device_utility.dart';
import 'package:bucks_buddy/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentAmountScreen extends StatefulWidget {
  const PaymentAmountScreen({Key? key}) : super(key: key);

  @override
  _PaymentAmountScreenState createState() => _PaymentAmountScreenState();
}

class _PaymentAmountScreenState extends State<PaymentAmountScreen> {
  final PaymentController paymentController = Get.put(PaymentController());

  @override
  void initState() {
    super.initState();
    // Fetch debtor details in initState to avoid build phase issues
    paymentController.fetchDebtorDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DebtBuddy Pay'),
      ),
      body: Stack(children: [
        Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Amount',
                style:
                    TextStyle(fontSize: TSizes.md, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 15),
              Obx(() {
                bool isSuccess =
                    paymentController.paymentAmountError.value == 'Success';
                bool hasError =
                    paymentController.paymentAmountError.value.isNotEmpty &&
                        !isSuccess;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: paymentController.paymentAmount,
                      decoration: InputDecoration(
                        labelText: 'Enter To Pay',
                        prefixText: 'RM ',
                        hintText: '00.00',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: isSuccess ? Colors.green : Colors.blue,
                            width: 2,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: isSuccess ? Colors.green : Colors.blue,
                            width: 2,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: TSizes.lg,
                        ),
                        errorText: hasError
                            ? paymentController.paymentAmountError.value
                            : null,
                      ),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: TSizes.lg),
                      onChanged: (value) {
                        paymentController.paymentAmount.value;
                        paymentController.errorText(value);
                      },
                    ),
                    const SizedBox(height: 8),
                    if (isSuccess)
                      const Text(
                        'Success',
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                  ],
                );
              }),
              const SizedBox(height: TSizes.spaceBtwSections),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildAmountButton(paymentController, '20'),
                  _buildAmountButton(paymentController, '30'),
                  _buildAmountButton(paymentController, '40'),
                  _buildAmountButton(paymentController, '50'),
                ],
              ),
              SizedBox(height: TDeviceUtils.getScreenHeight() * 0.1),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text(
                  'From',
                  style: TextStyle(fontSize: TSizes.md),
                ),
                Obx(() {
                  return DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: paymentController.selectedMethod.value,
                      items:
                          paymentController.paymentMethods.map((String method) {
                        return DropdownMenuItem<String>(
                          value: method,
                          child: Text(method),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          paymentController.selectedMethod.value = newValue;
                        }
                      },
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.blueAccent,
                      ),
                      dropdownColor: Colors.white,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  );
                }),
              ]),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 80,
                    width: THelperFunctions.screenWidth() * 0.87,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                      shape: BoxShape.rectangle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                TImages.duitnow,
                                width: 50,
                                height: 50,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(() {
                                    if (paymentController
                                            .selectedMethod.value ==
                                        'Bank Account') {
                                      var debtorBankDetails = paymentController
                                          .debtorBankDetails.value;

                                      if (debtorBankDetails != null) {
                                        return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Account Number',
                                                style: TextStyle(
                                                    fontSize: TSizes.md,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                '${debtorBankDetails['AccountNumber']}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: TSizes.md,
                                                ),
                                              )
                                            ]);
                                      } else {
                                        return const Text(
                                          'No matching user found.',
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                          ),
                                        );
                                      }
                                    } else {
                                      return Container();
                                    }
                                  }),
                                  Obx(() {
                                    if (paymentController
                                            .selectedMethod.value ==
                                        'Phone Number') {
                                      final debtTicket =
                                          paymentController.debtTicket.value;
                                      if (debtTicket != null) {
                                        return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Phone Number',
                                                style: TextStyle(
                                                    fontSize: TSizes.md,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                paymentController
                                                    .phoneNumber.value,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: TSizes.md,
                                                ),
                                              )
                                            ]);
                                      } else {
                                        return const Text(
                                          'No matching user found.',
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                          ),
                                        );
                                      }
                                    } else {
                                      return Container();
                                    }
                                  }),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Payment Amount',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: TSizes.fontSizeSm + 2),
                    ),
                    Obx(() {
                      var debtAmount = paymentController.debtTicket.value;
                      if (debtAmount != null) {
                        return Text('RM ${debtAmount['amount']}',
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: TSizes.fontSizeLg + 2,
                                fontWeight: FontWeight.w600));
                      } else {
                        return const Text('Error in fetch debt ticket amount');
                      }
                    }),
                  ],
                ),
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
            child: Obx(() {
              bool isButtonEnabled =
                  paymentController.paymentAmountError.value == 'Success';
              return ElevatedButton(
                onPressed: isButtonEnabled
                    ? () {
                        paymentController.nextPageRecipientReferenceScreen();
                      }
                    : null, // Disable the button if the condition is not met
                child: const Text('Next'),
              );
            }),
          ),
        ),
      ]),
    );
  }

  Widget _buildAmountButton(
      PaymentController paymentController, String amount) {
    return Container(
      height: 50,
      width: 70,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.amber,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: () {
          paymentController.paymentAmount.text = amount;
          paymentController.errorText(amount);
        },
        child: Text(
          amount,
          style: const TextStyle(fontSize: TSizes.lg, color: Colors.black),
        ),
      ),
    );
  }
}
