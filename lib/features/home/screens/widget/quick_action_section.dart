import 'package:bucks_buddy/features/home/CreateDebt/controller/debt_ticket_controller.dart';
import 'package:bucks_buddy/features/home/CreateDebt/createDebt.dart';
import 'package:bucks_buddy/features/home/screens/widget/view_all_debt_own.dart';
import 'package:bucks_buddy/features/payment/controllers/payment_controller.dart';
import 'package:bucks_buddy/utils/constants/image_strings.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    Get.put(PaymentController());
    final DebtTicketController debtTicketController =
        Get.put(DebtTicketController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(100)),
          child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateDebtPage()),
                );
              },
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
              onPressed: () {
                //Get.to(PaymentDetails());
              },
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
              onPressed: () async {
                try {
                  String debtorUsername = await debtTicketController
                      .fetchCurrentUsername(); // Fetch username from Firestore
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewAllDebtOwnScreen(
                            debtorUsername: debtorUsername)),
                  );
                } catch (e) {
                  // Handle error if username fetching fails
                  print('Error fetching username: $e');
                }
              },
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

Future<String> _fetchUsername() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        return userDoc['Username']
            as String; // Adjust based on your actual field name in Firestore
      } else {
        throw Exception('User document does not exist.');
      }
    } else {
      throw Exception('User is not authenticated.');
    }
  } catch (e) {
    throw Exception('Error fetching username: $e');
  }
}
