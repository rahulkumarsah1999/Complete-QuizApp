import 'dart:math';
import 'package:flutter/material.dart';

class SparkleBackground extends StatefulWidget {
  const SparkleBackground({super.key});

  @override
  State<SparkleBackground> createState() => _SparkleBackgroundState();
}

class _SparkleBackgroundState extends State<SparkleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  final _random = Random(7);
  late List<_Star> _stars;

  @override
  void initState() {
    super.initState();
    _stars = List.generate(
      30,
          (i) => _Star(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 2.5 + 0.5,
        phase: _random.nextDouble() * 2 * pi,
        speed: _random.nextDouble() * 0.5 + 0.2,
      ),
    );
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _ctrl,
    builder: (_, __) => CustomPaint(
      painter: _StarPainter(_stars, _ctrl.value),
      child: const SizedBox.expand(),
    ),
  );

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}

class _Star {
  final double x, y, size, phase, speed;
  const _Star(
      {required this.x,
        required this.y,
        required this.size,
        required this.phase,
        required this.speed});
}

class _StarPainter extends CustomPainter {
  final List<_Star> stars;
  final double t;
  _StarPainter(this.stars, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in stars) {
      final opacity = (sin(t * 2 * pi * s.speed + s.phase) + 1) / 2;
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: opacity * 0.6)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
          Offset(s.x * size.width, s.y * size.height), s.size, paint);
    }
  }

  @override
  bool shouldRepaint(_StarPainter old) => true;
}