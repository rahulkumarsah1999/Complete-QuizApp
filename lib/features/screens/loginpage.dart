import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app_with_gemini/widgets/animated_button.dart';
import 'package:quiz_app_with_gemini/widgets/custom_text_field.dart';
import 'package:quiz_app_with_gemini/widgets/terms_and_conditions.dart';
import '../../widgets/background.dart';
import '../../widgets/forgotpass_widget.dart';
import '../../widgets/socialIcon.dart';
import '../controllers/logincontroller.dart';
import 'signup_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final LoginController controller = Get.put(LoginController());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return QuizOproBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 30),

                Image.asset('assets/images/onboardingscreen.png', height: 80),
                const SizedBox(height: 10),
                Image.asset('assets/images/title.png', width: 300),

                const SizedBox(height: 20),

                const Text(
                  "Login to your account",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),

                const SizedBox(height: 30),

                /// 📧 Email
                CustomTextField(
                  hint: "Email Address",
                  icon: Icons.email,
                  controller: emailController,
                ),

                /// 🔐 Password
                CustomTextField(
                  hint: "Password",
                  icon: Icons.lock,
                  obscureText: true,
                  controller: passwordController,
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) =>  CustomDialog(),
                      );
                    },
                    child: const Text("Forgot Password?",
                        style: TextStyle(color: Colors.cyanAccent)),

                  ),
                ),

                /// 🔗 Signup
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("New User? ",
                        style: TextStyle(color: Colors.white70)),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => SignupPage()),
                        );
                      },
                      child: const Text("Sign Up",
                          style: TextStyle(color: Colors.cyanAccent)),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// 🔘 LOGIN BUTTON with loading
                Obx(() => controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : AnimatedButton(
                  text: "LOGIN",
                  gradientColors: const [
                    Colors.blue,
                    Colors.cyan
                  ],
                  onTap: () {
                    controller.loginUser(
                      emailController.text,
                      passwordController.text,
                    );
                  },
                )),

                const SizedBox(height: 30),

                Row(
                  children: const [
                    Expanded(child: Divider(color: Colors.white30)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("or login with",
                          style: TextStyle(color: Colors.white70)),
                    ),
                    Expanded(child: Divider(color: Colors.white30)),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    socialIcon("assets/icons/google.png"),
                    const SizedBox(width: 20),
                    socialIcon("assets/icons/apple.png"),
                    const SizedBox(width: 20),
                    socialIcon("assets/icons/facebook.png"),
                  ],
                ),

                const SizedBox(height: 40),

                termsText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}