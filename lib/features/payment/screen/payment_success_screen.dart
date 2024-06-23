import 'dart:async';
import 'package:bucks_buddy/features/payment/controllers/payment_controller.dart';
import 'package:bucks_buddy/features/payment/screen/payment_generated_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentSuccessScreen extends StatefulWidget {
  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  final PaymentController paymentController = Get.find<PaymentController>();

  @override
  void initState() {
    super.initState();

    // Use WidgetsBinding.instance.addPostFrameCallback to delay state change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      paymentController.addPaymentDetails();
      paymentController.updateDebtStatus();

      // Start a timer that navigates to the next screen after 3 seconds
      Timer(const Duration(seconds: 3), () {
        Get.off(() => PaymentGeneratedScreen());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DebtBuddy Pay'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              return Text(
                paymentController.successfulFetchPayment.value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
