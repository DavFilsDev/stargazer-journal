import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'router.dart';
import 'services/observation_service.dart';
import 'services/theme_notifier.dart';
import 'widgets/starfield_background.dart';

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

  // A single vivid "neon" accent — everything else (surfaces, borders,
  // glass panels) stays derived from it via ColorScheme.fromSeed, so the
  // futuristic look comes from *effects* (blur, glow, motion) rather
  // than from throwing many colors at the screen.
  static const Color _accent = Color(0xFF5B8CFF);

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
    // JetBrains Mono across the whole app — headings, body text,
    // buttons, form fields — for a consistent, technical look.
    final monoTextTheme = GoogleFonts.jetBrainsMonoTextTheme(base.textTheme);

    return base.copyWith(
      textTheme: monoTextTheme,
      // Transparent so the animated StarfieldBackground (mounted once
      // in `builder` below) always shows through every screen.
      scaffoldBackgroundColor: Colors.transparent,
      canvasColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        titleTextStyle: GoogleFonts.jetBrainsMono(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        indicatorColor: scheme.primary.withOpacity(0.22),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: scheme.primary.withOpacity(0.22),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface.withOpacity(0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary.withOpacity(0.25)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 1.4),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: scheme.surface.withOpacity(0.35),
        selectedColor: scheme.primary.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: scheme.primary.withOpacity(0.25)),
        ),
      ),
      dividerTheme: DividerThemeData(color: scheme.primary.withOpacity(0.15)),
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
      // Mounted once, outside the router's Navigator — the starfield
      // animation keeps running smoothly across route changes instead
      // of restarting on every new screen.
      builder: (context, child) => StarfieldBackground(child: child!),
    );
  }
}
