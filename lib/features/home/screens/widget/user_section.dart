import 'package:bucks_buddy/common/widgets/images/t_circular_image.dart';
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
        Obx(() {
          final networkImage = controller.user.value.profilePicture;
          final image = networkImage.isNotEmpty ? networkImage : TImages.user;
          return controller.imageUpLoading.value
              ? const TShimmerEffect(
                  width: 80,
                  height: 80,
                  radius: 80,
                )
              : TCircularImage(
                  image: image,
                  width: 80,
                  height: 80,
                  isNetworkImage: networkImage.isNotEmpty,
                );
        }),
        const SizedBox(width: TSizes.defaultSpace),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(TTexts.profile),
              Row(
                children: [
                  Obx(() {
                    if (controller.profileLoading.value) {
                      // Display a shimmer loading while user profile is being loaded
                      return const TShimmerEffect(width: 80, height: 15);
                    } else {
                      return Expanded(
                        child: Text(
                          controller.user.value.fullName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }
                  }),
                  const SizedBox(
                    width: TSizes.defaultSpace / 10,
                  ),
                  const Icon(
                    Icons.waving_hand_rounded,
                    size: TSizes.iconSm,
                  ),
                ],
              ),
            ],
          ),
        ),
        const Spacer(),
        const Padding(
          padding: EdgeInsets.only(right: TSizes.defaultSpace / 2),
          child: Icon(Icons.notifications_none_sharp),
        ),
      ],
    );
  }
}
