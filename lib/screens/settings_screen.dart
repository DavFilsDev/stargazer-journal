import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/constants.dart';
import '../widgets/theme_toggle.dart';

/// Settings screen: theme toggle plus a couple of secondary options.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.medium),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.medium),
            child: Text(
              'Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          const ThemeToggle(),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.notifications_outlined),
            title: Text('Observation reminders'),
            subtitle: Text('Not implemented in this demo'),
            trailing: Switch(value: false, onChanged: null),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About Stargazer Journal'),
            onTap: () => context.push(AppRoutes.about),
          ),
        ],
      ),
    );
  }
}
