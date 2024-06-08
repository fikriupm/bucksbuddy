import 'package:bucks_buddy/features/personalization/controllers/user_controller.dart';
import 'package:bucks_buddy/utils/constants/image_strings.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:bucks_buddy/utils/constants/text_strings.dart';
import 'package:bucks_buddy/utils/shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserSection extends StatelessWidget {
  const UserSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return Row(
      children: [
        const Image(image: AssetImage(TImages.user)),
        Column(
          children: [
            const Text(TTexts.profile),
            Row(
              children: [
                Obx(() {
                  if (controller.profileLoading.value) {
                    //display a shimmer loading while user profile is being laoded
                    return const TShimmerEffect(width: 80, height: 15);
                  } else {
                    return Text(controller.user.value.fullName);
                  }
                }),
                const SizedBox(
                  width: TSizes.defaultSpace,
                ),
                const Icon(
                  Icons.waving_hand_rounded,
                  size: TSizes.iconSm,
                )
              ],
            ),
          ],
        ),
        const Spacer(),
        const Padding(
          padding: EdgeInsets.only(right: TSizes.defaultSpace),
          child: Icon(Icons.notifications_none_sharp),
        )
      ],
    );
  }
}
