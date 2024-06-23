import 'package:bucks_buddy/features/home/controllers/homepage_controller.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:bucks_buddy/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DebtAmount extends StatelessWidget {
  DebtAmount({
    super.key,
  });
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                TTexts.debt,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: TSizes.fontSizeMd,
                ),
              ),
              Obx(() {
                var currentselected = homeController.currentselected.value;
                var totalAmountYouOwn = homeController.totalAmountYouOwn;
                var totalAmountOwnYou = homeController.totalAmountOwnYou;
                if (currentselected == 'You Owe') {
                  return Text(
                    'RM ${totalAmountYouOwn.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: TSizes.lg,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600),
                  );
                } else if (currentselected == 'Owe You') {
                  return Text(
                    'RM ${totalAmountOwnYou.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: TSizes.lg,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600),
                  );
                }
                return const CircularProgressIndicator();
              })
            ],
          ),
        ),
      ],
    );
  }
}
