import 'package:bucks_buddy/common/widgets/images/t_circular_image.dart';
import 'package:bucks_buddy/features/personalization/controllers/user_controller.dart';
import 'package:bucks_buddy/utils/constants/colors.dart';
import 'package:bucks_buddy/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TUserProfileTile extends StatelessWidget {
  const TUserProfileTile({
    super.key, required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    return ListTile(
      leading: const TCircularImage(
        image: TImages.user, width: 50, height: 50, padding: 0,),
        title: Text(controller.user.value.fullName, style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.white),),
        subtitle: Text(controller.user.value.email, style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.white),),
        trailing: IconButton(onPressed: onPressed, icon: const Icon(Iconsax.edit, color: TColors.white,),),       
    );
  }
}