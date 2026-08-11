/// The kind of celestial object being catalogued.
///
/// Kept as an enum (rather than a free-form string) so the UI can safely
/// switch on it (icon, color) without risking typos.
enum CelestialType { star, planet, nebula, galaxy }

extension CelestialTypeLabel on CelestialType {
  /// Human-readable English label used throughout the UI.
  String get label {
    switch (this) {
      case CelestialType.star:
        return 'Star';
      case CelestialType.planet:
        return 'Planet';
      case CelestialType.nebula:
        return 'Nebula';
      case CelestialType.galaxy:
        return 'Galaxy';
    }
  }
}

/// Pure data class representing a celestial object.
///
/// This layer contains no Flutter/UI code (no widgets, no `Color`), as
/// required by the clean architecture split between `models/` and the
/// presentation layer.
class Star {
  final String id;
  final String name;
  final CelestialType type;
  final String constellation;
  final double distanceLightYears;
  final double magnitude;
  final String description;

  const Star({
    required this.id,
    required this.name,
    required this.type,
    required this.constellation,
    required this.distanceLightYears,
    required this.magnitude,
    required this.description,
  });
}
