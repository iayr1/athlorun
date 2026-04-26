import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:athlorun/core/global_store/data/models/user_auth_data_model.dart';
import 'package:athlorun/core/global_store/domain/usecases/logout_usecase.dart';
import 'package:athlorun/core/global_store/domain/usecases/get_user_auth_data_usecase.dart';
import 'package:athlorun/features/settings/data/model/delete_user_response_model.dart';
import 'package:athlorun/features/settings/data/model/get_notification_preference_response_model.dart';
import 'package:athlorun/features/settings/data/model/update_notification_preferences_request_model.dart';
import 'package:athlorun/features/settings/domain/usecases/delete_user_usecase.dart';
import 'package:athlorun/features/settings/domain/usecases/get_notification_preferences_usecase.dart';
import 'package:athlorun/features/settings/domain/usecases/update_notification_preferences_usecase.dart';

part 'settings_state.dart';
part 'settings_cubit.freezed.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final DeleteUserUsecase _deleteUserUsecase;
  final GetUserAuthDataUsecase _getAuthDataUsecase;
  final LogoutUsecase _logoutUsecase;
  final GetNotificationPreferencesUsecase _getNotificationPreferencesUsecase;
  final UpdateNotificationPreferencesUsecase
      _updateNotificationPreferencesUsecase;

  SettingsCubit(
    this._deleteUserUsecase,
    this._getAuthDataUsecase,
    this._logoutUsecase,
    this._getNotificationPreferencesUsecase,
    this._updateNotificationPreferencesUsecase,
  ) : super(const SettingsState.comitial());

  Future<void> deleteUser(UserAuthDataModel authData) async {
    emit(const SettingsState.deletingUser());
    final response = await _deleteUserUsecase(authData.id);
    response.fold((l) {
      emit(SettingsState.deleteUserError(l.message));
    }, (r) {
      emit(SettingsState.deletedUser(r));
    });
  }

  Future<void> getAuthData() async {
    emit(const SettingsState.loadingAuthData());
    final response = await _getAuthDataUsecase();
    response.fold((l) {
      emit(SettingsState.loadAuthDataError(l.message));
    }, (r) {
      emit(SettingsState.loadedAuthData(r));
    });
  }

  Future<void> logout() async {
    emit(const SettingsState.loggingOut());
    final response = await _logoutUsecase();
    response.fold((l) {
      emit(SettingsState.logOutError(l.message));
    }, (r) {
      emit(const SettingsState.loggedOut());
    });
  }

  Future<void> getNotificationPreferences(UserAuthDataModel authData) async {
    emit(const SettingsState.loadingNotificationPreferences());
    final result = await _getNotificationPreferencesUsecase(authData.id);
    result.fold(
      (l) {
        emit(SettingsState.loadNotificationPreferencesError(l.message));
      },
      (r) {
        emit(SettingsState.loadedNotificationPreferences(r));
      },
    );
  }

  Future<void> updateNotificationPreferences(
    String id,
    List<Datum> items,
  ) async {
    emit(const SettingsState.updatingNotificationPreferences());
    final result = await _updateNotificationPreferencesUsecase(
      id,
      UpdateNotificationPreferencesRequestModel(
        preferences: items
            .map(
              (e) => Preference(
                type: e.type,
                isEnabled: e.isEnabled,
              ),
            )
            .toList(),
      ),
    );
    result.fold(
      (l) {
        emit(SettingsState.updateNotificationPreferencesError(l.message));
      },
      (r) {
        emit(SettingsState.updatedNotificationPreferences(items));
      },
    );
  }
}
