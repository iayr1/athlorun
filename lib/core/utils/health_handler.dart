import 'dart:io';

import 'package:health/health.dart';

class HealthHandler {
  Future<bool> getHealthConnectSdkStatus() async {
    if (Platform.isAndroid) {
      final HealthConnectSdkStatus? status =
          await Health().getHealthConnectSdkStatus();
      return status == HealthConnectSdkStatus.sdkAvailable ? true : false;
    } else {
      return true;
    }
  }

  /// Install Google Health Connect on this phone.
  Future<void> installHealthConnect() async {
    await Health().installHealthConnect();
  }

  Future<bool> checkHealthPermissions(List<HealthDataType> types,
      {List<HealthDataAccess>? permissions}) async {
    return await Health().hasPermissions(types, permissions: permissions) ??
        false;
  }

  Future<bool> requestAuthorization(List<HealthDataType> types,
      {List<HealthDataAccess>? permissions}) async {
    return await Health().requestAuthorization(types, permissions: permissions);
  }

  Future<int> getTotalStepsInInterval(
    DateTime startTime,
    DateTime endTime, {
    bool includeManualEntry = true,
  }) async {
    int? steps = 0;
    steps = await Health().getTotalStepsInInterval(
      startTime,
      endTime,
      includeManualEntry: includeManualEntry,
    );
    if (steps == null) {
      throw Exception("No steps data found");
    } else {
      return steps;
    }
  }
}
