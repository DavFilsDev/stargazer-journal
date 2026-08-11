import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/observation.dart';
import '../services/observation_service.dart';
import '../services/star_service.dart';
import '../utils/constants.dart';
import '../widgets/glass_app_bar.dart';
import '../widgets/glass_container.dart';

/// Form screen to log a new [Observation] for the star identified by
/// [starId].
///
/// Required fields (3, as specified): [_descriptionController] text,
/// a selected [_date], and a selected [_time]. All three are validated
/// through [_formKey] before submission.
class ObservationFormScreen extends StatefulWidget {
  final String starId;

  const ObservationFormScreen({super.key, required this.starId});

  @override
  State<ObservationFormScreen> createState() => _ObservationFormScreenState();
}

class _ObservationFormScreenState extends State<ObservationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  DateTime? _date;
  TimeOfDay? _time;
  int _rating = 3;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _time = picked);
  }

  void _submit() {
    // Forces the date/time FormFields to re-validate against the
    // latest _date/_time values before checking overall form validity.
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    final observation = Observation(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      starId: widget.starId,
      description: _descriptionController.text.trim(),
      date: _date!,
      time: _time!,
      rating: _rating,
    );

    context.read<ObservationService>().add(observation);

    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(content: Text('Observation saved.')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final star = StarService.getById(widget.starId);

    return Scaffold(
      appBar: GlassAppBar(
        title: 'New observation${star != null ? ' — ${star.name}' : ''}',
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.medium),
          children: [
            GlassContainer(
              borderRadius: BorderRadius.circular(18),
              blurSigma: 12,
              opacity: 0.3,
              padding: const EdgeInsets.all(AppSpacing.medium),
              child: Column(
                children: [
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'What did you observe?',
                      hintText:
                          'e.g. Clearly visible with the naked eye, no clouds',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please describe your observation.';
                      }
                      if (value.trim().length < 5) {
                        return 'Please add a bit more detail (min. 5 characters).';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  FormField<DateTime>(
                    initialValue: _date,
                    validator: (_) =>
                        _date == null ? 'Please select a date.' : null,
                    builder: (field) => _PickerTile(
                      icon: Icons.calendar_today,
                      label: 'Date',
                      value: _date == null
                          ? 'Select the observation date'
                          : '${_date!.year}-${_date!.month.toString().padLeft(2, '0')}-${_date!.day.toString().padLeft(2, '0')}',
                      errorText: field.errorText,
                      onTap: () async {
                        await _pickDate();
                        field.didChange(_date);
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  FormField<TimeOfDay>(
                    initialValue: _time,
                    validator: (_) =>
                        _time == null ? 'Please select a time.' : null,
                    builder: (field) => _PickerTile(
                      icon: Icons.access_time,
                      label: 'Time',
                      value: _time == null
                          ? 'Select the observation time'
                          : _time!.format(context),
                      errorText: field.errorText,
                      onTap: () async {
                        await _pickTime();
                        field.didChange(_time);
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Rating',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Row(
                    children: [
                      for (var i = 1; i <= 5; i++)
                        _AnimatedRatingStar(
                          filled: i <= _rating,
                          onTap: () => setState(() => _rating = i),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.large),
            FilledButton(
              onPressed: _submit,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Save observation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single tappable rating star that pops with a small scale animation
/// whenever its filled state changes.
class _AnimatedRatingStar extends StatelessWidget {
  final bool filled;
  final VoidCallback onTap;

  const _AnimatedRatingStar({required this.filled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: AnimatedScale(
        scale: filled ? 1.15 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutBack,
        child: Icon(
          filled ? Icons.star : Icons.star_border,
          color: Colors.amber,
        ),
      ),
    );
  }
}

/// Button-styled tile used for the date/time fields, showing a
/// validation error message below it (mirrors [TextFormField] styling).
class _PickerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? errorText;
  final VoidCallback onTap;

  const _PickerTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.errorText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          prefixIcon: Icon(icon),
        ),
        child: Text(
          value,
          style: hasError
              ? theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error)
              : theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}
