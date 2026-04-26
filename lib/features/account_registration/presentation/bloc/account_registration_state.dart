part of 'account_registration_cubit.dart';

@freezed
class AccountRegistrationState with _$AccountRegistrationState {
  const factory AccountRegistrationState.comitial() = _Initial;

  const factory AccountRegistrationState.checkboxLoading() = _Loading;
  const factory AccountRegistrationState.checkboxLoaded(bool isChecked) =
      _Loaded;

  const factory AccountRegistrationState.validatingTextField() =
      _ValidatingTextField;
  const factory AccountRegistrationState.validatedTextField(bool isFormValid) =
      _ValidatedTextField;

  const factory AccountRegistrationState.settingAuthData() = _SettingAuthData;
  const factory AccountRegistrationState.setAuthData(
      UserAuthDataModel authData) = _SetAuthData;
  const factory AccountRegistrationState.setAuthDataError(String error) =
      _SetAuthDataError;

  const factory AccountRegistrationState.gettingAuthData() = _GettingAuthData;
  const factory AccountRegistrationState.gotAuthData(
      UserAuthDataModel authData) = _GotAuthData;
  const factory AccountRegistrationState.getAuthDataError(String error) =
      _GetAuthDataError;

  const factory AccountRegistrationState.settingOnboardingStatus() =
      _SettingOnboardingStatus;
  const factory AccountRegistrationState.setOnboardingStatus() =
      _SetOnboardingStatus;
  const factory AccountRegistrationState.setOnboardingStatusError(
      String error) = _SetOnboardingStatusError;

  const factory AccountRegistrationState.settingUserProgressData() =
      _SettingUserProgressData;
  const factory AccountRegistrationState.setUserProgressData(
      UserDataProgressModel progressData) = _SetUserProgressData;
  const factory AccountRegistrationState.setUserProgressDataError(
      String error) = _SetUserProgressDataError;

  const factory AccountRegistrationState.sendingOtp() = _SendingOtp;
  const factory AccountRegistrationState.sentOtp(
      SendOtpResponseModel response) = _SentOtp;
  const factory AccountRegistrationState.sendOtpError(String error) =
      _SendOtpError;

  const factory AccountRegistrationState.verifyingOtp() = _VerifyingOtp;
  const factory AccountRegistrationState.verifiedOtp(
      VerifyOtpResponseModel response) = _VerifiedOtp;
  const factory AccountRegistrationState.verifyOtpError(String error) =
      _VerifyOtpError;

  const factory AccountRegistrationState.uploadingSelfie() = _UploadingSelfie;
  const factory AccountRegistrationState.uploadedSelfie(
      SelfieResponseModel response) = _UploadedSelfie;
  const factory AccountRegistrationState.uploadSelfieError(String error) =
      _UploadSelfieError;

  const factory AccountRegistrationState.patchingUserData() = _PatchingUserData;
  const factory AccountRegistrationState.patchedUserData(UserData userData) =
      _PatchedUserData;
  const factory AccountRegistrationState.patchUserDataError(String error) =
      _PatchUserDataError;

  const factory AccountRegistrationState.loadingUserData() = _LoadingUserData;
  const factory AccountRegistrationState.loadedUserData(
      UserAuthDataModel authData, UserData userData) = _LoadedUserData;
  const factory AccountRegistrationState.loadUserDataError(String error) =
      _LoadUserDataError;

  const factory AccountRegistrationState.detectingFace() = _DetectingFace;
  const factory AccountRegistrationState.detectedFace(bool result, File image) =
      _DetectedFace;
  const factory AccountRegistrationState.detectFaceError(String error) =
      _DetectFaceError;

  const factory AccountRegistrationState.updatingState() = _UpdatingState;
  const factory AccountRegistrationState.updatedState() = _UpdatedState;

  const factory AccountRegistrationState.selectingCountry() = _SelectingCountry;
  const factory AccountRegistrationState.selectedCountry(
      String countryName, String countryCode) = _SelectedCountry;

  const factory AccountRegistrationState.loadingTargets() = _LoadingTargets;
  const factory AccountRegistrationState.loadedTargets(
      TargetsResponseModel targets) = _LoadedTargets;
  const factory AccountRegistrationState.loadTargetsError(String error) =
      _LoadTargetsError;
}
