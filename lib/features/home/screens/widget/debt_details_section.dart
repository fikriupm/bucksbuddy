import 'package:bucks_buddy/features/home/controllers/homepage_controller.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DebtDetailsSection extends StatelessWidget {
  DebtDetailsSection({
    super.key,
  });
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(() => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: homeController.isYouOweSelected.value ? 150 : 120,
              height: homeController.isYouOweSelected.value ? 60 : 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF0CA00).withOpacity(0.82),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.file_upload_outlined),
                  ),
                  GestureDetector(
                    onTap: () async {
                      homeController.isYouOweSelected.value = true;
                      homeController.isOweYouSelected.value = false;
                      homeController.currentselected.value = 'You Owe';
                      await homeController.loadCurrentUserData();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, bottom: 8.0, right: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.transparent,
                        ),
                        child: const Text(
                          "You Owe",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
        const SizedBox(
          width: TSizes.spaceBtwItems,
        ),
        Obx(() => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: homeController.isOweYouSelected.value ? 150 : 120,
              height: homeController.isOweYouSelected.value ? 60 : 40,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.file_download_outlined),
                  ),
                  GestureDetector(
                    onTap: () async {
                      homeController.isOweYouSelected.value = true;
                      homeController.isYouOweSelected.value = false;
                      homeController.currentselected.value = 'Owe You';
                      await homeController.loadCurrentUserData();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, bottom: 8.0, right: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.transparent,
                        ),
                        child: const Text(
                          "Owe You",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
