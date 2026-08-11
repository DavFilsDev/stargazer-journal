import 'package:flutter/material.dart';

/// Wraps [child] with a staggered fade + slide-up entrance animation.
///
/// Used to animate grid/list items in on first build: pass the item's
/// [index] so each one starts slightly after the previous one, giving a
/// cascading reveal instead of everything popping in at once.
class FadeSlideIn extends StatelessWidget {
  final Widget child;
  final int index;
  final Duration baseDelay;
  final Duration duration;

  const FadeSlideIn({
    super.key,
    required this.child,
    this.index = 0,
    this.baseDelay = const Duration(milliseconds: 40),
    this.duration = const Duration(milliseconds: 420),
  });

  @override
  Widget build(BuildContext context) {
    final delayMs = (baseDelay.inMilliseconds * index).clamp(0, 480);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration + Duration(milliseconds: delayMs),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        // Hold the item invisible for its share of the delay, then run
        // the fade/slide over the remaining time, by remapping value.
        final delayFraction = delayMs / (duration + Duration(milliseconds: delayMs)).inMilliseconds;
        final adjusted = ((value - delayFraction) / (1 - delayFraction)).clamp(0.0, 1.0);
        return Opacity(
          opacity: adjusted,
          child: Transform.translate(
            offset: Offset(0, (1 - adjusted) * 18),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
