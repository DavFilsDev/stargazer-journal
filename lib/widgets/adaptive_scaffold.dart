import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'glass_container.dart';

/// A single top-level destination shown in the adaptive navigation.
class AdaptiveDestination {
  final String label;
  final IconData icon;
  final IconData selectedIcon;

  const AdaptiveDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });
}

/// Scaffold that switches its navigation chrome based on available width:
/// - narrower than [AppBreakpoints.tablet]  -> floating glass bottom bar
/// - [AppBreakpoints.tablet] or wider       -> glass navigation rail
///
/// Both are wrapped in [GlassContainer] so the animated starfield behind
/// the app subtly shows through the navigation chrome, consistent with
/// every other panel in the app.
class AdaptiveScaffold extends StatelessWidget {
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<AdaptiveDestination> destinations;

  const AdaptiveScaffold({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= AppBreakpoints.tablet;

        if (isTablet) {
          return Scaffold(
            body: Row(
              children: [
                GlassContainer(
                  borderRadius: BorderRadius.zero,
                  blurSigma: 18,
                  opacity: 0.35,
                  child: NavigationRail(
                    selectedIndex: selectedIndex,
                    onDestinationSelected: onDestinationSelected,
                    labelType: NavigationRailLabelType.all,
                    destinations: [
                      for (final d in destinations)
                        NavigationRailDestination(
                          icon: Icon(d.icon),
                          selectedIcon: Icon(d.selectedIcon),
                          label: Text(d.label),
                        ),
                    ],
                  ),
                ),
                Expanded(child: body),
              ],
            ),
          );
        }

        return Scaffold(
          extendBody: true,
          body: body,
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.medium,
              0,
              AppSpacing.medium,
              AppSpacing.medium,
            ),
            child: GlassContainer(
              borderRadius: BorderRadius.circular(24),
              blurSigma: 20,
              opacity: 0.45,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: NavigationBar(
                  height: 64,
                  selectedIndex: selectedIndex,
                  onDestinationSelected: onDestinationSelected,
                  destinations: [
                    for (final d in destinations)
                      NavigationDestination(
                        icon: Icon(d.icon),
                        selectedIcon: Icon(d.selectedIcon),
                        label: d.label,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
