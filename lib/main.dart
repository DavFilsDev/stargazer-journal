import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'router.dart';
import 'services/observation_service.dart';
import 'services/theme_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeNotifier = ThemeNotifier();
  await themeNotifier.loadFromPrefs();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeNotifier),
        ChangeNotifierProvider(create: (_) => ObservationService()),
      ],
      child: const StargazerJournalApp(),
    ),
  );
}

class StargazerJournalApp extends StatelessWidget {
  const StargazerJournalApp({super.key});

  // A single, restrained accent color (indigo) — used sparingly for
  // selection/emphasis only. Everything else in the UI stays neutral
  // grayscale, and no gradients are used anywhere.
  static const Color _accent = Color(0xFF3355CC);

  static final ColorScheme _lightScheme = ColorScheme.fromSeed(
    seedColor: _accent,
    brightness: Brightness.light,
  );

  static final ColorScheme _darkScheme = ColorScheme.fromSeed(
    seedColor: _accent,
    brightness: Brightness.dark,
  );

  static ThemeData _buildTheme(ColorScheme scheme) {
    final base = ThemeData(colorScheme: scheme, useMaterial3: true);
    // JetBrains Mono across the whole app (headings, body text, buttons,
    // form fields...) for a clean, technical, consistent look.
    final monoTextTheme = GoogleFonts.jetBrainsMonoTextTheme(base.textTheme);

    return base.copyWith(
      textTheme: monoTextTheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        titleTextStyle: GoogleFonts.jetBrainsMono(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();

    return MaterialApp.router(
      title: 'Stargazer Journal',
      debugShowCheckedModeBanner: false,
      themeMode: themeNotifier.themeMode,
      theme: _buildTheme(_lightScheme),
      darkTheme: _buildTheme(_darkScheme),
      routerConfig: appRouter,
    );
  }
}
