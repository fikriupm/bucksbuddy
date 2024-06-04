import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:bucks_buddy/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';

class DebtAmount extends StatelessWidget {
  const DebtAmount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                TTexts.debt,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: TSizes.fontSizeMd,
                ),
              ),
              Text(
                TTexts.debtAmount,
                style: TextStyle(
                    fontSize: TSizes.lg,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
