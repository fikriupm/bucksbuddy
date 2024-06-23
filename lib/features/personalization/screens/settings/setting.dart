import 'package:bucks_buddy/common/widgets/appbar/appbar.dart';
import 'package:bucks_buddy/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:bucks_buddy/common/widgets/heading/section_heading.dart';
import 'package:bucks_buddy/common/widgets/list_tile/settings_menu_tile.dart';
import 'package:bucks_buddy/common/widgets/list_tile/user_profile_tile.dart';
import 'package:bucks_buddy/data/repositories/authentication/authentication_repository.dart';
import 'package:bucks_buddy/features/personalization/screens/account_transaction/account_transaction.dart';
import 'package:bucks_buddy/features/personalization/screens/profile/profile.dart';
import 'package:bucks_buddy/utils/constants/colors.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// -- Header
            TPrimaryHeaderContainer(
                child: Column(
              children: [
                /// Appbar
                TAppBar(
                  title: Text(
                    'Profile',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .apply(color: TColors.white),
                  ),
                ),
                const SizedBox(
                  height: TSizes.spaceBtwSections / 10,
                ),

                /// User profile card
                TUserProfileTile(
                    onPressed: () => Get.to(() => const ProfileScreen())),
                const SizedBox(
                  height: TSizes.spaceBtwItems,
                ),
              ],
            )),

            /// Body
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  /// --- Account Setting
                  const TSectionHeading(
                      title: 'Account Setting', showActionButton: false),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  TSettingsMenuTile(
                    icon: Iconsax.bank,
                    title: 'Bank Account',
                    subTitle: 'Registered Account for Transaction',
                    onTap: () => Get.to(() => const TransactionAccountScreen()),
                  ),
                  const TSettingsMenuTile(
                      icon: Iconsax.notification,
                      title: 'Notifications',
                      subTitle: 'Set any kind of notification message'),
                  const TSettingsMenuTile(
                      icon: Iconsax.security_card,
                      title: 'Account Privacy',
                      subTitle: 'Manage data usage and connected accounts'),

                  /// -- App settings
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                  const TSectionHeading(
                    title: 'App Setting',
                    showActionButton: false,
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),
                  const TSettingsMenuTile(
                      icon: Iconsax.document_upload,
                      title: 'Load Data',
                      subTitle: 'Upload Data to your Cloud Firebase'),

                  TSettingsMenuTile(
                    icon: Iconsax.security_user,
                    title: 'Safe Mode',
                    subTitle: 'Search result is safe for all ages',
                    trailing: Switch(value: true, onChanged: (value) {}),
                  ),

                  /// -- Logout button
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                        onPressed: () =>
                            AuthenticationRepository.instance.logout(),
                        child: const Text('Logout')),
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections * 2.5,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
