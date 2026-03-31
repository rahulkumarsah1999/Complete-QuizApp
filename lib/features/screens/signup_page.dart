
import 'package:flutter/material.dart';
import 'package:quiz_app_with_gemini/features/screens/loginpage.dart';
import 'package:quiz_app_with_gemini/widgets/animated_button.dart';
import 'package:quiz_app_with_gemini/widgets/background.dart';
import 'package:quiz_app_with_gemini/widgets/custom_text_field.dart';
import 'package:quiz_app_with_gemini/widgets/socialIcon.dart';
import 'package:quiz_app_with_gemini/widgets/terms_and_conditions.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return QuizOproBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/onboardingscreen.png', height: 42),
                  ],
                ),
                const SizedBox(height: 6),

                // 🔥 Logo
                Image.asset('assets/images/title.png', width: 300),

                const SizedBox(height: 10),

                // 🎨 Gradient Tagline
                // ShaderMask(
                //   shaderCallback: (bounds) => const LinearGradient(
                //     colors: [
                //       Colors.cyanAccent,
                //       Colors.lightGreenAccent,
                //       Colors.tealAccent,
                //     ],
                //   ).createShader(bounds),
                //   child: const Text(
                //     "Learn. Play. Compete.",
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 24,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),

                const SizedBox(height: 10),

                // 📝 Description (FIXED)
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    "Fill your information below or register with your social account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 🧾 Fields
                const CustomTextField(
                  hint: "Full Name",
                  icon: Icons.person,
                ),
                const CustomTextField(
                  hint: "Email Address",
                  icon: Icons.mail_outline,
                ),
                const CustomTextField(
                  hint: "Password",
                  icon: Icons.lock,
                  obscureText: true,
                ),
                const CustomTextField(
                  hint: "Confirm Password",
                  icon: Icons.lock,
                  obscureText: true,
                ),

                const SizedBox(height: 15),

                // 🔗 Login Row (CENTERED FIX)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement( // 🔥 FIX
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Log In",
                        style: TextStyle(color: Colors.cyanAccent),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 🔘 Button
                AnimatedButton(
                  text: "SIGN UP",
                  gradientColors: const [
                    Colors.lightBlueAccent,
                    Colors.blueAccent,
                  ],
                  onTap: () {},
                ),

                const SizedBox(height: 20),

                // Divider
                Row(
                  children: const [
                    Expanded(child: Divider(color: Colors.white30)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "or Sign up with",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.white30)),
                  ],
                ),

                const SizedBox(height: 25),

                // 🔵 Social Icons (SPACING FIX)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    socialIcon('assets/icons/google.png'),
                    SizedBox(width: 20),
                    socialIcon('assets/icons/apple.png'),
                    SizedBox(width: 20),
                    socialIcon('assets/icons/facebook.png'),
                  ],
                ),

                const SizedBox(height: 40),

                // 📜 Terms
                 termsText(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}