import '../models/star.dart';

/// Provides access to the catalog of celestial objects.
///
/// Screens and widgets never hardcode star data themselves — they always
/// go through this service, so the data source can later be swapped for
/// a real API or local database without touching any UI code.
class StarService {
  StarService._();

  static final List<Star> _catalog = [
    const Star(
      id: 'sirius',
      name: 'Sirius',
      type: CelestialType.star,
      constellation: 'Canis Major',
      distanceLightYears: 8.6,
      magnitude: -1.46,
      description:
          'The brightest star in the night sky, Sirius is a binary '
          'system composed of a main-sequence star and a white dwarf '
          'companion known as Sirius B.',
    ),
    const Star(
      id: 'betelgeuse',
      name: 'Betelgeuse',
      type: CelestialType.star,
      constellation: 'Orion',
      distanceLightYears: 642.5,
      magnitude: 0.50,
      description:
          'A red supergiant near the end of its life, Betelgeuse is '
          'expected to explode as a supernova within the next 100,000 '
          'years, at which point it would be visible in daylight.',
    ),
    const Star(
      id: 'vega',
      name: 'Vega',
      type: CelestialType.star,
      constellation: 'Lyra',
      distanceLightYears: 25.0,
      magnitude: 0.03,
      description:
          'One of the most luminous stars in the solar neighborhood, '
          'Vega was the northern pole star around 12,000 BCE and will '
          'be again around 13,700 CE.',
    ),
    const Star(
      id: 'jupiter',
      name: 'Jupiter',
      type: CelestialType.planet,
      constellation: '—',
      distanceLightYears: 0.00068,
      magnitude: -2.94,
      description:
          'The largest planet in the Solar System, a gas giant with a '
          'famous Great Red Spot storm and dozens of known moons, '
          'including the four large Galilean moons.',
    ),
    const Star(
      id: 'saturn',
      name: 'Saturn',
      type: CelestialType.planet,
      constellation: '—',
      distanceLightYears: 0.00125,
      magnitude: 0.46,
      description:
          'Famous for its dramatic ring system made mostly of ice '
          'particles, Saturn is the second-largest planet in the '
          'Solar System.',
    ),
    const Star(
      id: 'orion-nebula',
      name: 'Orion Nebula',
      type: CelestialType.nebula,
      constellation: 'Orion',
      distanceLightYears: 1344,
      magnitude: 4.0,
      description:
          'A diffuse nebula visible to the naked eye below Orion\'s '
          'Belt, and one of the brightest nebulae, making it a popular '
          'target for beginner stargazers.',
    ),
    const Star(
      id: 'ring-nebula',
      name: 'Ring Nebula',
      type: CelestialType.nebula,
      constellation: 'Lyra',
      distanceLightYears: 2283,
      magnitude: 8.8,
      description:
          'A planetary nebula formed by a dying star shedding its '
          'outer layers, visible through a small telescope as a faint '
          'glowing ring.',
    ),
    const Star(
      id: 'andromeda-galaxy',
      name: 'Andromeda Galaxy',
      type: CelestialType.galaxy,
      constellation: 'Andromeda',
      distanceLightYears: 2537000,
      magnitude: 3.44,
      description:
          'The nearest large galaxy to the Milky Way, on a slow '
          'collision course with our own galaxy, expected to merge in '
          'about 4.5 billion years.',
    ),
    const Star(
      id: 'whirlpool-galaxy',
      name: 'Whirlpool Galaxy',
      type: CelestialType.galaxy,
      constellation: 'Canes Venatici',
      distanceLightYears: 23000000,
      magnitude: 8.4,
      description:
          'A classic spiral galaxy interacting gravitationally with a '
          'smaller companion galaxy, often photographed for its '
          'well-defined spiral arms.',
    ),
    const Star(
      id: 'polaris',
      name: 'Polaris',
      type: CelestialType.star,
      constellation: 'Ursa Minor',
      distanceLightYears: 433,
      magnitude: 1.98,
      description:
          'The current North Star, closely aligned with Earth\'s axis '
          'of rotation, making it a key reference point for '
          'navigation in the northern hemisphere.',
    ),
  ];

  /// Returns the full catalog.
  static List<Star> getAll() => List.unmodifiable(_catalog);

  /// Returns the star matching [id], or null if not found.
  static Star? getById(String id) {
    for (final star in _catalog) {
      if (star.id == id) return star;
    }
    return null;
  }

  /// Returns the subset of the catalog whose name or constellation
  /// contains [query] (case-insensitive), optionally narrowed further
  /// to a single [type].
  static List<Star> search(String query, {CelestialType? type}) {
    final normalized = query.trim().toLowerCase();
    return _catalog.where((star) {
      final matchesQuery = normalized.isEmpty ||
          star.name.toLowerCase().contains(normalized) ||
          star.constellation.toLowerCase().contains(normalized);
      final matchesType = type == null || star.type == type;
      return matchesQuery && matchesType;
    }).toList();
  }
}
