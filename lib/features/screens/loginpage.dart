import 'package:flutter/material.dart';
import 'package:quiz_app_with_gemini/widgets/animated_button.dart';
import 'package:quiz_app_with_gemini/widgets/custom_text_field.dart';
import 'package:quiz_app_with_gemini/widgets/terms_and_conditions.dart';
import '../../widgets/background.dart';
import '../../widgets/socialIcon.dart';
import 'signup_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return QuizOproBackground(
      child: SafeArea( // ✅ FIX 1
        child: SingleChildScrollView( // ✅ FIX 2
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),

                // 🔥 Logo
                Image.asset('assets/images/onboardingscreen.png', height: 80),
                const SizedBox(height: 10),
                Image.asset('assets/images/title.png', width: 300),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Colors.cyanAccent,
                      Colors.lightGreenAccent,
                      Colors.tealAccent,
                    ],
                  ).createShader(bounds),
                  child: const Text(
                    "Learn. Play. Compete.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // 🎯 Title
                const Text(
                  "Login to your account",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 30),

                // 🧾 Fields
                const CustomTextField(
                  hint: "Email Address",
                  icon: Icons.email,
                ),
                const CustomTextField(
                  hint: "Password",
                  icon: Icons.lock,
                  obscureText: true,
                ),

                // 🔗 Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton( // ✅ better UX
                    onPressed: () {},
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.cyanAccent),
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                // 🔗 Signup
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "New User? ",
                      style: TextStyle(color: Colors.white70),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement( // ✅ FIX
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  SignupPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.cyanAccent),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // 🔘 Button
                AnimatedButton(
                  text: "LOGIN",
                  gradientColors: const [
                    Colors.lightBlueAccent,
                    Colors.blueAccent,
                  ],
                  onTap: () {},
                ),

                const SizedBox(height: 30),

                // Divider
                Row(
                  children: const [
                    Expanded(child: Divider(color: Colors.white30)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "or login with",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.white30)),
                  ],
                ),

                const SizedBox(height: 30),

                // 🔵 Social Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    socialIcon("assets/icons/google.png"),
                    SizedBox(width: 20),
                    socialIcon("assets/icons/apple.png"),
                    SizedBox(width: 20),
                    socialIcon("assets/icons/facebook.png"),
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