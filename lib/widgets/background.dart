import 'package:flutter/material.dart';

class QuizOproBackground extends StatelessWidget {
  final Widget child;
  const QuizOproBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
         image: DecorationImage(
           image: AssetImage('assets/images/background.png'),
           fit: BoxFit.cover,
           colorFilter: ColorFilter.mode(
               Colors.white.withValues(alpha: 0.2),
           BlendMode.darken,
           ),
         ),
        ),
        child: SafeArea(child: child),
      ),
    );
  }
}
