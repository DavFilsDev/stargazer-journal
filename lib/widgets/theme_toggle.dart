import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/theme_notifier.dart';

/// Reusable light/dark theme switch, bound to [ThemeNotifier].
///
/// The leading icon animates (cross-fade + rotation) between the sun
/// and moon glyphs whenever the mode changes.
class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();

    return SwitchListTile(
      secondary: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        transitionBuilder: (child, animation) => RotationTransition(
          turns: animation,
          child: FadeTransition(opacity: animation, child: child),
        ),
        child: Icon(
          themeNotifier.isDarkMode ? Icons.dark_mode : Icons.light_mode,
          key: ValueKey(themeNotifier.isDarkMode),
        ),
      ),
      title: const Text('Dark mode'),
      subtitle: const Text('Switch between light and dark theme'),
      value: themeNotifier.isDarkMode,
      onChanged: (enabled) => themeNotifier.toggleDark(enabled),
    );
  }
}
