import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class DebtDetailsSection extends StatelessWidget {
  const DebtDetailsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF0CA00).withOpacity(0.82),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            children: [
              // Add your image here
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.file_upload_outlined),
                // Adjust the height as needed
              ),

              TextButton(
                onPressed: () {},
                child: const Text(
                  "Own You",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight
                          .w600 // Set the color property instead of fontStyle
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: TSizes.spaceBtwItems,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            children: [
              // Add your image here
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.file_upload_outlined),
                // Adjust the height as needed
              ),

              TextButton(
                onPressed: () {},
                child: const Text(
                  "You Own",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight
                          .w600 // Set the color property instead of fontStyle
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
