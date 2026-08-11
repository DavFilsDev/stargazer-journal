import 'dart:math';

import 'package:flutter/material.dart';

class _StarSeed {
  final double x;
  final double y;
  final double radius;
  final double phase;
  final double speed;

  const _StarSeed(this.x, this.y, this.radius, this.phase, this.speed);
}

/// Persistent animated starfield used as the app-wide backdrop.
///
/// Placed once in [MaterialApp.builder] (see `main.dart`) so it lives
/// behind every screen without restarting its animation on navigation.
/// Every [Scaffold] must use a transparent background for the effect to
/// show through (set globally via `ThemeData.scaffoldBackgroundColor`).
class StarfieldBackground extends StatefulWidget {
  final Widget child;
  final int starCount;

  const StarfieldBackground({
    super.key,
    required this.child,
    this.starCount = 90,
  });

  @override
  State<StarfieldBackground> createState() => _StarfieldBackgroundState();
}

class _StarfieldBackgroundState extends State<StarfieldBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_StarSeed> _stars;

  @override
  void initState() {
    super.initState();
    final random = Random(7);
    _stars = List.generate(widget.starCount, (_) {
      return _StarSeed(
        random.nextDouble(),
        random.nextDouble(),
        random.nextDouble() * 1.6 + 0.5,
        random.nextDouble() * pi * 2,
        random.nextDouble() * 0.5 + 0.15,
      );
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Soft radial glow anchored near the top, evoking deep space
        // without relying on a busy multi-stop gradient.
        DecoratedBox(
          decoration: BoxDecoration(color: scheme.surface),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(-0.4, -0.7),
              radius: 1.3,
              colors: [
                scheme.primary.withOpacity(0.22),
                scheme.surface.withOpacity(0),
              ],
            ),
          ),
        ),
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => CustomPaint(
              painter: _StarfieldPainter(
                stars: _stars,
                t: _controller.value,
                color: scheme.onSurface,
              ),
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}

class _StarfieldPainter extends CustomPainter {
  final List<_StarSeed> stars;
  final double t;
  final Color color;

  _StarfieldPainter({required this.stars, required this.t, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final star in stars) {
      final twinkle = (sin((t * 2 * pi / star.speed) + star.phase) + 1) / 2;
      paint.color = color.withOpacity(0.12 + twinkle * 0.45);
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StarfieldPainter oldDelegate) => true;
}
