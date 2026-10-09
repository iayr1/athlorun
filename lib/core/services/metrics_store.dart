import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Metrics recorded for a single calendar day.
class DayMetrics {
  final int steps;
  final double walkKm;
  final double runKm;
  final double rideKm;
  final double climbM;
  final double calories;
  final double sleepHours;

  const DayMetrics({
    this.steps = 0,
    this.walkKm = 0,
    this.runKm = 0,
    this.rideKm = 0,
    this.climbM = 0,
    this.calories = 0,
    this.sleepHours = 0,
  });

  double get totalKm => walkKm + runKm + rideKm;

  DayMetrics copyWith({
    int? steps,
    double? walkKm,
    double? runKm,
    double? rideKm,
    double? climbM,
    double? calories,
    double? sleepHours,
  }) {
    return DayMetrics(
      steps: steps ?? this.steps,
      walkKm: walkKm ?? this.walkKm,
      runKm: runKm ?? this.runKm,
      rideKm: rideKm ?? this.rideKm,
      climbM: climbM ?? this.climbM,
      calories: calories ?? this.calories,
      sleepHours: sleepHours ?? this.sleepHours,
    );
  }

  Map<String, dynamic> toJson() => {
        'steps': steps,
        'walkKm': walkKm,
        'runKm': runKm,
        'rideKm': rideKm,
        'climbM': climbM,
        'calories': calories,
        'sleepHours': sleepHours,
      };

  factory DayMetrics.fromJson(Map<String, dynamic> json) {
    double d(String key) => (json[key] as num?)?.toDouble() ?? 0;
    return DayMetrics(
      steps: (json['steps'] as num?)?.toInt() ?? 0,
      walkKm: d('walkKm'),
      runKm: d('runKm'),
      rideKm: d('rideKm'),
      climbM: d('climbM'),
      calories: d('calories'),
      sleepHours: d('sleepHours'),
    );
  }
}

enum ActivityKind { run, walk, ride }

extension ActivityKindX on ActivityKind {
  String get label => switch (this) {
        ActivityKind.run => 'Run',
        ActivityKind.walk => 'Walk',
        ActivityKind.ride => 'Ride',
      };

  /// Approximate kcal burned per km per kg of body weight.
  double get kcalPerKmKg => switch (this) {
        ActivityKind.run => 1.0,
        ActivityKind.walk => 0.75,
        ActivityKind.ride => 0.3,
      };
}

/// A GPS-tracked workout saved from the Track tab.
class TrackedActivity {
  final String id;
  final ActivityKind kind;
  final DateTime startedAt;
  final Duration duration;
  final double distanceKm;
  final double calories;
  final List<List<double>> route;

  const TrackedActivity({
    required this.id,
    required this.kind,
    required this.startedAt,
    required this.duration,
    required this.distanceKm,
    required this.calories,
    required this.route,
  });

  /// Pace in minutes per km, or null when no distance was covered.
  double? get paceMinPerKm =>
      distanceKm > 0.01 ? duration.inSeconds / 60 / distanceKm : null;

  double get speedKmh =>
      duration.inSeconds > 0 ? distanceKm / (duration.inSeconds / 3600) : 0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'kind': kind.name,
        'startedAt': startedAt.toIso8601String(),
        'durationSec': duration.inSeconds,
        'distanceKm': distanceKm,
        'calories': calories,
        'route': route,
      };

  factory TrackedActivity.fromJson(Map<String, dynamic> json) {
    return TrackedActivity(
      id: json['id'] as String,
      kind: ActivityKind.values.firstWhere(
        (k) => k.name == json['kind'],
        orElse: () => ActivityKind.run,
      ),
      startedAt: DateTime.parse(json['startedAt'] as String),
      duration: Duration(seconds: (json['durationSec'] as num).toInt()),
      distanceKm: (json['distanceKm'] as num).toDouble(),
      calories: (json['calories'] as num).toDouble(),
      route: [
        for (final p in (json['route'] as List? ?? const []))
          [(p[0] as num).toDouble(), (p[1] as num).toDouble()],
      ],
    );
  }
}

/// Daily targets the user can tune from the profile tab.
class Goals {
  final int steps;
  final double runKm;
  final double calories;
  final double sleepHours;

  const Goals({
    this.steps = 10000,
    this.runKm = 5,
    this.calories = 600,
    this.sleepHours = 8,
  });

  Goals copyWith({
    int? steps,
    double? runKm,
    double? calories,
    double? sleepHours,
  }) {
    return Goals(
      steps: steps ?? this.steps,
      runKm: runKm ?? this.runKm,
      calories: calories ?? this.calories,
      sleepHours: sleepHours ?? this.sleepHours,
    );
  }

  Map<String, dynamic> toJson() => {
        'steps': steps,
        'runKm': runKm,
        'calories': calories,
        'sleepHours': sleepHours,
      };

  factory Goals.fromJson(Map<String, dynamic> json) {
    const d = Goals();
    return Goals(
      steps: (json['steps'] as num?)?.toInt() ?? d.steps,
      runKm: (json['runKm'] as num?)?.toDouble() ?? d.runKm,
      calories: (json['calories'] as num?)?.toDouble() ?? d.calories,
      sleepHours: (json['sleepHours'] as num?)?.toDouble() ?? d.sleepHours,
    );
  }
}

/// Single source of truth for all locally persisted fitness data.
///
/// Days are keyed by date, so a new day automatically starts from zero
/// while the previous days remain available for the weekly charts.
class MetricsStore extends ChangeNotifier {
  MetricsStore._();

  static final MetricsStore instance = MetricsStore._();

  static const _daysKey = 'athlorun_days_v1';
  static const _activitiesKey = 'athlorun_activities_v1';
  static const _goalsKey = 'athlorun_goals_v1';
  static const _nameKey = 'athlorun_name';
  static const _weightKey = 'athlorun_weight';
  static const _maxDaysKept = 60;
  static const _maxRoutePoints = 400;

  SharedPreferences? _prefs;
  Map<String, DayMetrics> _days = {};
  List<TrackedActivity> _activities = [];
  Goals _goals = const Goals();
  String _name = 'Athlete';
  double _weightKg = 70;
  bool _loaded = false;

  /// True while a GPS workout is being recorded, so step-based distance and
  /// calories are not double counted.
  bool gpsSessionActive = false;

  bool get isLoaded => _loaded;
  Goals get goals => _goals;
  String get name => _name;
  double get weightKg => _weightKg;
  List<TrackedActivity> get activities => List.unmodifiable(_activities);

  DayMetrics get today => _days[dayKey(DateTime.now())] ?? const DayMetrics();

  DayMetrics dayAt(DateTime date) => _days[dayKey(date)] ?? const DayMetrics();

  /// Metrics for the last [count] days, oldest first, ending today.
  List<MapEntry<DateTime, DayMetrics>> lastDays(int count) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return [
      for (var i = count - 1; i >= 0; i--)
        MapEntry(
          today.subtract(Duration(days: i)),
          dayAt(today.subtract(Duration(days: i))),
        ),
    ];
  }

  /// Consecutive days (ending today or yesterday) where the step goal was met.
  int get streak {
    var count = 0;
    final now = DateTime.now();
    var day = DateTime(now.year, now.month, now.day);
    if (dayAt(day).steps < _goals.steps) {
      day = day.subtract(const Duration(days: 1));
    }
    while (dayAt(day).steps >= _goals.steps) {
      count++;
      day = day.subtract(const Duration(days: 1));
    }
    return count;
  }

  double get lifetimeKm =>
      _days.values.fold<double>(0, (sum, d) => sum + d.totalKm);

  int get lifetimeSteps => _days.values.fold<int>(0, (sum, d) => sum + d.steps);

  static String dayKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  Future<void> load() async {
    final prefs = _prefs ??= await SharedPreferences.getInstance();
    try {
      final rawDays = prefs.getString(_daysKey);
      if (rawDays != null) {
        final decoded = jsonDecode(rawDays) as Map<String, dynamic>;
        _days = decoded.map(
          (k, v) => MapEntry(k, DayMetrics.fromJson(v as Map<String, dynamic>)),
        );
      }
      final rawActivities = prefs.getString(_activitiesKey);
      if (rawActivities != null) {
        _activities = [
          for (final a in jsonDecode(rawActivities) as List)
            TrackedActivity.fromJson(a as Map<String, dynamic>),
        ];
      }
      final rawGoals = prefs.getString(_goalsKey);
      if (rawGoals != null) {
        _goals = Goals.fromJson(jsonDecode(rawGoals) as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('MetricsStore: failed to decode saved data: $e');
    }
    _name = prefs.getString(_nameKey) ?? _name;
    _weightKg = prefs.getDouble(_weightKey) ?? _weightKg;
    _loaded = true;
    notifyListeners();
  }

  void _updateToday(DayMetrics Function(DayMetrics current) update) {
    final key = dayKey(DateTime.now());
    _days[key] = update(_days[key] ?? const DayMetrics());
    notifyListeners();
    _saveDays();
  }

  /// Adds steps detected by the pedometer. Distance and calories are derived
  /// from the steps unless a GPS workout is currently being recorded.
  void addSteps(int delta, {bool running = false, bool cycling = false}) {
    if (delta <= 0) return;
    _updateToday((d) {
      if (gpsSessionActive) return d.copyWith(steps: d.steps + delta);
      final km = delta * (running ? 0.0011 : 0.000762);
      return d.copyWith(
        steps: d.steps + delta,
        runKm: running ? d.runKm + km : null,
        rideKm: cycling ? d.rideKm + km : null,
        walkKm: running || cycling ? null : d.walkKm + km,
        calories: d.calories + delta * 0.04 * (_weightKg / 70),
      );
    });
  }

  void addClimb(double meters) {
    if (meters <= 0) return;
    _updateToday((d) => d.copyWith(climbM: d.climbM + meters));
  }

  void setSleep(double hours) {
    _updateToday((d) => d.copyWith(sleepHours: hours));
  }

  void resetToday() {
    final key = dayKey(DateTime.now());
    final sleep = _days[key]?.sleepHours ?? 0;
    _days[key] = DayMetrics(sleepHours: sleep);
    notifyListeners();
    _saveDays();
  }

  double caloriesFor(ActivityKind kind, double distanceKm) =>
      distanceKm * _weightKg * kind.kcalPerKmKg;

  Future<void> addActivity(TrackedActivity activity) async {
    final route = _downsample(activity.route);
    final saved = TrackedActivity(
      id: activity.id,
      kind: activity.kind,
      startedAt: activity.startedAt,
      duration: activity.duration,
      distanceKm: activity.distanceKm,
      calories: activity.calories,
      route: route,
    );
    _activities = [saved, ..._activities];
    _updateToday((d) => d.copyWith(
          runKm: activity.kind == ActivityKind.run
              ? d.runKm + activity.distanceKm
              : null,
          walkKm: activity.kind == ActivityKind.walk
              ? d.walkKm + activity.distanceKm
              : null,
          rideKm: activity.kind == ActivityKind.ride
              ? d.rideKm + activity.distanceKm
              : null,
          calories: d.calories + activity.calories,
        ));
    await _prefs?.setString(
      _activitiesKey,
      jsonEncode([for (final a in _activities) a.toJson()]),
    );
  }

  Future<void> deleteActivity(String id) async {
    _activities = _activities.where((a) => a.id != id).toList();
    notifyListeners();
    await _prefs?.setString(
      _activitiesKey,
      jsonEncode([for (final a in _activities) a.toJson()]),
    );
  }

  Future<void> updateGoals(Goals goals) async {
    _goals = goals;
    notifyListeners();
    await _prefs?.setString(_goalsKey, jsonEncode(goals.toJson()));
  }

  Future<void> updateProfile({String? name, double? weightKg}) async {
    if (name != null && name.trim().isNotEmpty) _name = name.trim();
    if (weightKg != null && weightKg > 0) _weightKg = weightKg;
    notifyListeners();
    await _prefs?.setString(_nameKey, _name);
    await _prefs?.setDouble(_weightKey, _weightKg);
  }

  Future<void> clearAll() async {
    _days = {};
    _activities = [];
    _goals = const Goals();
    notifyListeners();
    final prefs = _prefs;
    if (prefs == null) return;
    await prefs.remove(_daysKey);
    await prefs.remove(_activitiesKey);
    await prefs.remove(_goalsKey);
  }

  Future<void> _saveDays() async {
    if (_days.length > _maxDaysKept) {
      final keys = _days.keys.toList()..sort();
      for (final k in keys.take(_days.length - _maxDaysKept)) {
        _days.remove(k);
      }
    }
    await _prefs?.setString(
      _daysKey,
      jsonEncode(_days.map((k, v) => MapEntry(k, v.toJson()))),
    );
  }

  List<List<double>> _downsample(List<List<double>> route) {
    if (route.length <= _maxRoutePoints) return route;
    final step = route.length / _maxRoutePoints;
    return [
      for (var i = 0; i < _maxRoutePoints; i++) route[(i * step).floor()],
      route.last,
    ];
  }
}
