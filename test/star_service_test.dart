import 'package:flutter_test/flutter_test.dart';
import 'package:stargazer_journal/models/star.dart';
import 'package:stargazer_journal/services/star_service.dart';

void main() {
  group('StarService', () {
    test('getAll returns a non-empty catalog', () {
      expect(StarService.getAll(), isNotEmpty);
    });

    test('getById finds an existing star', () {
      final star = StarService.getById('sirius');
      expect(star, isNotNull);
      expect(star!.name, 'Sirius');
    });

    test('getById returns null for an unknown id', () {
      expect(StarService.getById('does-not-exist'), isNull);
    });

    test('search filters by name (case-insensitive)', () {
      final results = StarService.search('vega');
      expect(results.length, 1);
      expect(results.first.name, 'Vega');
    });

    test('search filters by celestial type', () {
      final results = StarService.search('', type: CelestialType.planet);
      expect(results, isNotEmpty);
      expect(results.every((s) => s.type == CelestialType.planet), isTrue);
    });

    test('search returns empty list when nothing matches', () {
      expect(StarService.search('zzz-not-a-real-object'), isEmpty);
    });
  });
}
