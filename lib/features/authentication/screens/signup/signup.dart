import 'package:bucks_buddy/features/authentication/screens/login/login.dart';
import 'package:bucks_buddy/utils/constants/image_strings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bucks_buddy/common/widgets/login_signup/form_divider.dart';
import 'package:bucks_buddy/common/widgets/login_signup/social_buttons.dart';
import 'package:bucks_buddy/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:bucks_buddy/utils/constants/text_strings.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                // Center widget added here
                child: Image(
                  height: 120,
                  alignment: Alignment.center,
                  image: AssetImage(
                    TImages.logoMain,
                  ),
                ),
              ),

              /// Title
              Text(TTexts.signupTitle,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(
                height: TSizes.sm / 4,
              ),
              Text(TTexts.signupSubTitle,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              /// Form
              const TSignupForm(),

              const SizedBox(height: TSizes.spaceBtwSections / 2),
              //Divider
              TFormDivider(
                dividerText: TTexts.or.capitalize!,
              ),
              const SizedBox(height: TSizes.spaceBtwSections / 8),

              //social button
              const TSocialButtons(),

              const SizedBox(
                  height: 16), // Add vertical spacing between buttons if needed
              Center(
                // Center the text horizontally
                child: GestureDetector(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(fontSize: 16.0, color: Colors.black),
                      children: <TextSpan>[
                        const TextSpan(text: "Already have an account? "),
                        TextSpan(
                          text: 'Login',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 0, 21, 255),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
