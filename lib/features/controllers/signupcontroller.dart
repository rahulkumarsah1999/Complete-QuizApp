import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:quiz_app_with_gemini/features/screens/loginpage.dart';

class SignupController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var isLoading = false.obs;

  Future<void> signupUser(
      String name,
      String email,
      String password,
      String confirmPassword,
      ) async {
    try {
      /// 🔍 Validation
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        Get.snackbar("Error", "All fields are required");
        return;
      }

      if (password != confirmPassword) {
        Get.snackbar("Error", "Passwords do not match");
        return;
      }

      if (password.length < 6) {
        Get.snackbar("Error", "Password must be at least 6 characters");
        return;
      }

      isLoading.value = true;

      /// 🔥 Firebase Signup
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      /// 👤 Save Name
      await userCredential.user?.updateDisplayName(name);

      Get.snackbar("Success", "Account created successfully 🎉");

      /// 👉 Navigate (optional)
      Get.offAll(LoginPage());

    } on FirebaseAuthException catch (e) {
      String message = "Signup failed";

      if (e.code == 'email-already-in-use') {
        message = "Email already registered";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email";
      } else if (e.code == 'weak-password') {
        message = "Weak password";
      }

      Get.snackbar("Error", message);

    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}