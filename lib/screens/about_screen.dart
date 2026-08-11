import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../widgets/glass_app_bar.dart';
import '../widgets/glass_container.dart';

/// Optional 5th screen giving basic information about the app.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlassAppBar(title: 'About'),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: GlassContainer(
          borderRadius: BorderRadius.circular(18),
          blurSigma: 14,
          opacity: 0.35,
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome, size: 48, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: AppSpacing.medium),
              Text(
                'Stargazer Journal',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.small),
              const Text(
                'Stargazer Journal helps amateur astronomers browse a '
                'catalog of stars, planets, nebulae and galaxies, and keep '
                'a personal log of their observations: what they saw, '
                'when, and how it went.',
              ),
              const SizedBox(height: AppSpacing.medium),
              const Text('Version 1.0.0'),
            ],
          ),
        ),
      ),
    );
  }
}
