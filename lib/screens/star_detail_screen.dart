import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/star.dart';
import '../services/observation_service.dart';
import '../services/star_service.dart';
import '../utils/constants.dart';

/// Detail screen for a single [Star], resolved from the `:id` path
/// parameter set up in the router (see `router.dart`).
///
/// Also lists any observations already logged for this star, and offers
/// a button to log a new one via [AppRoutes.addObservation].
class StarDetailScreen extends StatelessWidget {
  final String starId;

  const StarDetailScreen({super.key, required this.starId});

  @override
  Widget build(BuildContext context) {
    final star = StarService.getById(starId);

    if (star == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Not found')),
        body: const Center(
          child: Text('This celestial object could not be found.'),
        ),
      );
    }

    final observations =
        context.watch<ObservationService>().getForStar(star.id);

    return Scaffold(
      appBar: AppBar(title: Text(star.name)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.medium),
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _DetailHero(type: star.type),
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          Text(star.name, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text(
            star.type.label,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Theme.of(context).colorScheme.secondary),
          ),
          const SizedBox(height: AppSpacing.medium),
          _InfoRow(label: 'Constellation', value: star.constellation),
          _InfoRow(
            label: 'Distance',
            value: '${star.distanceLightYears} light-years',
          ),
          _InfoRow(
            label: 'Apparent magnitude',
            value: star.magnitude.toStringAsFixed(2),
          ),
          const SizedBox(height: AppSpacing.medium),
          Text(star.description, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: AppSpacing.large),
          Row(
            children: [
              Text(
                'My observations',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () =>
                    context.push(AppRoutes.addObservation(star.id)),
                icon: const Icon(Icons.add),
                label: const Text('Log observation'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.small),
          if (observations.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.small),
              child: Text('No observation logged yet for this object.'),
            )
          else
            for (final observation in observations)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.nights_stay_outlined),
                  title: Text(observation.description),
                  subtitle: Text(observation.formattedDateTime),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < observation.rating; i++)
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _DetailHero extends StatelessWidget {
  final CelestialType type;

  const _DetailHero({required this.type});

  @override
  Widget build(BuildContext context) {
    final icon = switch (type) {
      CelestialType.star => Icons.star_rounded,
      CelestialType.planet => Icons.public,
      CelestialType.nebula => Icons.blur_on,
      CelestialType.galaxy => Icons.auto_awesome,
    };
    final scheme = Theme.of(context).colorScheme;

    return Container(
      color: scheme.surfaceContainerHighest,
      child: Center(
        child: Icon(icon, size: 64, color: scheme.primary),
      ),
    );
  }
}
