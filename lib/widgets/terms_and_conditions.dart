import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Widget termsText (){
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: RichText(
        textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(color: Colors.white70,fontSize: 12),
        children: [
          TextSpan(text: "By continuing, you agree to Our "),
          TextSpan(
            text: "Terms & Conditions",
            style: TextStyle(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = (){},
          ),
        ],
      ),
    ),
  );
}