import 'package:flutter/foundation.dart';

import '../models/observation.dart';

/// Stores and serves the observations logged by the user.
///
/// This is the single source of truth for observation data: screens ask
/// this service for data and submit new entries to it, but never store
/// observation state themselves. It extends [ChangeNotifier] so widgets
/// can listen (via `Provider`/`Consumer`) and rebuild automatically when
/// a new observation is added.
class ObservationService extends ChangeNotifier {
  final List<Observation> _observations = [];

  /// All observations, most recent first.
  List<Observation> getAll() {
    final sorted = List<Observation>.from(_observations);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return List.unmodifiable(sorted);
  }

  /// Observations logged for a specific star, most recent first.
  List<Observation> getForStar(String starId) {
    return getAll().where((o) => o.starId == starId).toList();
  }

  /// Adds a new observation and notifies listeners.
  void add(Observation observation) {
    _observations.add(observation);
    notifyListeners();
  }
}
