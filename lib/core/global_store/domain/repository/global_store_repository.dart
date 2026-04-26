import 'package:dartz/dartz.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:health/health.dart';
import 'package:athlorun/core/global_store/data/models/user_auth_data_model.dart';
import 'package:athlorun/core/global_store/data/models/user_data_progress_model.dart';
import 'package:athlorun/core/global_store/data/models/user_data_response_model.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/core/status/success.dart';

abstract class GlobalStoreRepository {
  Future<Either<Failure, void>> setUserAuthData(UserAuthDataModel authData);
  Future<Either<Failure, UserAuthDataModel>> getUserAuthData();
  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserData>> getUserData(UserAuthDataModel authData);

  Future<Either<Failure, void>> getOnboardingStatus();
  Future<Either<Failure, void>> setOnboardingStatus(bool status);

  Future<Either<Failure, UserDataProgressModel>> getUserDataProgressModel();
  Future<Either<Failure, void>> setUserDataProgressModel(
      UserDataProgressModel progressData);

  Future<Either<Failure, bool>> getHealthConnectSdkStatus();
  Future<Either<Failure, void>> installHealthConnect();
  Future<Either<Failure, bool>> checkHealthPermissions(
    List<HealthDataType> types, {
    List<HealthDataAccess>? permissions,
  });
  Future<Either<Failure, bool>> requestHealthAuthorization(
    List<HealthDataType> types, {
    List<HealthDataAccess>? permissions,
  });
  Future<Either<Failure, int>> getTotalStepsInInterval(
    DateTime startTime,
    DateTime endTime, {
    bool includeManualEntry = true,
  });

  Future<Either<Failure, Success>> payThroughPaymentGateWay(
    String orderId,
    double orderAmount,
    String paymentSessionid,
    CFPaymentGatewayService cashfree,
  );
}
