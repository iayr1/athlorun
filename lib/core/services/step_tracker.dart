import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'metrics_store.dart';

enum StepSource { none, pedometer, accelerometer }

/// Counts steps in the background of the app and feeds them into
/// [MetricsStore].
///
/// Prefers the hardware step counter (cumulative since boot, so steps taken
/// while the app was closed are picked up on next launch) and falls back to
/// accelerometer peak detection when the counter is unavailable.
class StepTracker extends ChangeNotifier {
  StepTracker._();

  static final StepTracker instance = StepTracker._();

  static const _lastRawKey = 'athlorun_pedometer_last_raw';

  final MetricsStore _store = MetricsStore.instance;

  StreamSubscription<StepCount>? _pedometerSub;
  StreamSubscription<AccelerometerEvent>? _accelSub;
  StreamSubscription<Activity>? _activitySub;

  StepSource _source = StepSource.none;
  ActivityType _activity = ActivityType.UNKNOWN;
  bool _permissionDenied = false;
  bool _starting = false;

  // Accelerometer peak-detection state.
  bool _aboveThreshold = false;
  DateTime _lastPeak = DateTime.fromMillisecondsSinceEpoch(0);

  StepSource get source => _source;
  ActivityType get activity => _activity;
  bool get permissionDenied => _permissionDenied;
  bool get isRunning => _source != StepSource.none;

  Future<void> start() async {
    if (isRunning || _starting || kIsWeb) return;
    _starting = true;
    try {
      final status = await Permission.activityRecognition.request();
      _permissionDenied = !(status.isGranted || status.isLimited);
      if (_permissionDenied) {
        // Accelerometer does not need a runtime permission.
        _startAccelerometer();
      } else {
        _startPedometer();
        _startActivityRecognition();
      }
    } catch (e) {
      debugPrint('StepTracker: start failed, using accelerometer: $e');
      _startAccelerometer();
    } finally {
      _starting = false;
      notifyListeners();
    }
  }

  /// Re-requests the activity permission, or opens system settings when it
  /// was permanently denied, then restarts tracking with the best source.
  Future<void> openSettings() async {
    final status = await Permission.activityRecognition.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return;
    }
    if (status.isGranted && _source != StepSource.pedometer) {
      await _accelSub?.cancel();
      _accelSub = null;
      _permissionDenied = false;
      _startPedometer();
      _startActivityRecognition();
      notifyListeners();
    }
  }

  void _startPedometer() {
    _source = StepSource.pedometer;
    _pedometerSub = Pedometer.stepCountStream.listen(
      _onRawSteps,
      onError: (Object e) {
        debugPrint('StepTracker: pedometer unavailable ($e)');
        _pedometerSub?.cancel();
        _pedometerSub = null;
        _startAccelerometer();
        notifyListeners();
      },
      cancelOnError: true,
    );
  }

  Future<void> _onRawSteps(StepCount event) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = event.steps;
    final last = prefs.getInt(_lastRawKey);
    await prefs.setInt(_lastRawKey, raw);
    if (last == null) return; // First reading only sets the baseline.

    // The counter resets on reboot, in which case everything is new.
    final delta = raw >= last ? raw - last : raw;
    // Ignore implausible jumps (e.g. stale baseline from another device).
    if (delta > 0 && delta < 50000) _addSteps(delta);
  }

  void _startAccelerometer() {
    if (_accelSub != null) return;
    _source = StepSource.accelerometer;
    _accelSub = accelerometerEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen(
      (event) {
        final magnitude =
            sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
        if (!_aboveThreshold && magnitude > 11.8) {
          _aboveThreshold = true;
          final now = DateTime.now();
          if (now.difference(_lastPeak).inMilliseconds > 280) {
            _lastPeak = now;
            _addSteps(1);
          }
        } else if (_aboveThreshold && magnitude < 10.2) {
          _aboveThreshold = false;
        }
      },
      onError: (Object e) {
        debugPrint('StepTracker: accelerometer unavailable ($e)');
        _source = StepSource.none;
        notifyListeners();
      },
    );
  }

  void _startActivityRecognition() {
    if (_activitySub != null) return;
    _activitySub = FlutterActivityRecognition.instance.activityStream.listen(
      (activity) {
        _activity = activity.type;
        notifyListeners();
      },
      onError: (Object e) => debugPrint('StepTracker: activity error ($e)'),
    );
  }

  void _addSteps(int delta) {
    _store.addSteps(
      delta,
      running: _activity == ActivityType.RUNNING,
      cycling: _activity == ActivityType.ON_BICYCLE,
    );
  }

  @override
  void dispose() {
    _pedometerSub?.cancel();
    _accelSub?.cancel();
    _activitySub?.cancel();
    super.dispose();
  }
}
