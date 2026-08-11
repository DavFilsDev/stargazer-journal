import 'dart:ui';

import 'package:flutter/material.dart';

/// A frosted-glass panel: a blurred, semi-transparent surface with a
/// thin glowing border. This is the single building block behind the
/// app's "futuristic" look — cards, hero panels, the nav bar and the
/// app bars are all built from it, so the effect stays consistent
/// everywhere instead of being a one-off decoration.
class GlassContainer extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double blurSigma;
  final double opacity;
  final Color? tint;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.padding,
    this.margin,
    this.blurSigma = 20,
    this.opacity = 0.5,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: (tint ?? scheme.surface).withValues(alpha: opacity),
              borderRadius: borderRadius,
              border: Border.all(
                color: scheme.primary.withValues(alpha: 0.25),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.08),
                  blurRadius: 24,
                  spreadRadius: -4,
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
