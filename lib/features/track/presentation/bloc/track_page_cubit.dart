import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:athlorun/core/global_store/domain/usecases/get_user_auth_data_usecase.dart';
import 'package:athlorun/features/profile/domain/usecases/get_gear_all_usecase.dart';
import 'package:athlorun/features/track/data/models/choose_sport_response_model.dart';

import '../../../../core/global_store/data/models/user_data_response_model.dart';
import '../../../profile/data/models/get_gear_response_model.dart';
import '../../../profile/domain/usecases/get_user_data_profile_usecase.dart';
import '../../domain/usecases/choose_sport_usecase.dart';
import '../../domain/usecases/save_activities_usecase.dart';

part 'track_page_state.dart';
part 'track_page_cubit.freezed.dart';

class TrackPageCubit extends Cubit<TrackPageState> {
  final ChooseSportsUsecase _chooseSportsUsecase;
  final SaveActivitiesUsecase _saveActivitiesUsecase;
  final GetUserDataProfileUsecase _getUserDataProfileUsecase;
  final GetUserAuthDataUsecase _getUserAuthDataUsecase;
  final GetGearAllUsecase _getGearAllUsecase;

  TrackPageCubit(
    this._chooseSportsUsecase,
    this._saveActivitiesUsecase,
    this._getUserDataProfileUsecase,
    this._getUserAuthDataUsecase,
    this._getGearAllUsecase,
  ) : super(const TrackPageState.comitial());

  StreamSubscription<Position>? _positionSubscription;
  Timer? _timer;

  String? _selectedSport;
  List<SportsList> _availableSports = [];
  List<LatLng> _route = [];
  List<Marker> _markers = [];
  double _distance = 0.0;
  DateTime? _startTime;
  SportsList? _selectedSportItem;
  SportsList? get selectedSportItem => _selectedSportItem;

  List<LatLng> _polylinePoints = [];
  Timer? _polylineTimer;
  LatLng? _startingLocation;

  List<SportsList> get availableSports => _availableSports;
  String? get selectedSport => _selectedSport;

  Future<void> loadAvailableSports() async {
    emit(const TrackPageState.loadingSports());
    final result = await _chooseSportsUsecase();
    result.fold(
      (failure) => emit(TrackPageState.loadSportsError(failure.message)),
      (response) {
        _availableSports = response.data;
        emit(TrackPageState.loadedSports(_availableSports));
      },
    );
  }

  Future<void> getUserProfileData() async {
    emit(const TrackPageState.gettingUserProfile());
    final authData = await _getUserAuthDataUsecase();
    authData.fold(
      (l) => emit(TrackPageState.getUserProfileError(l.errorMessage)),
      (authData) async {
        final response = await _getUserDataProfileUsecase.call(authData.id);
        response.fold(
          (l) => emit(TrackPageState.getUserProfileError(l.message)),
          (r) => emit(TrackPageState.gotUserProfile(r)),
        );
      },
    );
  }

  Future<void> initializeLocation() async {
    emit(const TrackPageState.loadingLocation());
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      final reqPermission = await Geolocator.requestPermission();
      if (reqPermission != LocationPermission.always &&
          reqPermission != LocationPermission.whileInUse) {
        emit(const TrackPageState.loadLocationError(
            'Location permission denied.'));
        return;
      }
    }
    final position = await Geolocator.getCurrentPosition();
    emit(TrackPageState.loadedLocation(
        LatLng(position.latitude, position.longitude)));
  }

  void resetAfterStop() async {
    final position = await Geolocator.getCurrentPosition();
    emit(TrackPageState.loadedLocation(
        LatLng(position.latitude, position.longitude)));
  }

  void setSport(SportsList sport) {
    _selectedSportItem = sport;
    _selectedSport = sport.id;
    emit(TrackPageState.sportChanged(sport.name));
  }

  Future<void> saveActivity({
    required String id,
    required String polyline,
    required String sportId,
    required String completedAt,
    required String distanceInKm,
    required String durationInSeconds,
    required String stepsCount,
    required String name,
    required String description,
    required String mapType,
    required String gearId,
    required String hideStatistics,
    required String exertion,
    required File mediaFile,
  }) async {
    emit(const TrackPageState.loadingSaveActivity());
    final authResult = await _getUserAuthDataUsecase();
    await authResult.fold(
      (failure) async =>
          emit(TrackPageState.saveActivityError("User auth data missing")),
      (authData) async {
        final result = await _saveActivitiesUsecase(
          authData.id,
          polyline,
          sportId,
          completedAt,
          distanceInKm,
          durationInSeconds,
          stepsCount,
          name,
          description,
          mapType,
          gearId,
          hideStatistics,
          exertion,
          mediaFile,
        );
        result.fold(
          (failure) => emit(TrackPageState.saveActivityError(failure.message)),
          (_) => emit(const TrackPageState.activitySaved()),
        );
      },
    );
  }

  void startTracking() async {
    final position = await Geolocator.getCurrentPosition();
    _startingLocation = LatLng(position.latitude, position.longitude);
    _polylinePoints = [_startingLocation!];
    _route.clear();
    _route.add(_startingLocation!);
    _markers.clear();
    _distance = 0.0;
    _startTime = DateTime.now();

    _markers.add(Marker(
      point: _startingLocation!,
      child: const Icon(Icons.place, color: Colors.green),
    ));

    emit(TrackPageState.trackingStarted(
      route: _route,
      distance: _distance,
      duration: Duration.zero,
      markers: _markers,
    ));

    _polylineTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      final newPos = await Geolocator.getCurrentPosition();
      final point = LatLng(newPos.latitude, newPos.longitude);
      _polylinePoints.add(point);
      _route.add(point);
    });

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen(_updateTracking);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final duration = DateTime.now().difference(_startTime!);
      emit(TrackPageState.trackingUpdated(
        route: _route,
        distance: _distance,
        duration: duration,
        markers: _markers,
      ));
    });
  }

  void _updateTracking(Position position) {
    final newPosition = LatLng(position.latitude, position.longitude);
    if (_route.isNotEmpty) {
      final addedDistance = Distance().as(
        LengthUnit.Kilometer,
        _route.last,
        newPosition,
      );
      _distance += addedDistance;
    } else {
      _markers.add(Marker(
        point: newPosition,
        child: const Icon(Icons.place, color: Colors.green),
      ));
    }
    _route.add(newPosition);
  }

  void stopTracking() {
    _positionSubscription?.cancel();
    _timer?.cancel();
    _polylineTimer?.cancel();

    if (_route.isNotEmpty) {
      _markers.add(Marker(
        point: _route.last,
        child: const Icon(Icons.place, color: Colors.red),
      ));
    }

    final duration = DateTime.now().difference(_startTime!);

    emit(TrackPageState.trackingStopped(
      route: _route,
      distance: _distance,
      duration: duration,
      markers: _markers,
    ));

    debugPrint('🚀 Final Polyline String: $polylineString');
    debugPrint('🏷 Selected Sport ID: $_selectedSport');
  }

  Future<void> getAllGear(String id) async {
    emit(const TrackPageState.loadingGear());
    final response = await _getGearAllUsecase.call(id);
    response.fold((l) {
      emit(TrackPageState.loadGearError(l.message));
    }, (r) {
      emit(TrackPageState.loadedGear(r));
    });
  }

  String get polylineString =>
      _polylinePoints.map((e) => "${e.latitude},${e.longitude}").join("|");

  String get selectedSportId => _selectedSport ?? '';

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    _timer?.cancel();
    _polylineTimer?.cancel();
    return super.close();
  }
}
