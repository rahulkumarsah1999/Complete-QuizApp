import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focusNode = FocusNode();
  bool isFocused = false;
  bool isHidden = true; // for password toggle

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });

    isHidden = widget.obscureText;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 10),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),

        // 🔥 Border color change
        border: Border.all(
          color: isFocused
              ? Colors.cyanAccent
              : Colors.white.withValues(alpha: 0.5),
          width: isFocused ? 1.5 : 1,
        ),

        // Glow
        boxShadow: isFocused
            ? [
          BoxShadow(
            color: Colors.cyanAccent.withValues(alpha: 0.1),
            blurRadius: 12,
            spreadRadius: 1,
          )
        ]
            : [],
      ),
      child: TextField(
        focusNode: _focusNode,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText ? isHidden : false,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.cyan,

        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: const TextStyle(color: Colors.white54),

          // Icon color change
          prefixIcon: Icon(
            widget.icon,
            color: isFocused ? Colors.cyanAccent : Colors.white70,
          ),

          //  Password toggle
          suffixIcon: widget.obscureText
              ? IconButton(
            icon: Icon(
              isHidden
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: Colors.white70,
            ),
            onPressed: () {
              setState(() {
                isHidden = !isHidden;
              });
            },
          )
              : null,

          border: InputBorder.none,
          contentPadding:  EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}