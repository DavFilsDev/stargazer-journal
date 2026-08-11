import 'package:flutter/material.dart';

/// Optional 5th screen giving basic information about the app.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.auto_awesome, size: 48),
            SizedBox(height: 16),
            Text(
              'Stargazer Journal',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Stargazer Journal helps amateur astronomers browse a '
              'catalog of stars, planets, nebulae and galaxies, and keep '
              'a personal log of their observations: what they saw, '
              'when, and how it went.',
            ),
            SizedBox(height: 16),
            Text('Version 1.0.0'),
          ],
        ),
      ),
    );
  }
}
