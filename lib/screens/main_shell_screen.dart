import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/constants.dart';
import '../widgets/adaptive_scaffold.dart';

/// Shell wrapping the two top-level destinations (Home, Settings) with
/// [AdaptiveScaffold], used as the `builder` of the router's `ShellRoute`
/// (see `router.dart`). `StarDetailScreen` and `ObservationFormScreen`
/// are pushed *outside* this shell, so they appear full-screen without
/// the bottom navigation / rail.
class MainShellScreen extends StatelessWidget {
  final Widget child;

  const MainShellScreen({super.key, required this.child});

  static const _destinations = [
    AdaptiveDestination(
      label: 'Explore',
      icon: Icons.explore_outlined,
      selectedIcon: Icons.explore,
    ),
    AdaptiveDestination(
      label: 'Settings',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
    ),
  ];

  int _indexForLocation(String location) {
    if (location.startsWith(AppRoutes.settings)) return 1;
    return 0;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.settings);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return AdaptiveScaffold(
      body: child,
      selectedIndex: _indexForLocation(location),
      onDestinationSelected: (index) =>
          _onDestinationSelected(context, index),
      destinations: _destinations,
    );
  }
}
