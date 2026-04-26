part of 'settings_cubit.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState.comitial() = _Initial;

  const factory SettingsState.deletingUser() = _DeletingUser;
  const factory SettingsState.deletedUser(DeleteUserResponseModel response) =
      _DeletedUser;
  const factory SettingsState.deleteUserError(String error) = _DeleteUserError;

  const factory SettingsState.loggingOut() = _LoggingOut;
  const factory SettingsState.loggedOut() = _LoggedOut;
  const factory SettingsState.logOutError(String error) = _LogOutError;

  const factory SettingsState.loadingAuthData() = _LoadingAuthData;
  const factory SettingsState.loadedAuthData(UserAuthDataModel authData) =
      _LoadedAuthData;
  const factory SettingsState.loadAuthDataError(String error) =
      _LoadAuthDataError;

  const factory SettingsState.loadingNotificationPreferences() =
      _LoadingNotificationPreferences;
  const factory SettingsState.loadedNotificationPreferences(
          GetNotificationPreferencesResponseModel response) =
      _LoadedNotificationPreferences;
  const factory SettingsState.loadNotificationPreferencesError(String error) =
      _LoadNotificationPreferencesError;

  const factory SettingsState.updatingNotificationPreferences() =
      _UpdatingNotificationPreferences;
  const factory SettingsState.updatedNotificationPreferences(
      List<Datum> items) = _UpdatedNotificationPreferences;
  const factory SettingsState.updateNotificationPreferencesError(String error) =
      _UpdateNotificationPreferencesError;
}
