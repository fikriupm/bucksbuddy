
import 'package:bucks_buddy/utils/constants/image_strings.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class QuickActionSection extends StatelessWidget {
  const QuickActionSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Quick Action",
              style: TextStyle(
                  fontSize: TSizes.fontSizeLg * 1.2,
                  fontWeight: FontWeight.bold),
            ),
            TextButton(
                onPressed: () {},
                child: const Text(
                  "View all",
                  style: TextStyle(
                      fontSize: TSizes.fontSizeSm, fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ],
    );
  }
}

class QuickActionIcon extends StatelessWidget {
  const QuickActionIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(100)),
          child: IconButton(
              onPressed: () {},
              icon: const Image(
                image: AssetImage(TImages.createDebt),
              )),
        ),
        const SizedBox(
          width: TSizes.spaceBtwItems,
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(100)),
          child: IconButton(
              onPressed: () {},
              icon: const Image(
                image: AssetImage(TImages.splitBills),
              )),
        ),
        const SizedBox(
          width: TSizes.spaceBtwItems,
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(100)),
          child: IconButton(
              onPressed: () {},
              icon: const Image(
                image: AssetImage(TImages.viewDebt),
              )),
        ),
      ],
    );
  }
}

class QuickActionText extends StatelessWidget {
  const QuickActionText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "Create Debt \nTicket",
          textAlign: TextAlign.center,
        ),
        SizedBox(
          width: TSizes.spaceBtwItems,
        ),
        Text("Split Bills"),
        SizedBox(
          width: TSizes.spaceBtwItems,
        ),
        Text("View Debt")
      ],
    );
  }
}
