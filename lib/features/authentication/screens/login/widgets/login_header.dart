import 'package:flutter/material.dart';
import 'package:bucks_buddy/utils/constants/image_strings.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:bucks_buddy/utils/constants/text_strings.dart';

class TLoginHeader extends StatelessWidget {
  const TLoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          // Center widget added here
          child: Image(
            height: 200,
            alignment: Alignment.center,
            image: AssetImage(
              TImages.logoMain,
            ),
          ),
        ),
        Center(
            child: Text(TTexts.loginTitle,
                style: Theme.of(context).textTheme.headlineMedium)),
        const SizedBox(
          height: TSizes.sm / 4,
        ),
        Text(TTexts.loginSubTitle,
            style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
