import 'dart:ui';

import 'package:flutter/material.dart';

/// A transparent, blurred app bar consistent with [GlassContainer] —
/// used instead of a plain [AppBar] so the starfield background shows
/// through it rather than sitting behind a flat color band.
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const GlassAppBar({super.key, required this.title, this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: AppBar(
          title: Text(title),
          actions: actions,
          backgroundColor: scheme.surface.withValues(alpha: 0.45),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: 1,
              color: scheme.primary.withValues(alpha: 0.2),
            ),
          ),
        ),
      ),
    );
  }
}
