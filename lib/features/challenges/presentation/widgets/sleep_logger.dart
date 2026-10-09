import 'package:flutter/material.dart';

import '../../../../core/services/metrics_store.dart';

/// Asks for bed and wake times and records the sleep duration for today.
Future<void> showSleepLogger(BuildContext context) async {
  final now = DateTime.now();
  final sleepStart = await showTimePicker(
    context: context,
    initialTime: const TimeOfDay(hour: 23, minute: 0),
    helpText: 'WHEN DID YOU GO TO SLEEP?',
  );
  if (sleepStart == null || !context.mounted) return;

  final sleepEnd = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
    helpText: 'WHEN DID YOU WAKE UP?',
  );
  if (sleepEnd == null || !context.mounted) return;

  final hours = sleepHoursBetween(sleepStart, sleepEnd);
  MetricsStore.instance.setSleep(hours);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Sleep logged: ${hours.toStringAsFixed(1)} h')),
  );
}

/// Hours between [start] and [end], wrapping past midnight.
double sleepHoursBetween(TimeOfDay start, TimeOfDay end) {
  final startMinutes = start.hour * 60 + start.minute;
  final endMinutes = end.hour * 60 + end.minute;
  final minutes = endMinutes >= startMinutes
      ? endMinutes - startMinutes
      : (24 * 60 - startMinutes) + endMinutes;
  return minutes / 60;
}
