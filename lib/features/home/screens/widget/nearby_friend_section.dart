import 'package:bucks_buddy/utils/constants/image_strings.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class NearbyFriendsSection extends StatelessWidget {
  const NearbyFriendsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Text(
          "Nearby Friends",
          style: TextStyle(
              fontSize: TSizes.fontSizeLg, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}

class FriendProfile extends StatelessWidget {
  const FriendProfile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < profileImages.length; i++)
          Column(
            children: [
              Container(
                margin: const EdgeInsets.all(8.0),
                child: Image.asset(
                  profileImages[i],
                  width: 50, // Set the width of the image
                  height: 50, // Set the height of the image
                  fit: BoxFit.cover,
                ),
              ),
              Text(friendName[i])
            ],
          ),
      ],
    );
  }
}
