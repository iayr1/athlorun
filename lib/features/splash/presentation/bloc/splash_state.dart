part of 'splash_cubit.dart';

@freezed
class SplashState with _$SplashState {
  const factory SplashState.comitial() = _Initial;
/*
  >>> Auth Data
*/
  const factory SplashState.loadingAuthData() = _LoadingAuthData;
  const factory SplashState.loadedAuthData(UserAuthDataModel authData) =
      _LoadedAuthData;
  const factory SplashState.loadAuthDataError(String error) =
      _LoadAuthDataError;
/*
  >>> Auth Data
*/

/*
  >>> Auth Data
*/
  const factory SplashState.loadingUserData() = _LoadingUserData;
  const factory SplashState.loadedUserData(UserData userData) = _LoadedUserData;
  const factory SplashState.loadUserDataError(String error) =
      _LoadUserDataError;
/*
  >>> Auth Data
*/

/*
  >>> Onboarding Status
*/
  const factory SplashState.loadingOnboardingStatus() =
      _LoadingOnboardingStatus;
  const factory SplashState.loadedOnboardingStatus() = _LoadedOnboardingStatus;
  const factory SplashState.loadOnboardingStatusError(String error) =
      _LoadOnboardingStatusError;
/*
  >>> Onboarding Status
*/

/*
  >>> User Progress Data
*/
  const factory SplashState.loadingUserProgressData() =
      _LoadingUserProgressData;
  const factory SplashState.loadedUserProgressData(
          UserData userData, UserDataProgressModel progressData) =
      _LoadedUserProgressData;
  const factory SplashState.loadUserProgressDataError(
      UserData userData, String error) = _LoadUserProgressDataError;
/*
  >>> User Progress Data
*/
}
