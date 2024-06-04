import 'package:bucks_buddy/common/widgets/appbar/appbar.dart';
import 'package:bucks_buddy/common/widgets/heading/section_heading.dart';
import 'package:bucks_buddy/common/widgets/images/t_circular_image.dart';
import 'package:bucks_buddy/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:bucks_buddy/utils/constants/image_strings.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text('Profile'),
      ),

      /// -- Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 16.0), // Adjust the values as needed
          child: Column(
            children: [
              /// Profile Picture
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const TCircularImage(
                      image: TImages.user,
                      width: 80,
                      height: 80,
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text('Change Profile Picture')),
                  ],
                ),
              ),

              /// Details
              const SizedBox(height: TSizes.spaceBtwItems/2,),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems,),

              /// heading Profile Info
              const TSectionHeading(title: 'Proile Information', showActionButton: false,),
              const SizedBox(height: TSizes.spaceBtwItems,),
            
              TProfileMenu(title: 'Name', value: 'Nama Saya', onPressed: (){},),
              TProfileMenu(title: 'Username', value: 'nama02', onPressed: (){},),

              const SizedBox(height: TSizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),

              /// Heading Personal Info
              const TSectionHeading(title: 'Personal Information', showActionButton: false,),
              const SizedBox(height: TSizes.spaceBtwItems,),

              TProfileMenu(title: 'User ID', value: '45689', icon: Iconsax.copy, onPressed: (){}),
              TProfileMenu(title: 'E-mail', value: 'saya@gmail,com', onPressed: () {}),
              TProfileMenu(title: 'Phone Number', value: '+60 12347463', onPressed: () {}),
              TProfileMenu(title: 'Gender', value: 'Male', onPressed: (){}),
              TProfileMenu(title: 'Date of Birth', value: '10 Oct, 1994', onPressed: () {}),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems,),

              Center(
                child: TextButton(
                  onPressed: (){},
                  child: const Text('Close Account', style: TextStyle(color: Colors.red))) ,)

            ],
          ),
        ),
      ),
    );
  }
}


