import 'package:bucks_buddy/common/styles/spacing_styles.dart';
import 'package:bucks_buddy/utils/device/device_utility.dart';
import 'package:bucks_buddy/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:bucks_buddy/features/home/controllers/homepage_controller.dart';
import 'package:bucks_buddy/features/home/screens/widget/debt_amount.dart';
import 'package:bucks_buddy/features/home/screens/widget/debt_details_section.dart';
import 'package:bucks_buddy/features/home/screens/widget/nearby_friend_section.dart';
import 'package:bucks_buddy/features/home/screens/widget/quick_action_section.dart';
import 'package:bucks_buddy/features/home/screens/widget/recent_debt_section.dart';
import 'package:bucks_buddy/features/home/screens/widget/user_section.dart';
import 'package:bucks_buddy/features/view_debt_analysis/controller/expenses_controller.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:get/get.dart';

class Homepage extends StatelessWidget {
  Homepage({Key? key}) : super(key: key);

  final HomeController homeController = Get.put(HomeController());
  final ExpensesController expensesController = Get.put(ExpensesController());
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: TSpacingStyle.paddingWithAppBarHeight / 20,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User section (fixed at the top)
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: TSizes.spaceBtwItems),
                  // User section
                  Padding(
                    padding:
                        EdgeInsets.only(top: TDeviceUtils.getAppBarHeight()),
                    child: UserSection(),
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Debt amount section
                      DebtAmount(),
                      const SizedBox(height: TSizes.spaceBtwItems),

                      // Debt category section
                      DebtDetailsSection(),
                      const SizedBox(height: TSizes.sm),

                      // Quick action section
                      const QuickActionSection(),
                      const SizedBox(height: TSizes.sm),

                      // Quick action icon, text, etc. (if they are widgets)
                      const QuickActionIcon(),
                      const SizedBox(height: TSizes.sm),
                      const QuickActionText(),
                      const SizedBox(height: TSizes.defaultSpace),


                      // Recent Split Bills
                      RecentDebtSection(),
                      const SizedBox(height: TSizes.spaceBtwItems),

                      // Nearby friend section
                      NearbyFriendsSection(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
