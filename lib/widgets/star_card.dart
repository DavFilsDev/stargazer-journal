import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/star.dart';
import '../utils/constants.dart';
import 'glass_container.dart';

/// Reusable glass card summarizing a [Star] (thumbnail + name + type).
///
/// Used by [StarListScreen] for every item of the list/grid. Extracting
/// it here (rather than inlining a card in the list builder) means the
/// look can be changed in a single place across the whole app.
class StarCard extends StatelessWidget {
  final Star star;

  const StarCard({super.key, required this.star});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassContainer(
      borderRadius: BorderRadius.circular(18),
      blurSigma: 14,
      opacity: 0.35,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push(AppRoutes.starDetail(star.id)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 16 / 10,
                child: Hero(
                  tag: 'star-thumb-${star.id}',
                  child: _StarThumbnail(star: star),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.small),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      star.name,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      star.type.label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Placeholder "photo" for a celestial object: a translucent tinted
/// surface (so the animated starfield behind the whole app subtly
/// shows through) with a matching icon.
class _StarThumbnail extends StatelessWidget {
  final Star star;

  const _StarThumbnail({required this.star});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      color: scheme.primary.withOpacity(0.14),
      child: Center(
        child: Icon(_iconFor(star.type), size: 36, color: scheme.primary),
      ),
    );
  }

  IconData _iconFor(CelestialType type) {
    switch (type) {
      case CelestialType.star:
        return Icons.star_rounded;
      case CelestialType.planet:
        return Icons.public;
      case CelestialType.nebula:
        return Icons.blur_on;
      case CelestialType.galaxy:
        return Icons.auto_awesome;
    }
  }
}
