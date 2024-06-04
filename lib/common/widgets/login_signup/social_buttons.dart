
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

class TSocialButtons extends StatelessWidget {
  const TSocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center( // Center the Google sign-in button
          child: SignInButton(
            Buttons.google,
            text: "Continue with Google",
            onPressed: () {
              // Add your Google sign-up logic here
            },
          ),
        ),
      ],
    );
  }
}

