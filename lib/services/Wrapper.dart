import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../features/screens/home_screen.dart';
import '../features/screens/loginpage.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            return  HomeScreen();
          } else {
            return  LoginPage();
          }
        },
      ),
    );
  }
}