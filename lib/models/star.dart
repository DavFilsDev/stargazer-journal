enum CelestialType { star, planet, nebula, galaxy }

extension CelestialTypeLabel on CelestialType {
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
