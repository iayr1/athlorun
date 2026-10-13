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
  final List<String> medications;
  final List<String> symptoms;
  final String? healthNotes;
  final bool bodyScanCompleted;
  final bool voiceSampleCompleted;

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
    this.medications = const [],
    this.symptoms = const [],
    this.healthNotes,
    this.bodyScanCompleted = false,
    this.voiceSampleCompleted = false,
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
    List<String>? medications,
    List<String>? symptoms,
    String? healthNotes,
    bool? bodyScanCompleted,
    bool? voiceSampleCompleted,
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
      medications: medications ?? this.medications,
      symptoms: symptoms ?? this.symptoms,
      healthNotes: healthNotes ?? this.healthNotes,
      bodyScanCompleted: bodyScanCompleted ?? this.bodyScanCompleted,
      voiceSampleCompleted: voiceSampleCompleted ?? this.voiceSampleCompleted,
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
        'medications': medications,
        'symptoms': symptoms,
        'healthNotes': healthNotes,
        'bodyScanCompleted': bodyScanCompleted,
        'voiceSampleCompleted': voiceSampleCompleted,
      };

  factory HealthAssessment.fromJson(Map<String, dynamic> json) {
    List<String> strings(Object? v) =>
        v is List ? v.whereType<String>().toList() : const [];
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
      medications: strings(json['medications']),
      symptoms: strings(json['symptoms']),
      healthNotes: json['healthNotes'] as String?,
      bodyScanCompleted: json['bodyScanCompleted'] == true,
      voiceSampleCompleted: json['voiceSampleCompleted'] == true,
    );
  }
}

/// Details from the "Profile Setup & Account Completion" flow.
class AccountDetails {
  final int? avatarId;

  /// Small JPEG (base64) when the user uploaded their own picture.
  final String? avatarImage;
  final String? phone;
  final bool phoneVerified;
  final String? location;
  final String? jobPosition;
  final String? accountType;
  final Map<String, bool> notifications;

  const AccountDetails({
    this.avatarId,
    this.avatarImage,
    this.phone,
    this.phoneVerified = false,
    this.location,
    this.jobPosition,
    this.accountType,
    this.notifications = const {},
  });

  AccountDetails copyWith({
    int? avatarId,
    String? avatarImage,
    bool clearAvatarImage = false,
    String? phone,
    bool? phoneVerified,
    String? location,
    String? jobPosition,
    String? accountType,
    Map<String, bool>? notifications,
  }) {
    return AccountDetails(
      avatarId: avatarId ?? this.avatarId,
      avatarImage: clearAvatarImage ? null : (avatarImage ?? this.avatarImage),
      phone: phone ?? this.phone,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      location: location ?? this.location,
      jobPosition: jobPosition ?? this.jobPosition,
      accountType: accountType ?? this.accountType,
      notifications: notifications ?? this.notifications,
    );
  }

  Map<String, dynamic> toJson() => {
        'avatarId': avatarId,
        'avatarImage': avatarImage,
        'phone': phone,
        'phoneVerified': phoneVerified,
        'location': location,
        'jobPosition': jobPosition,
        'accountType': accountType,
        'notifications': notifications,
      };

  factory AccountDetails.fromJson(Map<String, dynamic> json) {
    final n = json['notifications'];
    return AccountDetails(
      avatarId: (json['avatarId'] as num?)?.toInt(),
      avatarImage: json['avatarImage'] as String?,
      phone: json['phone'] as String?,
      phoneVerified: json['phoneVerified'] == true,
      location: json['location'] as String?,
      jobPosition: json['jobPosition'] as String?,
      accountType: json['accountType'] as String?,
      notifications: n is Map
          ? {
              for (final e in n.entries)
                if (e.value is bool) '${e.key}': e.value as bool,
            }
          : const {},
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
  final AccountDetails? account;

  const UserProfile({
    required this.uid,
    required this.name,
    this.email,
    this.photoUrl,
    this.assessment,
    this.account,
  });

  bool get assessmentCompleted => assessment != null;
  bool get accountCompleted => account != null;

  UserProfile copyWith({
    String? name,
    HealthAssessment? assessment,
    AccountDetails? account,
  }) {
    return UserProfile(
      uid: uid,
      email: email,
      photoUrl: photoUrl,
      name: name ?? this.name,
      assessment: assessment ?? this.assessment,
      account: account ?? this.account,
    );
  }
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
        account: data['account'] is Map
            ? AccountDetails.fromJson(
                Map<String, dynamic>.from(data['account'] as Map),
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
      _profile = p.copyWith(assessment: assessment);
      notifyListeners();
    }
  }

  /// Saves the profile-setup answers and marks the account as completed.
  Future<void> saveAccount(AccountDetails account, {String? name}) async {
    final uid = _uid;
    if (uid == null) return;
    await _userDoc.set({
      'account': account.toJson(),
      'accountCompletedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    if (name != null && name.trim().isNotEmpty) {
      await _store.updateProfile(name: name);
    }
    final p = _profile;
    if (p != null) {
      _profile = p.copyWith(account: account, name: name?.trim());
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
      _profile = p.copyWith(name: name);
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
