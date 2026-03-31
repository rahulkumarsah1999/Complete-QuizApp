import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;
  final List<Color> gradientColors;
  final double height;

  const AnimatedButton({
    super.key,
    required this.onTap,
    required this.text,
    this.gradientColors = const [Colors.cyan, Colors.blue],
    this.height = 55,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) {
        setState(() => isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => isPressed = false),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        height: widget.height,

        // 🔥 Scale animation
        transform: Matrix4.identity()
          ..scaleByDouble(
            isPressed ? 0.95 : 1.0,
            isPressed ? 0.95 : 1.0,
            1.0,
            1.0,
          ),

        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.gradientColors,
          ),
          borderRadius: BorderRadius.circular(30),

          // 🔥 Glow effect
          boxShadow: [
            BoxShadow(
              color: widget.gradientColors.first
                  .withValues(alpha: isPressed ? 0.3 : 0.7),
              blurRadius: isPressed ? 8 : 7,
              spreadRadius: 1,
            )
          ],
        ),

        child: Center(
          child: Text(
            widget.text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}