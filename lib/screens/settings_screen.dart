import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/constants.dart';
import '../widgets/glass_container.dart';
import '../widgets/theme_toggle.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.medium),
        children: [
          Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.medium),
          GlassContainer(
            borderRadius: BorderRadius.circular(18),
            blurSigma: 14,
            opacity: 0.35,
            child: Column(
              children: [
                const ThemeToggle(),
                Divider(
                  height: 1,
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                ),
                const ListTile(
                  leading: Icon(Icons.notifications_outlined),
                  title: Text('Observation reminders'),
                  subtitle: Text('Not implemented in this demo'),
                  trailing: Switch(value: false, onChanged: null),
                ),
                Divider(
                  height: 1,
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About Stargazer Journal'),
                  onTap: () => context.push(AppRoutes.about),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
