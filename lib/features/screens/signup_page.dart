import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app_with_gemini/features/screens/loginpage.dart';
import 'package:quiz_app_with_gemini/widgets/animated_button.dart';
import 'package:quiz_app_with_gemini/widgets/background.dart';
import 'package:quiz_app_with_gemini/widgets/custom_text_field.dart';
import 'package:quiz_app_with_gemini/widgets/socialIcon.dart';
import 'package:quiz_app_with_gemini/widgets/terms_and_conditions.dart';

import '../controllers/signupcontroller.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final SignupController controller = Get.put(SignupController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return QuizOproBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 20),

                /// 🔝 Logo
                Row(
                  children: [
                    Image.asset('assets/images/onboardingscreen.png', height: 42),
                  ],
                ),
                const SizedBox(height: 6),
                Image.asset('assets/images/title.png', width: 300),

                const SizedBox(height: 15),

                /// 📝 Description
                const Text(
                  "Fill your information below or register with your social account",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),

                const SizedBox(height: 25),

                /// 🧾 Fields
                CustomTextField(
                  hint: "Full Name",
                  icon: Icons.person,
                  controller: nameController,
                ),
                CustomTextField(
                  hint: "Email Address",
                  icon: Icons.mail_outline,
                  controller: emailController,
                ),
                CustomTextField(
                  hint: "Password",
                  icon: Icons.lock,
                  obscureText: true,
                  controller: passwordController,
                ),
                CustomTextField(
                  hint: "Confirm Password",
                  icon: Icons.lock,
                  obscureText: true,
                  controller: confirmPasswordController,
                ),

                const SizedBox(height: 15),

                /// 🔗 Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? ",
                        style: TextStyle(color: Colors.white70)),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LoginPage()),
                        );
                      },
                      child: const Text("Log In",
                          style: TextStyle(color: Colors.cyanAccent)),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// 🔘 Button with Loading
                Obx(() => controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : AnimatedButton(
                  text: "SIGN UP",
                  gradientColors: const [
                    Colors.lightBlueAccent,
                    Colors.blueAccent,
                  ],
                  onTap: () {
                    controller.signupUser(
                      nameController.text,
                      emailController.text,
                      passwordController.text,
                      confirmPasswordController.text,
                    );
                  },
                )),

                const SizedBox(height: 20),

                /// Divider
                Row(
                  children: const [
                    Expanded(child: Divider(color: Colors.white30)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("or Sign up with",
                          style: TextStyle(color: Colors.white70)),
                    ),
                    Expanded(child: Divider(color: Colors.white30)),
                  ],
                ),

                const SizedBox(height: 25),

                /// 🔵 Social Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    socialIcon('assets/icons/google.png'),
                    const SizedBox(width: 20),
                    socialIcon('assets/icons/apple.png'),
                    const SizedBox(width: 20),
                    socialIcon('assets/icons/facebook.png'),
                  ],
                ),

                const SizedBox(height: 40),

                /// 📜 Terms
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