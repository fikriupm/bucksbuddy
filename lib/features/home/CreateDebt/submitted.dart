import 'package:bucks_buddy/features/home/CreateDebt/controller/debt_ticket_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubmittedPage extends StatelessWidget {
  const SubmittedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DebtTicketController controller = Get.put(DebtTicketController());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back button
      ),
      body: GestureDetector(
        onTap: () =>
            controller.navigateToHomePage(context), // Navigate to home on tap
        child: Center(
          child: Container(
            width: 350, // Adjust width according to your design
            padding: const EdgeInsets.all(16), // Padding around the content
            decoration: BoxDecoration(
              color: Colors.grey[200], // Grey background color
              borderRadius: BorderRadius.circular(8), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize
                  .min, // Ensure the box only takes the minimum height necessary
              children: <Widget>[
                Image.asset(
                  'assets/logos/check.png', // Adjust the path according to your asset structure
                  height: 80, // Adjust height of the image
                ),
                const SizedBox(height: 12),
                const Text(
                  'Thank You',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your form was submitted successfully.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
