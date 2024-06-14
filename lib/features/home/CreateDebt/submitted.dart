import 'package:bucks_buddy/features/home/homepage.dart';
import 'package:flutter/material.dart';

class SubmittedPage extends StatelessWidget {
  const SubmittedPage({super.key});

  void _navigateToHomePage(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => Homepage()), // Adjust the HomePage path
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back button
      ),
      body: GestureDetector(
        onTap: () => _navigateToHomePage(context), // Navigate to home on tap
        child: Center(
          child: Container(
            width: 350, // Adjust width according to your design
            padding: EdgeInsets.all(16), // Padding around the content
            decoration: BoxDecoration(
              color: Colors.grey[200], // Grey background color
              borderRadius: BorderRadius.circular(8), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: Offset(0, 2),
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
                SizedBox(height: 12),
                Text(
                  'Thank You',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Text(
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
