
import 'package:bucks_buddy/features/authentication/controllers/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_in_button/sign_in_button.dart';

class TSocialButtons extends StatelessWidget {
  const TSocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center( // Center the Google sign-in button
          child: SignInButton(
            Buttons.google,
            text: "Continue with Google",
            onPressed: () => controller.googleSignIn(),
          ),
        ),
      ],
    );
  }
}

