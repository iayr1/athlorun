import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:athlorun/core/global_store/data/models/user_data_progress_model.dart';
import 'package:athlorun/core/global_store/data/models/user_data_response_model.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/account_registration/data/datasources/remote/account_registration_client.dart';
import 'package:athlorun/features/account_registration/data/models/send_otp_request_model.dart';
import 'package:athlorun/features/account_registration/data/models/send_otp_response_model.dart';
import 'package:athlorun/features/account_registration/data/models/targets_response_model.dart';
import 'package:athlorun/features/account_registration/data/models/upload_selfie_response_model.dart';
import 'package:athlorun/features/account_registration/data/models/verify_otp_request_model.dart';
import 'package:athlorun/features/account_registration/data/models/verify_otp_response_model.dart';
import 'package:athlorun/features/account_registration/domain/repositoy/account_registration_repository.dart';

import '../../../../core/exceptions/custom_exceptions.dart';
import '../../../../core/utils/utils.dart';

class AccountRegistrationRepositoryImpl
    implements AccountRegistrationRepository {
  final AccountRegistrationClient _client;
  const AccountRegistrationRepositoryImpl(this._client);
  @override
  Future<Either<Failure, SendOtpResponseModel>> sendOtp(
      SendOtpRequestModel body) async {
    try {
      final response = await _client.sendOtp(body);
      return right(response);
    } on SocketException catch (_) {
      return left(ConnectionFailure());
    } on TimeoutException catch (_) {
      return left(TimeoutFailure());
    } on ServerException catch (_) {
      return left(ServerFailure());
    } on Exception catch (e) {
      Utils.debugLog(e.toString());
      return left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, VerifyOtpResponseModel>> verifyOtp(
      VerifyOtpRequestModel body) async {
    try {
      final response = await _client.verifyOtp(body);
      return right(response);
    } on SocketException catch (_) {
      return left(ConnectionFailure());
    } on TimeoutException catch (_) {
      return left(TimeoutFailure());
    } on ServerException catch (_) {
      return left(ServerFailure());
    } on Exception catch (e) {
      Utils.debugLog(e.toString());
      return left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SelfieResponseModel>> uploadSelfie(
      String id, File file) async {
    try {
      final response = await _client.uploadSelfie(id, file);
      return right(response);
    } on SocketException catch (_) {
      return left(ConnectionFailure());
    } on TimeoutException catch (_) {
      return left(TimeoutFailure());
    } on ServerException catch (_) {
      return left(ServerFailure());
    } on Exception catch (e) {
      Utils.debugLog(e.toString());
      return left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserData>> patchUser(
      String id, String token, UserDataProgressModel body) async {
    try {
      final response = await _client.patchUser(id, body);
      return right(response.data!);
    } on SocketException catch (_) {
      return left(ConnectionFailure());
    } on TimeoutException catch (_) {
      return left(TimeoutFailure());
    } on ServerException catch (_) {
      return left(ServerFailure());
    } on Exception catch (e) {
      Utils.debugLog(e.toString());
      return left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TargetsResponseModel>> getTargets() async {
    try {
      final response = await _client.getTargets();
      return right(response);
    } on SocketException catch (_) {
      return left(ConnectionFailure());
    } on TimeoutException catch (_) {
      return left(TimeoutFailure());
    } on ServerException catch (_) {
      return left(ServerFailure());
    } on Exception catch (e) {
      Utils.debugLog(e.toString());
      return left(GeneralFailure(message: e.toString()));
    }
  }
}
