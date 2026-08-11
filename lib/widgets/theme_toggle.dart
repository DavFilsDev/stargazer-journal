import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/theme_notifier.dart';

/// Reusable light/dark theme switch, bound to [ThemeNotifier].
///
/// Placed in `widgets/` (not inlined in `SettingsScreen`) so it could be
/// dropped into another screen (e.g. a quick-settings menu) unchanged.
class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();

    return SwitchListTile(
      secondary: Icon(
        themeNotifier.isDarkMode ? Icons.dark_mode : Icons.light_mode,
      ),
      title: const Text('Dark mode'),
      subtitle: const Text('Switch between light and dark theme'),
      value: themeNotifier.isDarkMode,
      onChanged: (enabled) => themeNotifier.toggleDark(enabled),
    );
  }
}
