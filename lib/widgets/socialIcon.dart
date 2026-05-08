import 'package:flutter/material.dart';

Widget socialIcon(String path){
  return Container(
    height: 60,
    width: 60,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withValues(alpha: 0.1),
      border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
      boxShadow: [BoxShadow(
        color: Colors.cyan.withValues(alpha: 0.4),
        blurRadius: 2,
        spreadRadius: 5,
      ),]
    ),
    child: Center(
      child: Image.asset(path, height: 28),
    ),
  );
}