import 'dart:ffi';

import 'package:bucks_buddy/features/home/CreateDebt/controller/debt_ticket_controller.dart';
import 'package:bucks_buddy/features/home/CreateDebt/createDebt.dart';
import 'package:bucks_buddy/features/home/screens/widget/view_all_debt_own.dart';
import 'package:bucks_buddy/features/home/screens/widget/view_all_debt_from_paid.dart';
import 'package:bucks_buddy/features/home/screens/widget/view_all_debt_paid_screen.dart';
import 'package:bucks_buddy/features/home/screens/widget/view_all_debt_ticket.dart';
import 'package:bucks_buddy/features/home/screens/widget/view_all_debt_to_paid.dart';
import 'package:bucks_buddy/features/payment/controllers/payment_controller.dart';
import 'package:bucks_buddy/utils/constants/image_strings.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuickActionSection extends StatelessWidget {
  const QuickActionSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final DebtTicketController debtTicketController =
        Get.put(DebtTicketController());
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
            // TextButton(
            //   onPressed: () async {
            //     try {
            //       // Fetch username from Firestore
            //       String debtorUsername =
            //           await debtTicketController.fetchCurrentUsername();

            //       // Navigate to the new screen with the fetched username
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => ViewAllDebtToPaidScreen(
            //               debtorUsername: debtorUsername),
            //         ),
            //       );
            //     } catch (e) {
            //       // Handle the error appropriately here, e.g., show a snackbar or dialog
            //       print("Error fetching username: $e");
            //     }
            //   },
            //   child: const Text(
            //     "View all",
            //     style: TextStyle(
            //       fontSize: TSizes.fontSizeSm,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
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
               onPressed: () async {
                try {
                  debtTicketController.debtorUsername.value =
                      await debtTicketController.fetchCurrentUsername();
                  var debtorUsername =
                      debtTicketController.debtorUsername.value;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewAllDebtTicketsPaidScreen(
                            debtorUsername: debtorUsername)),
                  );
                } catch (e) {
                  // Handle error if username fetching fails
                  print('Error fetching username: $e');
                }
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
                  debtTicketController.debtorUsername.value =
                      await debtTicketController.fetchCurrentUsername();
                  var debtorUsername =
                      debtTicketController.debtorUsername.value;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewAllDebtTicketsScreen(
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
        Text(
          "Debt Ticket \nSettled",
          textAlign: TextAlign.center,
        ),
        SizedBox(
          width: TSizes.spaceBtwItems,
        ),
        Text(
          "View Debt \nTickets",
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
