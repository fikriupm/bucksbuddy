import 'package:bucks_buddy/features/home/screens/widget/debt_amount.dart';
import 'package:bucks_buddy/features/home/screens/widget/debt_details_section.dart';
import 'package:bucks_buddy/features/home/screens/widget/nearby_friend_section.dart';
import 'package:bucks_buddy/features/home/screens/widget/quick_action_section.dart';
import 'package:bucks_buddy/features/home/screens/widget/recent_debt_section.dart';
import 'package:bucks_buddy/features/home/screens/widget/user_section.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 47.0, bottom: 10.0), // Adjust the values as needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: TSizes.spaceBtwItems),
              
              // user section
              UserSection(),
              SizedBox(height: TSizes.spaceBtwItems),

              // Debt amount section
              DebtAmount(),
              SizedBox(height: TSizes.spaceBtwItems),

              // Debt category section
              DebtDetailsSection(),
              SizedBox(height: TSizes.sm),

              // quick action
              QuickActionSection(),
              SizedBox(height: TSizes.sm),
              
              // under quick_action_section class
              QuickActionIcon(),
              SizedBox(height: TSizes.sm),
              QuickActionText(),
              SizedBox(height: TSizes.defaultSpace),

              // recents Split Bills
              RecentDebtSection(),
              SizedBox(height: TSizes.spaceBtwItems),

              SizedBox(height: TSizes.sm),

              // nearby friend
              NearbyFriendsSection(),

              // under nearby friend class
              FriendProfile(),
            ],
          ),
        ),
      ),
    );
  }
}
