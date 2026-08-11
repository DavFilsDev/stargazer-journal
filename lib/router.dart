import 'package:go_router/go_router.dart';

import 'screens/about_screen.dart';
import 'screens/main_shell_screen.dart';
import 'screens/observation_form_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/star_detail_screen.dart';
import 'screens/star_list_screen.dart';
import 'utils/constants.dart';

/// Single declarative router configuration for the whole app.
///
/// - `/` and `/settings` live inside a [ShellRoute] so they share the
///   adaptive bottom navigation bar / navigation rail.
/// - `/star/:id` and `/star/:id/observe` are pushed on top of the shell
///   (full-screen, with their own back button), `/star/:id/observe`
///   nested under `/star/:id` as specified in the design doc.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShellScreen(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const StarListScreen(),
        ),
        GoRoute(
          path: AppRoutes.settings,
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/star/:id',
      builder: (context, state) => StarDetailScreen(
        starId: state.pathParameters['id']!,
      ),
      routes: [
        GoRoute(
          path: 'observe',
          builder: (context, state) => ObservationFormScreen(
            starId: state.pathParameters['id']!,
          ),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.about,
      builder: (context, state) => const AboutScreen(),
    ),
  ],
);
