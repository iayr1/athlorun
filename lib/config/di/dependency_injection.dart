import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:athlorun/config/routes/navigation_service.dart';
import 'package:athlorun/config/routes/routes.dart';
import 'package:athlorun/core/constants/preference_string.dart';
import 'package:athlorun/core/exceptions/custom_exceptions.dart';
import 'package:athlorun/core/firebase/data/datasources/local/firebase_local_data_source.dart';
import 'package:athlorun/core/firebase/data/datasources/local/firebase_local_data_source_impl.dart';
import 'package:athlorun/core/firebase/data/datasources/remote/firebase_client.dart';
import 'package:athlorun/core/firebase/data/datasources/remote/firestore_backend.dart';
import 'package:athlorun/core/firebase/data/repository/firebase_repository_impl.dart';
import 'package:athlorun/core/firebase/domain/repository/firebase_repository.dart';
import 'package:athlorun/core/firebase/domain/usecases/enable_notification_usecase.dart';
import 'package:athlorun/core/firebase/domain/usecases/get_fcm_token_usecase.dart';
import 'package:athlorun/core/firebase/domain/usecases/request_notification_permission_usecase.dart';
import 'package:athlorun/core/firebase/firebase_services.dart';
import 'package:athlorun/core/global_store/cubit/global_store_cubit.dart';
import 'package:athlorun/core/global_store/data/datasources/local/global_store_local_data_source.dart';
import 'package:athlorun/core/global_store/data/datasources/local/global_store_local_data_source_impl.dart';
import 'package:athlorun/core/global_store/data/datasources/remote/global_store_client.dart';
import 'package:athlorun/core/global_store/data/models/user_auth_data_model.dart';
import 'package:athlorun/core/global_store/data/repository/global_store_repository_impl.dart';
import 'package:athlorun/core/global_store/domain/repository/global_store_repository.dart';
import 'package:athlorun/core/global_store/domain/usecases/check_health_permission_usecase.dart';
import 'package:athlorun/core/global_store/domain/usecases/logout_usecase.dart';
import 'package:athlorun/core/global_store/domain/usecases/get_health_connect_sdk_status_usecase.dart';
import 'package:athlorun/core/global_store/domain/usecases/get_onboarding_status_usecase.dart';
import 'package:athlorun/core/global_store/domain/usecases/get_total_steps_in_interval_usecase.dart';
import 'package:athlorun/core/global_store/domain/usecases/get_user_auth_data_usecase.dart';
import 'package:athlorun/core/global_store/domain/usecases/get_user_data_progress_model_usecase.dart';
import 'package:athlorun/core/global_store/domain/usecases/get_user_data_usecase.dart';
import 'package:athlorun/core/global_store/domain/usecases/install_health_connect_usecase.dart';
import 'package:athlorun/core/global_store/domain/usecases/pay_through_payment_gateway_usercase.dart';
import 'package:athlorun/core/global_store/domain/usecases/request_health_authorization_usecase.dart';
import 'package:athlorun/core/global_store/domain/usecases/set_onboarding_status_usecase.dart';
import 'package:athlorun/core/global_store/domain/usecases/set_user_auth_data_usecase.dart';
import 'package:athlorun/core/global_store/domain/usecases/set_user_data_progress_model_usecase.dart';
import 'package:athlorun/core/utils/health_handler.dart';
import 'package:athlorun/core/utils/secure_local_storage.dart';
import 'package:athlorun/features/account_registration/data/datasources/remote/account_registration_client.dart';
import 'package:athlorun/features/account_registration/data/repository/account_registration_repository_impl.dart';
import 'package:athlorun/features/account_registration/domain/repositoy/account_registration_repository.dart';
import 'package:athlorun/features/account_registration/domain/usecases/get_targets_usecase.dart';
import 'package:athlorun/features/account_registration/domain/usecases/patch_user_data_usecase.dart';
import 'package:athlorun/features/account_registration/domain/usecases/send_otp_usecase.dart';
import 'package:athlorun/features/account_registration/domain/usecases/upload_selfie_usecase.dart';
import 'package:athlorun/features/account_registration/domain/usecases/verify_otp_usecase.dart';
import 'package:athlorun/features/account_registration/presentation/bloc/account_registration_cubit.dart';
import 'package:athlorun/features/challenges/data/datasources/remote/challenges_client.dart';
import 'package:athlorun/features/challenges/data/repository/challenges_repository_impl.dart';
import 'package:athlorun/features/challenges/domain/repository/challenges_repository.dart';
import 'package:athlorun/features/challenges/domain/usecases/get_challenges_usecase.dart';
import 'package:athlorun/features/challenges/domain/usecases/get_participated_challenges_usecase.dart';
import 'package:athlorun/features/challenges/domain/usecases/get_user_participated_challenges_usecase.dart';
import 'package:athlorun/features/challenges/domain/usecases/leave_participated_challenges_usecase.dart';
import 'package:athlorun/features/challenges/domain/usecases/participated_challenges_usecase.dart';
import 'package:athlorun/features/challenges/presentation/bloc/challenges_cubit.dart';
import 'package:athlorun/features/events/data/datasource/remote/event_client.dart';
import 'package:athlorun/features/events/data/repository/events_respository_impl.dart';
import 'package:athlorun/features/events/domain/repository/events_repository.dart';
import 'package:athlorun/features/events/domain/usecases/booked_event_ticket_usecase.dart';
import 'package:athlorun/features/events/domain/usecases/get_events_usecase.dart';
import 'package:athlorun/features/events/presentation/bloc/events_page_cubit.dart';
import 'package:athlorun/features/home/data/datasources/remote/home_remote_client.dart';
import 'package:athlorun/features/home/data/repository/home_repository_impl.dart';
import 'package:athlorun/features/home/domain/repository/home_repository.dart';
import 'package:athlorun/features/home/domain/usecases/get_wallet_usecase.dart';
import 'package:athlorun/features/home/domain/usecases/update_step_data_usecase.dart';
import 'package:athlorun/features/profile/data/datasources/remote/profile_client.dart';
import 'package:athlorun/features/profile/data/repository/profile_repository_impl.dart';
import 'package:athlorun/features/profile/domain/repository/profile_repository.dart';
import 'package:athlorun/features/profile/domain/usecases/create_gear_usecase.dart';
import 'package:athlorun/features/profile/domain/usecases/delete_gear_usecase.dart';
import 'package:athlorun/features/profile/domain/usecases/get_gear_all_usecase.dart';
import 'package:athlorun/features/profile/domain/usecases/get_gear_types_usecase.dart';
import 'package:athlorun/features/profile/domain/usecases/get_sports_usecase.dart';
import 'package:athlorun/features/profile/domain/usecases/get_user_data_profile_usecase.dart';
import 'package:athlorun/features/profile/domain/usecases/profile_get_targets_usecase.dart';
import 'package:athlorun/features/profile/domain/usecases/schedule/create_schedule_usecase.dart';
import 'package:athlorun/features/profile/domain/usecases/schedule/delete_schedule_usecase.dart';
import 'package:athlorun/features/profile/domain/usecases/schedule/get_schedule_usecase.dart';
import 'package:athlorun/features/profile/domain/usecases/schedule/update_schedule_usecase.dart';
import 'package:athlorun/features/profile/domain/usecases/update_gear_usecase.dart';
import 'package:athlorun/features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:athlorun/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:athlorun/features/settings/domain/usecases/get_notification_preferences_usecase.dart';
import 'package:athlorun/features/home/domain/usecases/get_notifications_usecase.dart';
import 'package:athlorun/features/home/domain/usecases/mark_notification_as_seen_usecase.dart';
import 'package:athlorun/features/settings/domain/usecases/update_notification_preferences_usecase.dart';
import 'package:athlorun/features/home/presentation/bloc/home_page_cubit.dart';
import 'package:athlorun/features/settings/data/datasources/remote/settings_page_client.dart';
import 'package:athlorun/features/settings/data/repository/settings_repositories_impl.dart';
import 'package:athlorun/features/settings/domain/repository/settings_repository.dart';
import 'package:athlorun/features/settings/domain/usecases/delete_user_usecase.dart';
import 'package:athlorun/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:athlorun/features/splash/presentation/bloc/splash_cubit.dart';
import 'package:athlorun/features/track/data/datasources/track_client.dart';
import 'package:athlorun/features/track/data/repositories/track_repositories_impl.dart';
import 'package:athlorun/features/track/domain/repositories/track_repositories.dart';
import 'package:athlorun/features/track/domain/usecases/choose_sport_usecase.dart';
import 'package:athlorun/features/track/domain/usecases/save_activities_usecase.dart';

import '../../features/track/presentation/bloc/track_page_cubit.dart';

final sl = GetIt.instance;

Future<UserAuthDataModel> getAuthData() async {
  final result =
      await sl<SecureLocalStorage>().get(PreferenceString.userAuthData);
  if (result == null) {
    throw CacheException();
  }
  return UserAuthDataModel.fromJson(jsonDecode(result));
}

Future<void> setAuthData(UserAuthDataModel authData) async {
  await sl<SecureLocalStorage>()
      .set(PreferenceString.userAuthData, jsonEncode(authData.toJson()));
}

Future<UserAuthDataModel> getNewAuthData(UserAuthDataModel authData) async {
  throw CacheException();
}

Future<void> goToLoginScreen() async {
  try {
    // Clear all secure storage data
    await sl<SecureLocalStorage>().deleteAll();
  } catch (_) {}

  // Navigate to the login screen
  final BuildContext context =
      sl<NavigationService>().navigatorKey.currentContext!;
  Navigator.pushNamedAndRemoveUntil(
    context,
    AppRoutes.signIn,
    (route) => false,
  );
}

Future<void> setupServiceLocator() async {
  /*
    >>> Externs
  */
  sl.registerLazySingleton(() => SecureLocalStorage());
  sl.registerLazySingleton(() => NavigationService());

  Dio dio = Dio(
    BaseOptions(
      contentType: Headers.jsonContentType,
    ),
  );
  // Timeouts
  // dio.options.connectTimeout = const Duration(seconds: 10);
  // dio.options.receiveTimeout = const Duration(seconds: 10);
  // dio.options.sendTimeout = const Duration(seconds: 10);
  dio.interceptors.addAll(
    [
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            UserAuthDataModel authDataModel = await getAuthData();
            options.headers["authorization"] =
                "Bearer ${authDataModel.accessToken}";
          } catch (_) {
            return handler.next(options);
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          try {
            if (error.response!.data["statusCode"] == 401) {
              UserAuthDataModel authDataModel = await getAuthData();
              authDataModel = await getNewAuthData(authDataModel);
              error.requestOptions.headers["authorization"] =
                  "Bearer ${authDataModel.accessToken}";
              await setAuthData(authDataModel);
              var response = await dio.request(
                error.requestOptions.path,
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
                options: Options(
                  method: error.requestOptions.method,
                  headers: error.requestOptions.headers,
                ),
              );
              return handler.resolve(response);
            } else {
              return handler.next(error);
            }
          } catch (e) {
            if (e == CacheException) {
              goToLoginScreen();
            } else {
              return handler.next(error);
            }
          }
        },
      ),
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          error: true,
        )
    ],
  );

  sl.registerSingleton<Dio>(dio);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirestoreBackend(sl()));
  sl.registerLazySingleton(() => HealthHandler());
  sl.registerLazySingleton(() => FirebaseServices());

/*
  <<< Externs
*/

/*
  >>> Global Store
*/
  sl.registerFactory<GlobalStoreRepository>(
      () => GlobalStoreRepositoryImpl(sl(), sl()));
  sl.registerFactory<GlobalStoreLocalDataSource>(
      () => GlobalStoreLocalDataSourceImpl(sl(), sl()));
  sl.registerFactory<GlobalStoreClient>(() => GlobalStoreClient(sl()));
  sl.registerFactory(() => SetUserAuthDataUsecase(sl()));
  sl.registerFactory(() => GetUserAuthDataUsecase(sl()));
  sl.registerFactory(() => LogoutUsecase(sl()));
  sl.registerFactory(() => GetUserDataUsecase(sl()));
  sl.registerFactory(() => GetOnboardingStatusUsecase(sl()));
  sl.registerFactory(() => SetOnboardingStatusUsecase(sl()));
  sl.registerFactory(() => GetUserDataProgressModelUsecase(sl()));
  sl.registerFactory(() => SetUserDataProgressModelUsecase(sl()));
  sl.registerFactory(() => CheckHealthPermissionUsecase(sl()));
  sl.registerFactory(() => GetHealthConnectSdkStatusUsecase(sl()));
  sl.registerFactory(() => GetTotalStepsInIntervalUsecase(sl()));
  sl.registerFactory(() => InstallHealthConnectUsecase(sl()));
  sl.registerFactory(() => RequestHealthAuthorizationUsecase(sl()));
  sl.registerFactory(() => PayThroughPaymentGatewayUsercase(sl()));
  sl.registerFactory(() => GlobalStoreCubit(sl(), sl()));

/*
  <<< Global Store
*/
  sl.registerFactory<FirebaseLocalDataSource>(
      () => FirebaseLocalDataSourceImpl(sl()));
  sl.registerFactory<FirebaseClient>(() => FirebaseClient(sl()));
  sl.registerFactory<FirebaseRepository>(
      () => FirebaseRepositoryImpl(sl(), sl()));
  sl.registerFactory(() => EnableNotificationUsecase(sl()));
  sl.registerFactory(() => GetFcmTokenUsecase(sl()));
  sl.registerFactory(() => RequestNotificationPermissionUsecase(sl()));

/*
  >>> Account Registration 
*/
  sl.registerFactory<AccountRegistrationCubit>(() => AccountRegistrationCubit(
      sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<AccountRegistrationRepository>(
      () => AccountRegistrationRepositoryImpl(sl()));
  sl.registerFactory<AccountRegistrationClient>(
      () => AccountRegistrationClient(sl()));
  sl.registerFactory(() => SendOtpUsecase(sl()));
  sl.registerFactory(() => VerifyOtpUsecase(sl()));
  sl.registerFactory(() => GetTargetsUsecase(sl()));
  sl.registerFactory(() => UploadSelfieUsecase(sl()));
  sl.registerFactory(() => PatchUserDataUsecase(sl()));
/*
  <<< Account Registration 
*/

/*
  >>> Splash
*/
  sl.registerFactory(() => SplashCubit(sl(), sl(), sl(), sl()));

  // >>> TrackPage
  sl.registerFactory<TrackClient>(() => TrackClient(sl()));
  sl.registerFactory<TrackRepository>(() => TrackRepositoryImpl(sl()));
  sl.registerFactory(() => ChooseSportsUsecase(sl()));
  sl.registerFactory(() => SaveActivitiesUsecase(sl()));
  sl.registerFactory<TrackPageCubit>(
      () => TrackPageCubit(sl(), sl(), sl(), sl(), sl()));

/*
  <<< Splash
*/

/*
  >>> Home
*/
  sl.registerFactory(
    () => HomePageCubit(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(),
        sl(), sl(), sl(), sl(), sl()),
  );
  sl.registerFactory<HomeRepository>(() => HomeRepositoryImpl(sl()));
  sl.registerFactory<HomeRemoteClient>(() => HomeRemoteClient(sl()));
  sl.registerFactory(() => GetNotificationsUsecase(sl()));
  sl.registerFactory(() => MarkNotificationAsSeenUsecase(sl()));
  sl.registerFactory(() => UpdateStepDataUsecase(sl()));
  sl.registerFactory(() => GetWalletUsecase(sl()));

/*
  <<< Home
*/

/*
  >>> Setting
*/
  sl.registerFactory(() => SettingsCubit(
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
      ));
  sl.registerFactory<SettingsRepository>(() => SettingsRepositoriesImpl(sl()));
  sl.registerFactory<SettingsClient>(() => SettingsClient(sl()));
  sl.registerFactory(() => DeleteUserUsecase(sl()));
  sl.registerFactory(() => GetNotificationPreferencesUsecase(sl()));
  sl.registerFactory(() => UpdateNotificationPreferencesUsecase(sl()));
/*
  <<< Setting
*/

  sl.registerFactory(() => ProfileCubit(sl(), sl(), sl(), sl(), sl(), sl(),
      sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<ProfileRepository>(() => ProfileRepositoryImpl(sl()));
  sl.registerFactory<ProfileClient>(() => ProfileClient(sl()));
  sl.registerFactory(() => GetGearTypesUsecase(sl()));
  sl.registerFactory(() => GetSportsUsecase(sl()));
  sl.registerFactory(() => GetGearAllUsecase(sl()));
  sl.registerFactory(() => CreateGearUsecase(sl()));
  sl.registerFactory(() => DeleteGearUsecase(sl()));
  sl.registerFactory(() => CreateScheduleUsecase(sl()));
  sl.registerFactory(() => GetScheduleUsecase(sl()));
  sl.registerFactory(() => DeleteScheduleUsecase(sl()));
  sl.registerFactory(() => UpdateScheduleUsecase(sl()));
  sl.registerFactory(() => UpdateGearUsecase(sl()));
  sl.registerFactory(() => GetUserDataProfileUsecase(sl()));
  sl.registerFactory(() => ProfileGetTargetsUsecase(sl()));
  sl.registerFactory(() => UpdateUserProfileUsecase(sl()));

  //challenges
  sl.registerFactory(() => ChallengesClient(sl()));
  sl.registerFactory<ChallengesRepository>(
      () => ChallengesRepositoryImpl(sl()));
  sl.registerFactory(() => GetChallengesUsecase(sl()));
  sl.registerFactory(() => GetUserParticipatedChallengesUsecase(sl()));
  sl.registerFactory(() => ParticipatedChallengesUsecase(sl()));
  sl.registerFactory(() => GetParticipatedChallengesUsecase(sl()));
  sl.registerFactory(() => LeaveParticipatedChallengesUsecase(sl()));
  sl.registerFactory(() => ChallengesCubit(sl(), sl(), sl(), sl(), sl(), sl()));

  //EVENTS
  sl.registerFactory(() => EventClient(sl()));
  sl.registerFactory<EventsRepository>(() => EventsRespositoryImpl(sl()));
  sl.registerFactory(() => GetEventsUsecase(sl()));
  sl.registerFactory(() => BookedEventTicketUsecase(sl()));
  sl.registerFactory(() => EventsPageCubit(sl(), sl(), sl()));
}
