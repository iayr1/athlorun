import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:health/health.dart';
import 'package:athlorun/core/firebase/domain/usecases/enable_notification_usecase.dart';
import 'package:athlorun/core/firebase/domain/usecases/get_fcm_token_usecase.dart';
import 'package:athlorun/core/firebase/domain/usecases/request_notification_permission_usecase.dart';
import 'package:athlorun/core/global_store/data/models/user_auth_data_model.dart';
import 'package:athlorun/core/global_store/data/models/user_data_response_model.dart';
import 'package:athlorun/core/global_store/domain/usecases/check_health_permission_usecase.dart';
import 'package:athlorun/core/global_store/domain/usecases/get_health_connect_sdk_status_usecase.dart';
import 'package:athlorun/core/global_store/domain/usecases/get_total_steps_in_interval_usecase.dart';
import 'package:athlorun/core/global_store/domain/usecases/get_user_auth_data_usecase.dart';
import 'package:athlorun/core/global_store/domain/usecases/get_user_data_usecase.dart';
import 'package:athlorun/core/global_store/domain/usecases/install_health_connect_usecase.dart';
import 'package:athlorun/core/global_store/domain/usecases/request_health_authorization_usecase.dart';
import 'package:athlorun/core/firebase/data/models/enable_notification_request_model.dart';
import 'package:athlorun/core/firebase/data/models/enable_notification_response_model.dart';
import 'package:athlorun/features/home/data/models/request/step_request_model.dart';
import 'package:athlorun/features/home/data/models/response/step_response_model.dart';
import 'package:athlorun/features/home/data/models/response/wallet_response_model.dart';
import 'package:athlorun/features/home/domain/usecases/get_notifications_usecase.dart';
import 'package:athlorun/features/home/domain/usecases/get_wallet_usecase.dart';
import 'package:athlorun/features/home/domain/usecases/mark_notification_as_seen_usecase.dart';
import 'package:athlorun/features/home/domain/usecases/update_step_data_usecase.dart';

part 'home_page_state.dart';
part 'home_page_cubit.freezed.dart';

class HomePageCubit extends Cubit<HomePageState> {
  final GetHealthConnectSdkStatusUsecase _getHealthConnectSdkStatusUsecase;
  final InstallHealthConnectUsecase _installHealthConnectUsecase;
  final CheckHealthPermissionUsecase _checkHealthPermissionUsecase;
  final GetTotalStepsInIntervalUsecase _getTotalStepsInIntervalUsecase;
  final RequestHealthAuthorizationUsecase _requestHealthAuthorizationUsecase;
  final GetNotificationsUsecase _getNotificationsUsecase;
  final MarkNotificationAsSeenUsecase _markNotificationAsSeenUsecase;
  final RequestNotificationPermissionUsecase
      _requestNotificationPermissionUsecase;
  final EnableNotificationUsecase _enableNotification;
  final GetFcmTokenUsecase _getFcmTokenUsecase;
  final GetUserAuthDataUsecase _getUserAuthDataUsecase;
  final UpdateStepDataUsecase _updateStepDataUsecase;
  final GetWalletUsecase _getWalletUsecase;
  final GetUserDataUsecase _getUserDataUsecase;

  HomePageCubit(
    this._getHealthConnectSdkStatusUsecase,
    this._installHealthConnectUsecase,
    this._checkHealthPermissionUsecase,
    this._getTotalStepsInIntervalUsecase,
    this._requestHealthAuthorizationUsecase,
    this._getNotificationsUsecase,
    this._markNotificationAsSeenUsecase,
    this._enableNotification,
    this._getFcmTokenUsecase,
    this._requestNotificationPermissionUsecase,
    this._getUserAuthDataUsecase,
    this._updateStepDataUsecase,
    this._getWalletUsecase,
    this._getUserDataUsecase,
  ) : super(const HomePageState.comitial());

  Future<void> getAuthData() async {
    emit(const HomePageState.gettingAuthData());
    final response = await _getUserAuthDataUsecase();
    response.fold((failure) {
      emit(HomePageState.getAuthDataError(failure.message));
    }, (authData) {
      emit(HomePageState.gotAuthData(authData));
    });
  }

  Future<void> getHealthSdkStatus() async {
    emit(const HomePageState.checkingHealthSdkStatus());
    final result = await _getHealthConnectSdkStatusUsecase();
    result.fold(
      (l) {
        emit(HomePageState.checkHealthSdkStatusError(l.message));
      },
      (r) {
        emit(HomePageState.checkedHealthSdkStatus(r));
      },
    );
  }

  Future<void> checkHealthPermissions(List<HealthDataType> types,
      {List<HealthDataAccess>? permissions}) async {
    emit(const HomePageState.checkingHealthPermissions());
    final result =
        await _checkHealthPermissionUsecase(types, permissions: permissions);
    result.fold((l) {
      emit(HomePageState.checkHealthPermissionsError(l.message));
    }, (r) {
      emit(HomePageState.checkedHealthPermissions(r));
    });
  }

  Future<void> requestHealthPermissions(List<HealthDataType> types,
      {List<HealthDataAccess>? permissions}) async {
    emit(const HomePageState.requestingHealthPermissions());
    final result = await _requestHealthAuthorizationUsecase(types,
        permissions: permissions);
    result.fold((l) {
      emit(HomePageState.requestHealthPermissionsError(l.message));
    }, (r) {
      emit(HomePageState.requestedHealthPermissions(r));
    });
  }

  Future<void> getTotalStepsInInterval(
    DateTime startTime,
    DateTime endTime, {
    bool includeManualEntry = true,
  }) async {
    emit(const HomePageState.gettingTotalStepsInInterval());
    final result = await _getTotalStepsInIntervalUsecase(
      startTime,
      endTime,
      includeManualEntry: includeManualEntry,
    );
    result.fold((l) {
      emit(HomePageState.getTotalStepsInIntervalError(l.message));
    }, (r) {
      emit(HomePageState.gotTotalStepsInInterval(r));
    });
  }

  Future<void> installHealthConnect() async {
    await _installHealthConnectUsecase();
  }

  Future<void> setVisibility(bool visibility) async {
    emit(const HomePageState.settingVisibility());
    emit(HomePageState.setVisibility(visibility));
  }

  Future<void> getNotifications(String type, String status) async {
    emit(const HomePageState.loadingNotifications());
    final result = await _getNotificationsUsecase(type, status);
    result.fold(
      (l) {
        emit(HomePageState.loadNotificationsError(l.message));
      },
      (r) {
        emit(HomePageState.loadedNotifications(r));
      },
    );
  }

  Future<void> markNotificationsAsSeen(String id) async {
    emit(const HomePageState.markingNotificationAsSeen());
    final result = await _markNotificationAsSeenUsecase(id);
    result.fold(
      (l) {
        emit(HomePageState.markNotificationAsSeenError(l.message));
      },
      (r) {
        emit(HomePageState.markedNotificationAsSeen(r));
      },
    );
  }

  Future<void> requesNotificationPermissiion() async {
    emit(const HomePageState.requestingNotificationPermissiion());
    final result = await _requestNotificationPermissionUsecase();
    result.fold(
      (l) {
        emit(HomePageState.requestNotificationPermissiionError(l.message));
      },
      (r) {
        emit(HomePageState.requestedNotificationPermissiion(r));
      },
    );
  }

  Future<void> getFcmToken() async {
    emit(const HomePageState.fetchingFcmToken());
    final result = await _getFcmTokenUsecase();
    result.fold(
      (l) {
        emit(HomePageState.fetchFcmTokenError(l.message));
      },
      (r) {
        emit(HomePageState.fetchedFcmToken(r));
      },
    );
  }

  Future<void> enableNotification(
    String deviceType,
    String id,
    String notificationToken,
  ) async {
    emit(const HomePageState.enablingNotification());
    final result = await _enableNotification(
      id,
      EnableNotificationRequestModel(
        deviceType: deviceType,
        notificationToken: notificationToken,
      ),
    );
    result.fold(
      (l) {
        emit(HomePageState.enableNotificationError(l.message));
      },
      (r) {
        emit(HomePageState.enabledNotification(r));
      },
    );
  }

  //update steps data
  Future<void> updateStepData(StepRequestModel body) async {
    emit(const HomePageState.updatingStepData());
    final authData = await _getUserAuthDataUsecase();
    authData.fold((l) {
      emit(HomePageState.updateStepDataError(l.message));
    }, (authData) async {
      final response = await _updateStepDataUsecase.call(authData.id, body);
      response.fold((l) {
        emit(HomePageState.updateStepDataError(l.message));
      }, (r) {
        emit(HomePageState.updatedStepData(r));
      });
    });
  }

  Future<void> getUserWalletData() async {
    emit(const HomePageState.gettingAuthData());
    final authData = await _getUserAuthDataUsecase();

    authData.fold(
      (l) {
        emit(
          HomePageState.getAuthDataError(l.errorMessage),
        );
      },
      (authData) async {
        emit(
          const HomePageState.loadingUserProfile(),
        );

        final response = await _getUserDataUsecase.call(authData);
        response.fold(
          (l) {
            emit(
              HomePageState.loadUserProfileError(l.errorMessage),
            );
          },
          (userData) async {
            emit(
              const HomePageState.loadingWallet(),
            );

            final response = await _getWalletUsecase.call(
                userData.id!, userData.wallet!.id!);
            response.fold(
              (l) {
                emit(
                  HomePageState.loadWalletError(l.message),
                );
              },
              (r) {
                emit(
                  HomePageState.loadedWallet(r),
                );
              },
            );
          },
        );
      },
    );
  }
}
