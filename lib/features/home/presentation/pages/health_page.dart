import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'package:athlorun/config/themes/app_theme.dart';
import 'package:athlorun/core/services/metrics_store.dart';
import 'package:athlorun/core/services/step_tracker.dart';
import 'package:athlorun/core/utils/formatters.dart';
import 'package:athlorun/core/widgets/ui_kit.dart';

/// Live sensor dashboard: step source, detected activity, barometric
/// altitude and today's distance breakdown.
class SensorDataScreen extends StatefulWidget {
  const SensorDataScreen({super.key});

  @override
  State<SensorDataScreen> createState() => _SensorDataScreenState();
}

class _SensorDataScreenState extends State<SensorDataScreen> {
  StreamSubscription<BarometerEvent>? _barometerSub;
  double? _pressure;
  double? _altitude;
  double? _lastClimbAltitude;
  bool _barometerAvailable = true;

  @override
  void initState() {
    super.initState();
    StepTracker.instance.start();
    _barometerSub = barometerEventStream().listen(
      _onBarometer,
      onError: (Object _) {
        if (mounted) setState(() => _barometerAvailable = false);
      },
      cancelOnError: true,
    );
  }

  @override
  void dispose() {
    _barometerSub?.cancel();
    super.dispose();
  }

  void _onBarometer(BarometerEvent event) {
    if (!mounted) return;
    const seaLevelPressure = 1013.25;
    final altitude =
        (1 - pow(event.pressure / seaLevelPressure, 0.1903)) * 44330.77;

    // Only count sustained gains of 1 m+ to filter out sensor noise.
    final base = _lastClimbAltitude ??= altitude;
    final gain = altitude - base;
    if (gain >= 1) {
      MetricsStore.instance.addClimb(gain);
      _lastClimbAltitude = altitude;
    } else if (gain < -1) {
      _lastClimbAltitude = altitude;
    }

    setState(() {
      _pressure = event.pressure;
      _altitude = altitude.toDouble();
    });
  }

  Future<void> _confirmReset() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset today\'s metrics?'),
        content: const Text(
          'Steps, distance, climb and calories for today will be set to zero. '
          'Saved workouts and sleep stay untouched.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppPalette.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (ok == true) {
      MetricsStore.instance.resetToday();
      _lastClimbAltitude = _altitude;
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = MetricsStore.instance;
    final tracker = StepTracker.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Sensors'),
        actions: [
          IconButton(
            tooltip: 'Reset today',
            icon: const Icon(Icons.restart_alt_rounded),
            onPressed: _confirmReset,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([store, tracker]),
        builder: (context, _) {
          final today = store.today;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
            children: [
              GradientCard(
                gradient: AppPalette.fresh,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _LiveDot(active: tracker.isRunning),
                          const SizedBox(height: 12),
                          Text(
                            Fmt.steps(today.steps),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1.2,
                            ),
                          ),
                          Text(
                            'steps today · ${_sourceLabel(tracker.source)}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(
                        _activityIcon(tracker.activity),
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  ],
                ),
              ),
              if (tracker.permissionDenied) ...[
                const SizedBox(height: 14),
                SurfaceCard(
                  onTap: tracker.openSettings,
                  child: const Row(
                    children: [
                      IconBadge(
                        icon: Icons.lock_outline_rounded,
                        color: AppPalette.amber,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Activity permission denied — using motion sensor '
                          'estimate. Tap to grant access.',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  mainAxisExtent: 136,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  StatTile(
                    icon: Icons.route_rounded,
                    color: AppPalette.blue,
                    value: '${Fmt.km(today.totalKm)} km',
                    label: 'Total distance',
                  ),
                  StatTile(
                    icon: Icons.local_fire_department_rounded,
                    color: AppPalette.orange,
                    value: '${today.calories.toStringAsFixed(0)} kcal',
                    label: 'Calories',
                  ),
                  StatTile(
                    icon: Icons.terrain_rounded,
                    color: AppPalette.green,
                    value: '${today.climbM.toStringAsFixed(0)} m',
                    label: 'Climbed',
                  ),
                  StatTile(
                    icon: Icons.insights_rounded,
                    color: AppPalette.purple,
                    value: _activityLabel(tracker.activity),
                    label: 'Detected activity',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const SectionHeader(title: 'Distance breakdown'),
              SurfaceCard(
                child: Column(
                  children: [
                    _BreakdownRow(
                      icon: Icons.directions_walk_rounded,
                      color: AppPalette.green,
                      label: 'Walking',
                      km: today.walkKm,
                      total: today.totalKm,
                    ),
                    const SizedBox(height: 16),
                    _BreakdownRow(
                      icon: Icons.directions_run_rounded,
                      color: AppPalette.primary,
                      label: 'Running',
                      km: today.runKm,
                      total: today.totalKm,
                    ),
                    const SizedBox(height: 16),
                    _BreakdownRow(
                      icon: Icons.directions_bike_rounded,
                      color: AppPalette.orange,
                      label: 'Cycling',
                      km: today.rideKm,
                      total: today.totalKm,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const SectionHeader(title: 'Barometer'),
              SurfaceCard(
                child: Row(
                  children: [
                    const IconBadge(
                      icon: Icons.speed_rounded,
                      color: AppPalette.cyan,
                      size: 52,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: !_barometerAvailable
                          ? const Text(
                              'This device has no barometer, so altitude and '
                              'climb tracking are unavailable.',
                              style: TextStyle(color: AppPalette.inkSoft),
                            )
                          : _pressure == null
                              ? const Text(
                                  'Waiting for sensor data…',
                                  style: TextStyle(color: AppPalette.inkSoft),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${_altitude!.toStringAsFixed(1)} m',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      'Estimated altitude · '
                                      '${_pressure!.toStringAsFixed(1)} hPa',
                                      style: const TextStyle(
                                        color: AppPalette.inkSoft,
                                      ),
                                    ),
                                  ],
                                ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static String _sourceLabel(StepSource source) => switch (source) {
        StepSource.pedometer => 'step counter',
        StepSource.accelerometer => 'motion estimate',
        StepSource.none => 'sensors off',
      };

  static String _activityLabel(ActivityType type) => switch (type) {
        ActivityType.WALKING => 'Walking',
        ActivityType.RUNNING => 'Running',
        ActivityType.ON_BICYCLE => 'Cycling',
        ActivityType.IN_VEHICLE => 'In vehicle',
        ActivityType.STILL => 'Still',
        _ => 'Unknown',
      };

  static IconData _activityIcon(ActivityType type) => switch (type) {
        ActivityType.RUNNING => Icons.directions_run_rounded,
        ActivityType.ON_BICYCLE => Icons.directions_bike_rounded,
        ActivityType.IN_VEHICLE => Icons.directions_car_rounded,
        ActivityType.STILL => Icons.accessibility_new_rounded,
        _ => Icons.directions_walk_rounded,
      };
}

class _LiveDot extends StatelessWidget {
  final bool active;

  const _LiveDot({required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: active ? const Color(0xFFBBF7D0) : Colors.white54,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            active ? 'LIVE' : 'OFF',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 11,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final double km;
  final double total;

  const _BreakdownRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.km,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconBadge(icon: icon, color: color, size: 40),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(label,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Text(
                    '${Fmt.km(km)} km',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              GradientProgressBar(
                value: total <= 0 ? 0 : km / total,
                height: 7,
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.6)],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
