import 'package:bucks_buddy/features/home/controllers/homepage_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NearbyFriendsSection extends StatelessWidget {
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Nearby Friends",
          style: TextStyle(
            fontSize: 24, // Adjust the font size as needed
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10), // Add some spacing
        Obx(() {
          homeController.fetchAllFriends();
          var friendNames = homeController.friendNames;
          if (friendNames.isEmpty) {
            return const Text("No friends nearby");
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < friendNames.length; i++)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade300, // Use a shade of grey
                          ),
                          child: homeController.friendImages.length > i &&
                                  isValidUrl(homeController.friendImages[i])
                              ? ClipOval(
                                  child: Image.network(
                                    homeController.friendImages[i],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(Icons.person,
                                  size: 40, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          homeController.friendNames[i],
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          );
        }),
      ],
    );
  }

  bool isValidUrl(String url) {
    // A simple URL validation, you might want to improve this
    Uri uri = Uri.tryParse(url) ?? Uri();
    return uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
  }
}
