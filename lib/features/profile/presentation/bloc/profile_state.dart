part of 'profile_cubit.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.comitial() = _Initial;

  const factory ProfileState.loadingGearTypes() = _LoadingGearTypes;
  const factory ProfileState.loadedGearTypes(GetGearTypesResponseModel data) =
      _LoadedGearTypes;
  const factory ProfileState.loadGearTypesError(String error) =
      _LoadGearTypesError;

  const factory ProfileState.loadingSports() = _LoadingSports;
  const factory ProfileState.loadedSports(GetSportsResponseModel data) =
      _LoadedSports;
  const factory ProfileState.loadSportsError(String error) = _LoadSportsError;

  const factory ProfileState.creatingGear() = _CreatingGear;
  const factory ProfileState.createdGear(CreateGearRequestModel response) =
      _CreatedGear;
  const factory ProfileState.createGearError(String error) = _CreateGearError;

  const factory ProfileState.updatingGear() = _UpdatingGear;
  const factory ProfileState.updatedGear(CreateGearRequestModel response) =
      _UpdatedGear;
  const factory ProfileState.updateGearError(String error) = _UpdateGearError;

  const factory ProfileState.creatingSchedule() = _CreatingSchedule;
  const factory ProfileState.createdSchedule(
      CreateScheduleRequestModel response) = _CreatedSchedule;
  const factory ProfileState.createScheduleError(String error) =
      _CreateScheduleError;

  const factory ProfileState.loadingSchedule({DateTime? selectedDate}) =
      _loadingSchedule;
  const factory ProfileState.loadedSchedule(
      List<GetScheduleResponseModelData> data,
      {DateTime? selectedDate}) = _loadedSchedule;
  const factory ProfileState.loadScheduleError(String error,
      {DateTime? selectedDate}) = _loadScheduleError;

  const factory ProfileState.deletingSchedule() = _DeletingSchedule;
  const factory ProfileState.deleteSchedule() = _DeleteSchedule;
  const factory ProfileState.deleteScheduleError(String error) =
      _DeleteScheduleError;

  const factory ProfileState.updatingSchedule() = _UpdatingSchedule;
  const factory ProfileState.updatedSchedule(
      CreateScheduleRequestModel response) = _UpdatedSchedule;
  const factory ProfileState.updateScheduleError(String error) =
      _UpdateScheduleError;

  const factory ProfileState.loadingGear() = _LoadingGear;
  const factory ProfileState.loadedGear(GetGearResponseModel response) =
      _LoadedGear;
  const factory ProfileState.loadGearError(String error) = _LoadGearError;

  const factory ProfileState.pickingImage() = _PickingImage;
  const factory ProfileState.pickedImage(File? image) = _PickedImage;
  const factory ProfileState.pickedImageError(String error) = _PickedImageError;

  const factory ProfileState.gettingAuthData() = _GettingAuthData;
  const factory ProfileState.gotAuthData(UserAuthDataModel authData) =
      _GotAuthData;
  const factory ProfileState.getAuthDataError(String error) = _GetAuthDataError;

  const factory ProfileState.deletingGear() = _DeletingGear;
  const factory ProfileState.deleteGear() = _DeleteGear;
  const factory ProfileState.deleteGearError(String error) = _DeleteGearError;

  const factory ProfileState.gettingUserProfile() = _GettingUserProfile;
  const factory ProfileState.gotUserProfile(UserDataResponseModel authData) =
      _GotUserProfile;
  const factory ProfileState.getUserProfileError(String error) =
      _GetUserProfileError;

  const factory ProfileState.updatingUserProfile() = _UpdatingUserProfile;
  const factory ProfileState.updatedUserProfile(
      UserDataResponseModel response) = _UpdatedUserProfile;
  const factory ProfileState.updateUserProfileError(String error) =
      _UpdateUserProfileError;

  const factory ProfileState.loadingTargets() = _LoadingTargets;
  const factory ProfileState.loadedTargets(
      ProfileTargetsResponseModel targets) = _LoadedTargets;
  const factory ProfileState.loadTargetsError(String error) = _LoadTargetsError;
}
