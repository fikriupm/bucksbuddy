
import 'package:bucks_buddy/utils/constants/image_strings.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:bucks_buddy/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';

class UserSection extends StatelessWidget {
  const UserSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Image(image: AssetImage(TImages.user)),
        Column(
          children: [
            Text(TTexts.profile),
            Row(
              children: [
                Text(TTexts.profilName),
                SizedBox(
                  width: TSizes.defaultSpace,
                ),
                Icon(
                  Icons.waving_hand_rounded,
                  size: TSizes.iconSm,
                )
              ],
            ),
          ],
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(right: TSizes.defaultSpace),
          child: Icon(Icons.notifications_none_sharp),
        )
      ],
    );
  }
}
