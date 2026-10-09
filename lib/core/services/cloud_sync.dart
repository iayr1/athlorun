import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'metrics_store.dart';

/// Answers from the onboarding health assessment.
class HealthAssessment {
  final String? goal;
  final String? gender;
  final double? weightKg;
  final int? age;
  final String? bloodType;
  final int? fitnessLevel;
  final int? sleepLevel;
  final String? mood;
  final String? eatingHabit;

  const HealthAssessment({
    this.goal,
    this.gender,
    this.weightKg,
    this.age,
    this.bloodType,
    this.fitnessLevel,
    this.sleepLevel,
    this.mood,
    this.eatingHabit,
  });

  HealthAssessment copyWith({
    String? goal,
    String? gender,
    double? weightKg,
    int? age,
    String? bloodType,
    int? fitnessLevel,
    int? sleepLevel,
    String? mood,
    String? eatingHabit,
  }) {
    return HealthAssessment(
      goal: goal ?? this.goal,
      gender: gender ?? this.gender,
      weightKg: weightKg ?? this.weightKg,
      age: age ?? this.age,
      bloodType: bloodType ?? this.bloodType,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      sleepLevel: sleepLevel ?? this.sleepLevel,
      mood: mood ?? this.mood,
      eatingHabit: eatingHabit ?? this.eatingHabit,
    );
  }

  Map<String, dynamic> toJson() => {
        'goal': goal,
        'gender': gender,
        'weightKg': weightKg,
        'age': age,
        'bloodType': bloodType,
        'fitnessLevel': fitnessLevel,
        'sleepLevel': sleepLevel,
        'mood': mood,
        'eatingHabit': eatingHabit,
      };

  factory HealthAssessment.fromJson(Map<String, dynamic> json) {
    return HealthAssessment(
      goal: json['goal'] as String?,
      gender: json['gender'] as String?,
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      age: (json['age'] as num?)?.toInt(),
      bloodType: json['bloodType'] as String?,
      fitnessLevel: (json['fitnessLevel'] as num?)?.toInt(),
      sleepLevel: (json['sleepLevel'] as num?)?.toInt(),
      mood: json['mood'] as String?,
      eatingHabit: json['eatingHabit'] as String?,
    );
  }
}

/// Signed-in user's profile document (`users/{uid}`).
class UserProfile {
  final String uid;
  final String? email;
  final String name;
  final String? photoUrl;
  final HealthAssessment? assessment;

  const UserProfile({
    required this.uid,
    required this.name,
    this.email,
    this.photoUrl,
    this.assessment,
  });

  bool get assessmentCompleted => assessment != null;
}

/// Mirrors [MetricsStore] to Cloud Firestore for the signed-in user.
///
/// Layout:
/// - `users/{uid}`: profile, goals, weight and health assessment
/// - `users/{uid}/days/{yyyy-MM-dd}`: daily metrics
/// - `users/{uid}/activities/{id}`: tracked workouts
class CloudSync extends ChangeNotifier implements MetricsSyncDelegate {
  CloudSync._();

  static final CloudSync instance = CloudSync._();

  static const _dayWriteDelay = Duration(seconds: 4);

  final MetricsStore _store = MetricsStore.instance;
  final Map<String, Timer> _pendingDays = {};

  String? _uid;
  UserProfile? _profile;
  bool _syncing = false;

  UserProfile? get profile => _profile;
  bool get isSyncing => _syncing;

  FirebaseFirestore get _db => FirebaseFirestore.instance;
  DocumentReference<Map<String, dynamic>> get _userDoc =>
      _db.collection('users').doc(_uid);

  /// Downloads the user's data, merges it with local data, uploads anything
  /// newer and then keeps mirroring local changes.
  Future<UserProfile> start(User user) async {
    if (_uid == user.uid && _profile != null) return _profile!;
    await stop();
    _uid = user.uid;
    _syncing = true;
    notifyListeners();
    try {
      final snap = await _userDoc.get();
      final data = snap.data() ?? <String, dynamic>{};
      if (!snap.exists) {
        await _userDoc.set({
          'name': user.displayName ?? _store.name,
          'email': user.email,
          'photoUrl': user.photoURL,
          'weightKg': _store.weightKg,
          'goals': _store.goals.toJson(),
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      final since = MetricsStore.dayKey(
        DateTime.now().subtract(const Duration(days: 60)),
      );
      final daysSnap = await _userDoc
          .collection('days')
          .where(FieldPath.documentId, isGreaterThanOrEqualTo: since)
          .get();
      final activitiesSnap = await _userDoc
          .collection('activities')
          .orderBy('startedAt', descending: true)
          .limit(200)
          .get();

      final remoteName = (data['name'] as String?) ?? user.displayName;
      final localNewer = await _store.mergeRemote(
        days: {
          for (final d in daysSnap.docs) d.id: DayMetrics.fromJson(d.data()),
        },
        activities: [
          for (final a in activitiesSnap.docs) _activityFromDoc(a.data()),
        ],
        goals: data['goals'] is Map
            ? Goals.fromJson(Map<String, dynamic>.from(data['goals'] as Map))
            : null,
        name: remoteName,
        weightKg: (data['weightKg'] as num?)?.toDouble(),
      );

      // Upload days and workouts recorded before signing in.
      final batch = _db.batch();
      final all = _store.allDays;
      for (final key in localNewer) {
        final day = all[key];
        if (day == null) continue;
        batch.set(_userDoc.collection('days').doc(key), _dayJson(day));
      }
      final remoteIds = {for (final a in activitiesSnap.docs) a.id};
      for (final a in _store.activities) {
        if (!remoteIds.contains(a.id)) {
          batch.set(
            _userDoc.collection('activities').doc(a.id),
            _activityToDoc(a),
          );
        }
      }
      await batch.commit();

      _profile = UserProfile(
        uid: user.uid,
        email: user.email,
        name: _store.name,
        photoUrl: (data['photoUrl'] as String?) ?? user.photoURL,
        assessment: data['assessment'] is Map
            ? HealthAssessment.fromJson(
                Map<String, dynamic>.from(data['assessment'] as Map),
              )
            : null,
      );
      _store.syncDelegate = this;
      return _profile!;
    } finally {
      _syncing = false;
      notifyListeners();
    }
  }

  /// Flushes pending writes and stops mirroring.
  Future<void> stop() async {
    if (_store.syncDelegate == this) _store.syncDelegate = null;
    for (final entry in _pendingDays.entries.toList()) {
      entry.value.cancel();
      await _writeDay(entry.key);
    }
    _pendingDays.clear();
    _uid = null;
    _profile = null;
    notifyListeners();
  }

  Future<void> saveAssessment(HealthAssessment assessment) async {
    final uid = _uid;
    if (uid == null) return;
    await _userDoc.set({
      'assessment': assessment.toJson(),
      'assessmentCompletedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    if (assessment.weightKg != null) {
      await _store.updateProfile(weightKg: assessment.weightKg);
    }
    final p = _profile;
    if (p != null) {
      _profile = UserProfile(
        uid: p.uid,
        name: p.name,
        email: p.email,
        photoUrl: p.photoUrl,
        assessment: assessment,
      );
      notifyListeners();
    }
  }

  @override
  void dayChanged(String key, DayMetrics day) {
    if (_uid == null) return;
    _pendingDays[key]?.cancel();
    _pendingDays[key] = Timer(_dayWriteDelay, () => _writeDay(key));
  }

  Future<void> _writeDay(String key) async {
    _pendingDays.remove(key);
    final day = _store.allDays[key];
    if (_uid == null || day == null) return;
    await _safe(() => _userDoc.collection('days').doc(key).set(_dayJson(day)));
  }

  @override
  void activityAdded(TrackedActivity activity) {
    if (_uid == null) return;
    _safe(() => _userDoc
        .collection('activities')
        .doc(activity.id)
        .set(_activityToDoc(activity)));
  }

  @override
  void activityDeleted(String id) {
    if (_uid == null) return;
    _safe(() => _userDoc.collection('activities').doc(id).delete());
  }

  @override
  void goalsChanged(Goals goals) {
    if (_uid == null) return;
    _safe(() => _userDoc.set({
          'goals': goals.toJson(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true)));
  }

  @override
  void profileChanged(String name, double weightKg) {
    if (_uid == null) return;
    final p = _profile;
    if (p != null) {
      _profile = UserProfile(
        uid: p.uid,
        name: name,
        email: p.email,
        photoUrl: p.photoUrl,
        assessment: p.assessment,
      );
      notifyListeners();
    }
    _safe(() => _userDoc.set({
          'name': name,
          'weightKg': weightKg,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true)));
  }

  @override
  void cleared() {
    if (_uid == null) return;
    _safe(() async {
      for (final sub in ['days', 'activities']) {
        final docs = await _userDoc.collection(sub).get();
        final batch = _db.batch();
        for (final d in docs.docs) {
          batch.delete(d.reference);
        }
        await batch.commit();
      }
      await _userDoc.set({
        'goals': const Goals().toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });
  }

  Map<String, dynamic> _dayJson(DayMetrics day) => {
        ...day.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

  // Firestore cannot store nested arrays, so routes are lists of GeoPoints.
  Map<String, dynamic> _activityToDoc(TrackedActivity a) {
    final json = a.toJson();
    json['startedAt'] = Timestamp.fromDate(a.startedAt);
    json['route'] = [for (final p in a.route) GeoPoint(p[0], p[1])];
    return json;
  }

  TrackedActivity _activityFromDoc(Map<String, dynamic> doc) {
    final json = Map<String, dynamic>.from(doc);
    final started = json['startedAt'];
    if (started is Timestamp) {
      json['startedAt'] = started.toDate().toIso8601String();
    }
    json['route'] = [
      for (final p in (json['route'] as List? ?? const []))
        if (p is GeoPoint) [p.latitude, p.longitude],
    ];
    return TrackedActivity.fromJson(json);
  }

  Future<void> _safe(Future<void> Function() write) async {
    try {
      await write();
    } catch (e) {
      // Firestore queues writes offline; anything reaching here is a real
      // failure (e.g. security rules), which should not crash the app.
      debugPrint('CloudSync write failed: $e');
    }
  }
}
