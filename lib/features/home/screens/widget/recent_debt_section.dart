
import 'package:bucks_buddy/utils/constants/image_strings.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class RecentDebtSection extends StatelessWidget {
  const RecentDebtSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.horizontal(
            right: Radius.circular(10), left: Radius.circular(10)),
        color: const Color(0xFFF0CA00).withOpacity(0.82),
        shape: BoxShape.rectangle,
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent Split Bills",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: TSizes.fontSizeSm,
                    ),
                  ),
                  TextButton(
                      onPressed: () {},
                      child: const Text(
                        "View all",
                        style: TextStyle(
                            fontSize: TSizes.fontSizeSm,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
              const SizedBox(height: 200),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Positioned.fill(
            top: 30,
            left: 0,
            right: 0,
            bottom: 10,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "RM 28.00",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: TSizes.fontSizeMd),
                    ),
                    const Text(
                      "Mamak PKS",
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwItems / 2,
                    ),
                    const Text(
                      "Split With:",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                          fontSize: TSizes.fontSizeSm),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (int i = 0; i < profileImages.length; i++)
                          Align(
                            widthFactor: 0.5,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(profileImages[i]),
                            ),
                          ),
                        const SizedBox(
                          width: 10,
                        ),
                        const CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 20,
                          backgroundImage: AssetImage(TImages.plus1),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(
                      height: TSizes.defaultSpace,
                    ),
                    const Row(
                      children: [
                        Icon(Icons.calendar_month),
                        Text("Sunday, 12 June"),
                        SizedBox(
                          width: 50,
                        ),
                        Icon(Icons.watch_later_outlined),
                        Text('11.00 AM')
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 70,
              right: 9,
              child: Image.asset(
                TImages.groupImage,
              )),
        ],
      ),
    );
  }
}
