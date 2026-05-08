import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ForgotPassController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var isLoading = false.obs;

  Future<void> sendResetEmail(String email) async {
    try {
      if (email.isEmpty) {
        Get.snackbar("Error", "Please enter your email");
        return;
      }

      isLoading.value = true;

      await _auth.sendPasswordResetEmail(email: email.trim());

      Get.snackbar("Success", "Password reset email sent 📩");

    } on FirebaseAuthException catch (e) {
      String message = "Something went wrong";

      if (e.code == 'user-not-found') {
        message = "No user found with this email";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email format";
      }

      Get.snackbar("Error", message);

    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}