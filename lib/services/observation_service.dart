import 'package:flutter/foundation.dart';

import '../models/observation.dart';

class ObservationService extends ChangeNotifier {
  final List<Observation> _observations = [];

  List<Observation> getAll() {
    final sorted = List<Observation>.from(_observations);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return List.unmodifiable(sorted);
  }

  List<Observation> getForStar(String starId) {
    return getAll().where((o) => o.starId == starId).toList();
  }

  void add(Observation observation) {
    _observations.add(observation);
    notifyListeners();
  }
}
