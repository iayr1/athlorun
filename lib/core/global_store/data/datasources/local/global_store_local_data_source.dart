import 'package:health/health.dart';
import 'package:athlorun/core/global_store/data/models/user_auth_data_model.dart';
import 'package:athlorun/core/global_store/data/models/user_data_progress_model.dart';

abstract class GlobalStoreLocalDataSource {
  Future<UserAuthDataModel> getUserAuthData();
  Future<void> setUserAuthData(UserAuthDataModel authData);
  Future<void> logout();

  Future<void> getOnboardingStatus();
  Future<void> setOnboardingStatus(bool status);

  Future<UserDataProgressModel> getUserDataProgressModel();
  Future<void> setUserDataProgressModel(UserDataProgressModel progressData);

  Future<bool> getHealthConnectSdkStatus();
  Future<void> installHealthConnect();
  Future<bool> checkHealthPermissions(
    List<HealthDataType> types, {
    List<HealthDataAccess>? permissions,
  });
  Future<bool> requestAuthorization(
    List<HealthDataType> types, {
    List<HealthDataAccess>? permissions,
  });
  Future<int> getTotalStepsInInterval(
    DateTime startTime,
    DateTime endTime, {
    bool includeManualEntry = true,
  });
}
