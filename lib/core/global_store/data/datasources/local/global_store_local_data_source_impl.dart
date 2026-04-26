import 'dart:convert';

import 'package:health/health.dart';
import 'package:athlorun/core/constants/preference_string.dart';
import 'package:athlorun/core/exceptions/custom_exceptions.dart';
import 'package:athlorun/core/global_store/data/datasources/local/global_store_local_data_source.dart';
import 'package:athlorun/core/global_store/data/models/user_auth_data_model.dart';
import 'package:athlorun/core/global_store/data/models/user_data_progress_model.dart';
import 'package:athlorun/core/utils/health_handler.dart';
import 'package:athlorun/core/utils/secure_local_storage.dart';

class GlobalStoreLocalDataSourceImpl implements GlobalStoreLocalDataSource {
  final SecureLocalStorage _secureLocalStorage;
  final HealthHandler _healthHandler;
  const GlobalStoreLocalDataSourceImpl(
    this._secureLocalStorage,
    this._healthHandler,
  );

  @override
  Future<UserAuthDataModel> getUserAuthData() async {
    final result = await _secureLocalStorage.get(PreferenceString.userAuthData);
    if (result == null) throw CacheException();
    final jsonDecoded = jsonDecode(result);
    return UserAuthDataModel.fromJson(jsonDecoded);
  }

  @override
  Future<void> setUserAuthData(UserAuthDataModel authData) async {
    final result = await _secureLocalStorage.set(
        PreferenceString.userAuthData, jsonEncode(authData.toJson()));
    if (!result) throw CacheException();
    return;
  }

  @override
  Future<void> getOnboardingStatus() async {
    final result =
        await _secureLocalStorage.get(PreferenceString.onboardingStatus);
    if (result == null) throw CacheException();
    return;
  }

  @override
  Future<void> setOnboardingStatus(bool status) async {
    final result = await _secureLocalStorage.set(
        PreferenceString.onboardingStatus, jsonEncode({"status": status}));
    if (!result) throw CacheException();
    return;
  }

  @override
  Future<UserDataProgressModel> getUserDataProgressModel() async {
    final result =
        await _secureLocalStorage.get(PreferenceString.userDataProgress);
    if (result == null) throw CacheException();
    final jsonDecoded = jsonDecode(result);
    return UserDataProgressModel.fromJson(jsonDecoded);
  }

  @override
  Future<void> setUserDataProgressModel(
      UserDataProgressModel progressData) async {
    final result = await _secureLocalStorage.set(
        PreferenceString.userDataProgress, jsonEncode(progressData.toJson()));
    if (!result) throw CacheException();
    return;
  }

  @override
  Future<bool> checkHealthPermissions(List<HealthDataType> types,
      {List<HealthDataAccess>? permissions}) async {
    return await _healthHandler.checkHealthPermissions(types,
        permissions: permissions);
  }

  @override
  Future<bool> getHealthConnectSdkStatus() async {
    return await _healthHandler.getHealthConnectSdkStatus();
  }

  @override
  Future<int> getTotalStepsInInterval(
    DateTime startTime,
    DateTime endTime, {
    bool includeManualEntry = true,
  }) async {
    return await _healthHandler.getTotalStepsInInterval(
      startTime,
      endTime,
      includeManualEntry: includeManualEntry,
    );
  }

  @override
  Future<void> installHealthConnect() async {
    return await _healthHandler.installHealthConnect();
  }

  @override
  Future<bool> requestAuthorization(
    List<HealthDataType> types, {
    List<HealthDataAccess>? permissions,
  }) async {
    return await _healthHandler.requestAuthorization(
      types,
      permissions: permissions,
    );
  }

  @override
  Future<void> logout() async {
    await _secureLocalStorage.deleteAll();
  }
}
