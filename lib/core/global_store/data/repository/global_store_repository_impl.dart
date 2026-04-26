import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:health/health.dart';
import 'package:athlorun/core/exceptions/custom_exceptions.dart';
import 'package:athlorun/core/global_store/data/datasources/local/global_store_local_data_source.dart';
import 'package:athlorun/core/global_store/data/datasources/remote/global_store_client.dart';
import 'package:athlorun/core/global_store/data/models/user_auth_data_model.dart';
import 'package:athlorun/core/global_store/data/models/user_data_progress_model.dart';
import 'package:athlorun/core/global_store/data/models/user_data_response_model.dart';
import 'package:athlorun/core/global_store/domain/repository/global_store_repository.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/core/status/success.dart';
import 'package:athlorun/core/utils/utils.dart';

class GlobalStoreRepositoryImpl implements GlobalStoreRepository {
  final GlobalStoreLocalDataSource _localClient;
  final GlobalStoreClient _remoteClient;
  GlobalStoreRepositoryImpl(
    this._localClient,
    this._remoteClient,
  );

  @override
  Future<Either<Failure, UserAuthDataModel>> getUserAuthData() async {
    try {
      final result = await _localClient.getUserAuthData();
      return right(result);
    } on CacheException catch (_) {
      return left(CacheFailure());
    } catch (e) {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, void>> setUserAuthData(
      UserAuthDataModel authData) async {
    try {
      await _localClient.setUserAuthData(authData);
      return right(null);
    } on CacheException catch (_) {
      return left(CacheFailure());
    } catch (e) {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, UserData>> getUserData(
      UserAuthDataModel authData) async {
    try {
      final result = await _remoteClient.getUserData(
        authData.id,
      );
      return right(result.data!);
    } on SocketException catch (_) {
      return left(ConnectionFailure());
    } on TimeoutException catch (_) {
      return left(TimeoutFailure());
    } on ServerException catch (_) {
      return left(ServerFailure());
    } catch (e) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> getOnboardingStatus() async {
    try {
      await _localClient.getOnboardingStatus();
      return right(null);
    } on CacheException catch (_) {
      return left(CacheFailure());
    } catch (e) {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, void>> setOnboardingStatus(bool status) async {
    try {
      await _localClient.setOnboardingStatus(status);
      return right(null);
    } on CacheException catch (_) {
      return left(CacheFailure());
    } catch (e) {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, UserDataProgressModel>>
      getUserDataProgressModel() async {
    try {
      final UserDataProgressModel userDataProgressModel =
          await _localClient.getUserDataProgressModel();
      return right(userDataProgressModel);
    } on CacheException catch (_) {
      return left(CacheFailure());
    } catch (e) {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, void>> setUserDataProgressModel(
      UserDataProgressModel progressData) async {
    try {
      await _localClient.setUserDataProgressModel(progressData);
      return right(null);
    } on CacheException catch (_) {
      return left(CacheFailure());
    } catch (e) {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> checkHealthPermissions(
      List<HealthDataType> types,
      {List<HealthDataAccess>? permissions}) async {
    try {
      final result = await _localClient.checkHealthPermissions(types,
          permissions: permissions);
      return right(result);
    } catch (_) {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> getHealthConnectSdkStatus() async {
    try {
      final result = await _localClient.getHealthConnectSdkStatus();
      return right(result);
    } catch (_) {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, int>> getTotalStepsInInterval(
      DateTime startTime, DateTime endTime,
      {bool includeManualEntry = true}) async {
    try {
      final result =
          await _localClient.getTotalStepsInInterval(startTime, endTime);
      return right(result);
    } catch (_) {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, void>> installHealthConnect() async {
    try {
      final result = await _localClient.installHealthConnect();
      return right(result);
    } catch (_) {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> requestHealthAuthorization(
      List<HealthDataType> types,
      {List<HealthDataAccess>? permissions}) async {
    try {
      final result = await _localClient.requestAuthorization(types,
          permissions: permissions);
      return right(result);
    } catch (_) {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final result = await _localClient.logout();
      return right(result);
    } catch (_) {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> payThroughPaymentGateWay(
    String orderId,
    double orderAmount,
    String paymentSessionid,
    CFPaymentGatewayService cashfree,
  ) async {
    try {
      /** 
           * * change the Environement to PRODUCTION when using live 
       */
      var session = CFSessionBuilder()
          .setEnvironment(CFEnvironment.SANDBOX)
          .setOrderId(orderId)
          .setPaymentSessionId(paymentSessionid)
          .build();

      var theme = CFThemeBuilder()
          .setNavigationBarBackgroundColorColor('#40F29A')
          .setBackgroundColor('#40F29A')
          .setNavigationBarBackgroundColorColor('#40F29A')
          .setPrimaryFont('SF Pro Display')
          .setSecondaryFont('SF Pro Text')
          .setButtonBackgroundColor('#0A16FF')
          .setPrimaryTextColor('#000000')
          .setSecondaryTextColor('#000000')
          .setNavigationBarTextColor('#000000')
          .build();

      var cfDropCheckoutPayment = CFWebCheckoutPaymentBuilder()
          .setSession(session)
          .setTheme(theme)
          .build();

      cashfree.doPayment(cfDropCheckoutPayment);

      return right(Success(message: orderId));
    } on SocketException catch (_) {
      return left(ConnectionFailure());
    } on TimeoutException catch (_) {
      return left(TimeoutFailure());
    } on ServerException catch (_) {
      return left(ServerFailure());
    } catch (e) {
      Utils.debugLog(e.toString());
      return left(ServerFailure(message: e.toString()));
    }
  }
}
