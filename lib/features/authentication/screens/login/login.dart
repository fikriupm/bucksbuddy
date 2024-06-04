import 'package:bucks_buddy/features/authentication/screens/signup/signup.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:bucks_buddy/common/styles/spacing_styles.dart';
import 'package:bucks_buddy/common/widgets/login_signup/form_divider.dart';
import 'package:bucks_buddy/common/widgets/login_signup/social_buttons.dart';
import 'package:bucks_buddy/features/authentication/screens/login/widgets/login_form.dart';
import 'package:bucks_buddy/features/authentication/screens/login/widgets/login_header.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:bucks_buddy/utils/constants/text_strings.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: TSpacingStyle.paddingWithAppBarHeight,
            child: Column(
              children: [
                /// Logo, Title & Sub-Title
                const TLoginHeader(),

                /// FORM
                const TLoginForm(),

                /// Divider
                TFormDivider(
                  dividerText: TTexts.or.capitalize!,
                ),
                const SizedBox(
                  height: TSizes.spaceBtwSections / 2,
                ),

                /// Footer
                const TSocialButtons(),

                const SizedBox(
                    height:
                        16), // Add vertical spacing between buttons if needed
                GestureDetector(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(fontSize: 16.0, color: Colors.black),
                      children: <TextSpan>[
                        const TextSpan(text: "Don't have an account? "),
                        TextSpan(
                          text: 'Sign Up',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 0, 21, 255),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const SignupScreen()));
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
