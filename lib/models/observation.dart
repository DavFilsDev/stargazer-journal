import 'package:flutter/material.dart' show TimeOfDay;

/// Pure data class representing a single observation log entry that a
/// user recorded for a given [Star] (referenced by [starId]).
///
/// Note: `TimeOfDay` is a lightweight value type (not a widget), so
/// importing it here does not pull UI/build logic into the model layer.
class Observation {
  final String id;
  final String starId;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  final int rating;

  const Observation({
    required this.id,
    required this.starId,
    required this.description,
    required this.date,
    required this.time,
    this.rating = 3,
  });

  /// Combines [date] and [time] into a single formatted string,
  /// e.g. "Aug 12, 2026 at 21:30".
  String get formattedDateTime {
    final datePart =
        '${_month(date.month)} ${date.day}, ${date.year}';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$datePart at $hour:$minute';
  }

  static String _month(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
