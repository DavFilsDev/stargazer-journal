import 'package:flutter/material.dart';

import '../models/star.dart';
import '../services/star_service.dart';
import '../utils/constants.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/glass_container.dart';
import '../widgets/star_card.dart';
import '../widgets/star_search_bar.dart';

/// Home screen: search/filter field on top, list (mobile) or grid
/// (tablet+) of [StarCard]s below, each animating in with [FadeSlideIn].
///
/// All data comes from [StarService] — this screen holds only UI state
/// (the current search text and type filter), never the catalog itself.
class StarListScreen extends StatefulWidget {
  const StarListScreen({super.key});

  @override
  State<StarListScreen> createState() => _StarListScreenState();
}

class _StarListScreenState extends State<StarListScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  CelestialType? _typeFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = StarService.search(_query, type: _typeFilter);

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.medium,
              AppSpacing.medium,
              AppSpacing.medium,
              AppSpacing.small,
            ),
            child: GlassContainer(
              borderRadius: BorderRadius.circular(20),
              blurSigma: 16,
              opacity: 0.35,
              padding: const EdgeInsets.all(AppSpacing.medium),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Stargazer Journal',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.small),
                  StarSearchBar(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _query = value),
                  ),
                  const SizedBox(height: AppSpacing.small),
                  _TypeFilterRow(
                    selected: _typeFilter,
                    onSelected: (type) => setState(() => _typeFilter = type),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: results.isEmpty
                ? const _EmptyResults()
                : _AdaptiveResultsView(stars: results),
          ),
        ],
      ),
    );
  }
}

/// Row of filter chips to narrow the catalog down to a single
/// [CelestialType], in addition to free-text search.
class _TypeFilterRow extends StatelessWidget {
  final CelestialType? selected;
  final ValueChanged<CelestialType?> onSelected;

  const _TypeFilterRow({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final type in CelestialType.values)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.small),
              child: FilterChip(
                label: Text(type.label),
                selected: selected == type,
                onSelected: (isSelected) =>
                    onSelected(isSelected ? type : null),
              ),
            ),
        ],
      ),
    );
  }
}

/// Switches between a single-column [ListView] on narrow screens and a
/// multi-column [GridView] on wide screens. Each item fades/slides in
/// with a small stagger based on its index.
class _AdaptiveResultsView extends StatelessWidget {
  final List<Star> stars;

  const _AdaptiveResultsView({required this.stars});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= AppBreakpoints.tablet;

        if (isWide) {
          final columns = (constraints.maxWidth / 260).floor().clamp(2, 5);
          return GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.medium),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: AppSpacing.medium,
              crossAxisSpacing: AppSpacing.medium,
              childAspectRatio: 0.85,
            ),
            itemCount: stars.length,
            itemBuilder: (context, index) => FadeSlideIn(
              index: index,
              child: StarCard(star: stars[index]),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.medium),
          itemCount: stars.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: AppSpacing.small),
          itemBuilder: (context, index) => FadeSlideIn(
            index: index,
            child: StarCard(star: stars[index]),
          ),
        );
      },
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.small),
          const Text('No celestial object matches your search.'),
        ],
      ),
    );
  }
}
