import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';

class SensorDataScreen extends StatefulWidget {
  const SensorDataScreen({super.key});

  @override
  State<SensorDataScreen> createState() => _SensorDataScreenState();
}

class _SensorDataScreenState extends State<SensorDataScreen> {
  // Step Count Data
  int _stepsPedometer = 0;
  int _stepsAccelerometer = 0;
  int _steps = 0;
  double _totalDistance = 0.0;
  double _calories = 0.0;

  // Activity-specific Distances
  double _walkingDistance = 0.0;
  double _runningDistance = 0.0;
  double _cyclingDistance = 0.0;

  // Climbing Distance
  double _climbingDistance = 0.0;

  // Altitude Data
  String _altitudeData = "No data";
  double _previousAltitude = 0.0;

  // Activity Recognition
  final FlutterActivityRecognition _activityRecognition =
      FlutterActivityRecognition.instance;
  StreamSubscription<Activity>? _activityStreamSubscription;
  ActivityType _currentActivity = ActivityType.UNKNOWN;

  // Streams for Sensors
  StreamSubscription<dynamic>? _barometerStream;
  StreamSubscription<AccelerometerEvent>? _accelerometerStream;

  @override
  void initState() {
    super.initState();
    _loadData();
    requestPermissions();
    startListeningToSensors();
    startListeningToBarometer();
    startActivityRecognition();
  }

  @override
  void dispose() {
    _barometerStream?.cancel();
    _accelerometerStream?.cancel();
    _activityStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.sensors,
      Permission.activityRecognition,
    ].request();

    if (!statuses.values.every((status) => status.isGranted)) {
      setState(() {
        _altitudeData = "Permission Denied";
      });
    }
  }

  void startListeningToSensors() {
    _accelerometerStream = accelerometerEvents.listen((event) {
      double magnitude =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

      if (magnitude > 12) {
        _stepsAccelerometer++;
        _updateSteps();
      }
    });
  }

  void startListeningToBarometer() {
    _barometerStream = barometerEventStream().listen((BarometerEvent event) {
      double altitude = _calculateAltitude(event.pressure);
      double climbingDiff = altitude - _previousAltitude;

      if (climbingDiff > 0) {
        _climbingDistance += climbingDiff; // Accumulate climbing distance
      }

      setState(() {
        _previousAltitude = altitude;
        _altitudeData =
            "Pressure: ${event.pressure.toStringAsFixed(2)} hPa, Altitude: ${altitude.toStringAsFixed(2)} m";
      });
    });
  }

  void startActivityRecognition() {
    _activityStreamSubscription =
        _activityRecognition.activityStream.listen((activity) {
      setState(() {
        _currentActivity = activity.type;
      });
    });
  }

  double _calculateAltitude(double pressure) {
    const double seaLevelPressure =
        1013.25; // Standard sea-level pressure in hPa
    return (1 - pow((pressure / seaLevelPressure), 0.1903)) * 44330.77;
  }

  void _updateSteps() {
    _steps = ((_stepsPedometer + _stepsAccelerometer) / 2).round();
    _totalDistance = calculateDistance(_steps);

    // Update activity-specific distances
    switch (_currentActivity) {
      case ActivityType.WALKING:
        _walkingDistance += calculateDistanceIncrement();
        break;
      case ActivityType.RUNNING:
        _runningDistance += calculateDistanceIncrement();
        break;
      case ActivityType.ON_BICYCLE:
        _cyclingDistance += calculateDistanceIncrement();
        break;
      default:
        break;
    }

    _calories = calculateCalories(_steps);
    _saveData();
  }

  double calculateDistance(int steps) {
    const double stepLength = 0.762; // Average step length in meters
    return steps * stepLength;
  }

  double calculateDistanceIncrement() {
    const double distanceIncrement = 0.01; // Distance increment in km
    return distanceIncrement;
  }

  double calculateCalories(int steps) {
    const double caloriePerStep = 0.04; // Average calories burned per step
    return steps * caloriePerStep;
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('steps', _steps);
    prefs.setDouble('climbingDistance', _climbingDistance);
    prefs.setDouble('totalDistance', _totalDistance);
    prefs.setDouble('calories', _calories);
    prefs.setDouble('walkingDistance', _walkingDistance);
    prefs.setDouble('runningDistance', _runningDistance);
    prefs.setDouble('cyclingDistance', _cyclingDistance);
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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

  void _resetData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sensor & Activity Data"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetData,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Step Count",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text("Steps: $_steps", style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              Text(
                "Total Distance Traveled",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "Distance: ${(_totalDistance / 1000).toStringAsFixed(2)} km",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                "Calories Burned",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "Calories: ${_calories.toStringAsFixed(2)} kcal",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                "Activity Distances",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text("Walking: ${_walkingDistance.toStringAsFixed(2)} km"),
              Text("Running: ${_runningDistance.toStringAsFixed(2)} km"),
              Text("Cycling: ${_cyclingDistance.toStringAsFixed(2)} km"),
              SizedBox(height: 20),
              Text(
                "Climbing Distance",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "Climbed: ${_climbingDistance.toStringAsFixed(2)} meters",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
