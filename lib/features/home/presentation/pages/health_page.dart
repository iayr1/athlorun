import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SensorDataScreen extends StatefulWidget {
  const SensorDataScreen({super.key});

  @override
  State<SensorDataScreen> createState() => _SensorDataScreenState();
}

class _SensorDataScreenState extends State<SensorDataScreen> {
  int _stepsPedometer = 0;
  int _stepsAccelerometer = 0;
  int _steps = 0;
  double _totalDistance = 0.0;
  double _calories = 0.0;
  double _walkingDistance = 0.0;
  double _runningDistance = 0.0;
  double _cyclingDistance = 0.0;
  double _climbingDistance = 0.0;
  String _altitudeData = 'No data';
  double _previousAltitude = 0.0;

  final FlutterActivityRecognition _activityRecognition =
      FlutterActivityRecognition.instance;
  StreamSubscription<Activity>? _activityStreamSubscription;
  ActivityType _currentActivity = ActivityType.UNKNOWN;

  StreamSubscription<BarometerEvent>? _barometerStream;
  StreamSubscription<AccelerometerEvent>? _accelerometerStream;

  @override
  void initState() {
    super.initState();
    _loadData();
    _requestPermissions();
    _startListeningToSensors();
    _startListeningToBarometer();
    _startActivityRecognition();
  }

  @override
  void dispose() {
    _barometerStream?.cancel();
    _accelerometerStream?.cancel();
    _activityStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    final statuses = await [
      Permission.sensors,
      Permission.activityRecognition,
    ].request();

    if (!statuses.values.every((status) => status.isGranted) && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permissions denied. Some metrics may not update.'),
        ),
      );
      setState(() => _altitudeData = 'Permission denied');
    }
  }

  void _startListeningToSensors() {
    _accelerometerStream = accelerometerEvents.listen((event) {
      final magnitude =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

      if (magnitude > 12) {
        _stepsAccelerometer++;
        _updateSteps();
      }
    });
  }

  void _startListeningToBarometer() {
    _barometerStream = barometerEventStream().listen((BarometerEvent event) {
      final altitude = _calculateAltitude(event.pressure);
      final climbingDiff = altitude - _previousAltitude;

      if (climbingDiff > 0) {
        _climbingDistance += climbingDiff;
      }

      setState(() {
        _previousAltitude = altitude;
        _altitudeData =
            'Pressure ${event.pressure.toStringAsFixed(1)} hPa • Altitude ${altitude.toStringAsFixed(1)} m';
      });
    });
  }

  void _startActivityRecognition() {
    _activityStreamSubscription =
        _activityRecognition.activityStream.listen((activity) {
      setState(() {
        _currentActivity = activity.type;
      });
    });
  }

  double _calculateAltitude(double pressure) {
    const seaLevelPressure = 1013.25;
    return (1 - pow((pressure / seaLevelPressure), 0.1903)) * 44330.77;
  }

  void _updateSteps() {
    _steps = ((_stepsPedometer + _stepsAccelerometer) / 2).round();
    _totalDistance = _calculateDistance(_steps);

    switch (_currentActivity) {
      case ActivityType.WALKING:
        _walkingDistance += _calculateDistanceIncrement();
        break;
      case ActivityType.RUNNING:
        _runningDistance += _calculateDistanceIncrement();
        break;
      case ActivityType.ON_BICYCLE:
        _cyclingDistance += _calculateDistanceIncrement();
        break;
      default:
        break;
    }

    _calories = _calculateCalories(_steps);
    _saveData();
    setState(() {});
  }

  double _calculateDistance(int steps) {
    const stepLength = 0.762;
    return steps * stepLength;
  }

  double _calculateDistanceIncrement() => 0.01;

  double _calculateCalories(int steps) => steps * 0.04;

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('steps', _steps);
    await prefs.setDouble('climbingDistance', _climbingDistance);
    await prefs.setDouble('totalDistance', _totalDistance);
    await prefs.setDouble('calories', _calories);
    await prefs.setDouble('walkingDistance', _walkingDistance);
    await prefs.setDouble('runningDistance', _runningDistance);
    await prefs.setDouble('cyclingDistance', _cyclingDistance);
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _steps = prefs.getInt('steps') ?? 0;
      _climbingDistance = prefs.getDouble('climbingDistance') ?? 0.0;
      _totalDistance = prefs.getDouble('totalDistance') ?? 0.0;
      _calories = prefs.getDouble('calories') ?? 0.0;
      _walkingDistance = prefs.getDouble('walkingDistance') ?? 0.0;
      _runningDistance = prefs.getDouble('runningDistance') ?? 0.0;
      _cyclingDistance = prefs.getDouble('cyclingDistance') ?? 0.0;
    });
  }

  Future<void> _resetData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      _stepsPedometer = 0;
      _stepsAccelerometer = 0;
      _steps = 0;
      _climbingDistance = 0.0;
      _totalDistance = 0.0;
      _calories = 0.0;
      _walkingDistance = 0.0;
      _runningDistance = 0.0;
      _cyclingDistance = 0.0;
      _altitudeData = 'No data';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: const Color(0xFF111827),
        title: const Text('Sensor & Activity Data'),
        actions: [
          IconButton(
            tooltip: 'Reset metrics',
            icon: const Icon(Icons.refresh),
            onPressed: _resetData,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHighlightCard(),
          const SizedBox(height: 14),
          _buildStatGrid(),
          const SizedBox(height: 14),
          _buildActivityBreakdown(),
          const SizedBox(height: 14),
          _buildSystemHealthCard(),
        ],
      ),
    );
  }

  Widget _buildHighlightCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF387DFB), Color(0xFF77A8FF)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today\'s Progress',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            '$_steps steps',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: (_steps / 10000).clamp(0, 1),
            minHeight: 7,
            borderRadius: BorderRadius.circular(20),
            backgroundColor: Colors.white.withOpacity(0.35),
          ),
        ],
      ),
    );
  }

  Widget _buildStatGrid() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Distance',
            value: '${(_totalDistance / 1000).toStringAsFixed(2)} km',
            icon: Icons.route_outlined,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Calories',
            value: '${_calories.toStringAsFixed(0)} kcal',
            icon: Icons.local_fire_department_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityBreakdown() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Activity Distances',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            _DistanceRow(label: 'Walking', distance: _walkingDistance),
            _DistanceRow(label: 'Running', distance: _runningDistance),
            _DistanceRow(label: 'Cycling', distance: _cyclingDistance),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemHealthCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sensor Status',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Text('Climbed: ${_climbingDistance.toStringAsFixed(1)} m'),
            const SizedBox(height: 6),
            Text(_altitudeData),
            const SizedBox(height: 10),
            Chip(
              label: Text('Activity: ${_currentActivity.name}'),
              avatar: const Icon(Icons.directions_run, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF387DFB)),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Color(0xFF6B7280))),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _DistanceRow extends StatelessWidget {
  final String label;
  final double distance;

  const _DistanceRow({required this.label, required this.distance});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            '${distance.toStringAsFixed(2)} km',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
