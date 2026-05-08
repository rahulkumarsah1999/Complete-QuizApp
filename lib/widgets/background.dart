import 'package:flutter/material.dart';

class QuizOproBackground extends StatelessWidget {
  final Widget child;
  const QuizOproBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
         image: DecorationImage(
           image: AssetImage('assets/images/background.png'),
           fit: BoxFit.cover,
           colorFilter: ColorFilter.mode(
               Colors.black.withValues(alpha: 0.5),
           BlendMode.darken,
           ),
         ),
        ),
        child: SafeArea(child: child),
      ),
    );
  }
}
