import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/about_screen.dart';
import 'screens/main_shell_screen.dart';
import 'screens/observation_form_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/star_detail_screen.dart';
import 'screens/star_list_screen.dart';
import 'utils/constants.dart';

/// Builds a [CustomTransitionPage] with a fade + subtle rise-in
/// transition, used for every route so navigation feels smooth and
/// consistent instead of relying on the default platform transition.
CustomTransitionPage<void> _fadeThroughPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 320),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: Transform.translate(
          offset: Offset(0, (1 - curved.value) * 16),
          child: child,
        ),
      );
    },
  );
}

/// Single declarative router configuration for the whole app.
///
/// - `/` and `/settings` live inside a [ShellRoute] so they share the
///   adaptive bottom navigation bar / navigation rail.
/// - `/star/:id` and `/star/:id/observe` are pushed on top of the shell
///   (full-screen, with their own back button), `/star/:id/observe`
///   nested under `/star/:id` as specified in the design doc.
/// - Every route uses [_fadeThroughPage] for a consistent animated
///   transition between screens.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShellScreen(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          pageBuilder: (context, state) => _fadeThroughPage(
            key: state.pageKey,
            child: const StarListScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.settings,
          pageBuilder: (context, state) => _fadeThroughPage(
            key: state.pageKey,
            child: const SettingsScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/star/:id',
      pageBuilder: (context, state) => _fadeThroughPage(
        key: state.pageKey,
        child: StarDetailScreen(starId: state.pathParameters['id']!),
      ),
      routes: [
        GoRoute(
          path: 'observe',
          pageBuilder: (context, state) => _fadeThroughPage(
            key: state.pageKey,
            child: ObservationFormScreen(starId: state.pathParameters['id']!),
          ),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.about,
      pageBuilder: (context, state) => _fadeThroughPage(
        key: state.pageKey,
        child: const AboutScreen(),
      ),
    ),
  ],
);
