import 'package:flutter/material.dart' show TimeOfDay;

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
