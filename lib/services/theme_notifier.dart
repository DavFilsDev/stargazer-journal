import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the app's [ThemeMode] (light / dark / system) and persists the
/// user's choice across app restarts using [SharedPreferences].
///
/// Screens read the current mode via `Provider.of<ThemeNotifier>` and
/// call [setThemeMode] to change it — no screen touches
/// `SharedPreferences` directly.
class ThemeNotifier extends ChangeNotifier {
  static const _prefsKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Loads the previously saved theme choice, if any.
  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    switch (saved) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      default:
        _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, mode.name);
  }

  /// Convenience toggle between light and dark (ignores "system").
  Future<void> toggleDark(bool enableDark) {
    return setThemeMode(enableDark ? ThemeMode.dark : ThemeMode.light);
  }
}
