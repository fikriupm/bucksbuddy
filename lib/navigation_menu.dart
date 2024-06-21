import 'package:bucks_buddy/addFriendScreen.dart';
import 'package:bucks_buddy/features/home/homepage.dart';
import 'package:bucks_buddy/features/personalization/screens/settings/setting.dart';
import 'package:bucks_buddy/features/view_debt_analysis/screen/expenses/expenses.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bucks_buddy/utils/constants/colors.dart';
import 'package:bucks_buddy/utils/helpers/helper_functions.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 70,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          backgroundColor: darkMode
              ? TColors.black
              : const Color.fromARGB(255, 218, 202, 83),
          indicatorColor: darkMode
              ? TColors.white.withOpacity(0.1)
              : TColors.black.withOpacity(0.1),
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(
                icon: Icon(Iconsax.profile_2user), label: 'Friend'),
            NavigationDestination(
                icon: Icon(Iconsax.empty_wallet), label: 'Expenses'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const Homepage(),
    FriendScreen(),
    Expenses(),
    const SettingScreen(),
  ];
}
