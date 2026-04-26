part of 'track_page_cubit.dart';

@freezed
class TrackPageState with _$TrackPageState {
  const factory TrackPageState.comitial() = _Initial;

  const factory TrackPageState.sportChanged(String sport) = _SportChanged;

  ///Location States
  const factory TrackPageState.loadingLocation() = _LoadingLocation;
  const factory TrackPageState.loadedLocation(LatLng currentLocation) =
      _LoadedLocation;
  const factory TrackPageState.loadLocationError(String error) =
      _LoadLocationError;

  // Activity States
  const factory TrackPageState.loadingSaveActivity() = _LoadingSaveActivity;
  const factory TrackPageState.activitySaved() = _ActivitySaved;
  const factory TrackPageState.saveActivityError(String message) =
      _SaveActivityError;

  // Sports API States
  const factory TrackPageState.loadingSports() = _LoadingSports;
  const factory TrackPageState.loadedSports(List<SportsList> sports) =
      _LoadedSports;
  const factory TrackPageState.loadSportsError(String message) =
      _LoadSportsError;

  // Tracking States
  const factory TrackPageState.trackingStarted({
    required List<LatLng> route,
    required double distance,
    required Duration duration,
    required List<Marker> markers,
  }) = _TrackingStarted;

  const factory TrackPageState.trackingUpdated({
    required List<LatLng> route,
    required double distance,
    required Duration duration,
    required List<Marker> markers,
  }) = _TrackingUpdated;

  const factory TrackPageState.trackingStopped({
    required List<LatLng> route,
    required double distance,
    required Duration duration,
    required List<Marker> markers,
  }) = _TrackingStopped;

  const factory TrackPageState.gettingUserProfile() = _GettingUserProfile;
  const factory TrackPageState.gotUserProfile(UserDataResponseModel authData) =
      _GotUserProfile;
  const factory TrackPageState.getUserProfileError(String error) =
      _GetUserProfileError;

  const factory TrackPageState.loadingGear() = _LoadingGear;
  const factory TrackPageState.loadedGear(GetGearResponseModel response) =
      _LoadedGear;
  const factory TrackPageState.loadGearError(String error) = _LoadGearError;

  const factory TrackPageState.trackingError(String error) = _TrackingError;
}
