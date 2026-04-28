part of 'home_page_cubit.dart';

@freezed
class HomePageState with _$HomePageState {
  const factory HomePageState.comitial() = _Initial;

  const factory HomePageState.checkingHealthSdkStatus() =
      _CheckingHealthSdkStatus;
  const factory HomePageState.checkedHealthSdkStatus(bool status) =
      _CheckedHealthSdkStatus;
  const factory HomePageState.checkHealthSdkStatusError(String error) =
      _CheckHealthSdkStatusError;

  const factory HomePageState.settingVisibility() = _SettingVisibility;
  const factory HomePageState.setVisibility(bool visibility) = _SetVisibility;

  const factory HomePageState.checkingHealthPermissions() =
      _CheckingHealthPermissions;
  const factory HomePageState.checkedHealthPermissions(bool status) =
      _CheckedHealthPermissions;
  const factory HomePageState.checkHealthPermissionsError(String error) =
      _CheckHealthPermissionsError;

  const factory HomePageState.requestingHealthPermissions() =
      _RequestingHealthPermissions;
  const factory HomePageState.requestedHealthPermissions(bool status) =
      _RequestedHealthPermissions;
  const factory HomePageState.requestHealthPermissionsError(String error) =
      _RequestHealthPermissionsError;

  const factory HomePageState.gettingTotalStepsInInterval() =
      _GettingTotalStepsInInterval;
  const factory HomePageState.gotTotalStepsInInterval(int steps) =
      _GotTotalStepsInInterval;
  const factory HomePageState.getTotalStepsInIntervalError(String error) =
      _GetTotalStepsInIntervalError;

  const factory HomePageState.loadingNotifications() = _LoadingNotifications;
  const factory HomePageState.loadedNotifications(dynamic notifications) =
      _LoadedNotifications;
  const factory HomePageState.loadNotificationsError(String error) =
      _LoadNotificationsError;

  const factory HomePageState.markingNotificationAsSeen() =
      _MarkingNotificationAsSeen;
  const factory HomePageState.markedNotificationAsSeen(dynamic response) =
      _MarkedNotificationAsSeen;
  const factory HomePageState.markNotificationAsSeenError(String error) =
      _MarkNotificationAsSeenError;

  const factory HomePageState.enablingNotification() = _EnablingNotification;
  const factory HomePageState.enabledNotification(
      EnableNotificationResponseModel response) = _EnabledNotification;
  const factory HomePageState.enableNotificationError(String error) =
      _EnableNotificationError;


  const factory HomePageState.fetchingFcmToken() = _FetchingFcmToken;
  const factory HomePageState.fetchedFcmToken(String? fcmToken) =
      _FetchedFcmToken;
  const factory HomePageState.fetchFcmTokenError(String error) =
      _FetchFcmTokenError;

  const factory HomePageState.gettingAuthData() = _GettingAuthData;
  const factory HomePageState.gotAuthData(UserAuthDataModel authData) =
      _GotAuthData;
  const factory HomePageState.getAuthDataError(String error) =
      _GetAuthDataError;

  const factory HomePageState.updatingStepData() = _UpdatingStepData;
  const factory HomePageState.updatedStepData(StepResponseModel data) =
      _UpdatedStepData;
  const factory HomePageState.updateStepDataError(String error) =
      _UpdateStepDataError;

  const factory HomePageState.loadingWallet() = _LoadingWallet;
  const factory HomePageState.loadedWallet(WalletResponseModel data) =
      _LoadedWallet;
  const factory HomePageState.loadWalletError(String error) = _LoadWalletError;

  const factory HomePageState.loadingUserProfile() = _LoadingUserProfile;
  const factory HomePageState.loadedUserProfile(UserData userData) =
      _LoadedUserProfile;
  const factory HomePageState.loadUserProfileError(String error) =
      _LoadUserProfileError;
}
