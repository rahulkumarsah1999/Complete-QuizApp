import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../features/controllers/forgotpasscontroller.dart';

class CustomDialog extends StatefulWidget {
  const CustomDialog({super.key});

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  final TextEditingController resetEmailcontroller = TextEditingController();

  final ForgotPassController controller = Get.put(ForgotPassController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          width: screenWidth * 0.85,
          padding: EdgeInsets.all(screenWidth * 0.06),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock_outline,
                color: Colors.lightBlueAccent,
                size: screenWidth * 0.15,
              ),
              SizedBox(height: screenWidth * 0.04),

              const Text(
                'Reset Password',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: screenWidth * 0.04),

              const Text(
                "Enter your email to reset your password",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),

              SizedBox(height: screenWidth * 0.07),

              /// 📧 Email Field
              TextField(
                controller: resetEmailcontroller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Email Address",
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.white54,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: screenWidth * 0.08),

              Row(
                children: [
                  /// ❌ Cancel
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white38),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// ✅ Send Button
                  Expanded(
                    child: Obx(() => controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        padding: EdgeInsets.symmetric(
                            vertical: screenWidth * 0.035),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        await controller.sendResetEmail(
                            resetEmailcontroller.text);

                        if (resetEmailcontroller.text.isNotEmpty) {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        "Send",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    resetEmailcontroller.dispose();
    super.dispose();
  }
}