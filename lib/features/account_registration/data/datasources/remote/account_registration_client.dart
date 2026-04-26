import 'dart:io';
import 'dart:math';

import 'package:athlorun/core/exceptions/custom_exceptions.dart';

import 'package:athlorun/core/firebase/data/datasources/remote/firestore_backend.dart';
import 'package:athlorun/core/global_store/data/models/user_data_progress_model.dart';
import 'package:athlorun/core/global_store/data/models/user_data_response_model.dart';
import 'package:athlorun/features/account_registration/data/models/send_otp_request_model.dart';
import 'package:athlorun/features/account_registration/data/models/send_otp_response_model.dart';
import 'package:athlorun/features/account_registration/data/models/targets_response_model.dart';
import 'package:athlorun/features/account_registration/data/models/upload_selfie_response_model.dart';
import 'package:athlorun/features/account_registration/data/models/verify_otp_request_model.dart';
import 'package:athlorun/features/account_registration/data/models/verify_otp_response_model.dart';

class AccountRegistrationClient {
  AccountRegistrationClient(this._backend);

  final FirestoreBackend _backend;

  Future<SendOtpResponseModel> sendOtp(SendOtpRequestModel body) async {
    final phoneNumber = body.phoneNumber.trim();
    if (phoneNumber.isEmpty) {
      throw ServerException();
    }

    final otp = (1000 + Random().nextInt(9000)).toString();
    final now = DateTime.now().toUtc();

    await _backend.upsertDocument(
      collection: 'otp_requests',
      docId: phoneNumber,
      data: {
        'phoneNumber': phoneNumber,
        'otp': otp,
        'createdAt': now.toIso8601String(),
        'expiresAt': now.add(const Duration(minutes: 2)).toIso8601String(),
      },
    );

    return SendOtpResponseModel.fromJson({
      'statusCode': 200,
      'message': 'OTP sent successfully',
      'data': {
        'flash': true,
        'message': 'For testing use OTP: $otp',
      },
    });
  }

  Future<VerifyOtpResponseModel> verifyOtp(VerifyOtpRequestModel body) async {
    final phoneNumber = body.phoneNumber?.trim() ?? '';
    final enteredOtp = body.otp?.trim() ?? '';

    if (phoneNumber.isEmpty || enteredOtp.isEmpty) {
      throw ServerException();
    }

    final otpDoc = await _backend.getDocument(
      collection: 'otp_requests',
      docId: phoneNumber,
      fallback: const {},
    );

    final expectedOtp = otpDoc['otp']?.toString() ?? '';
    final expiresAtRaw = otpDoc['expiresAt']?.toString();
    final expiresAt = expiresAtRaw == null ? null : DateTime.tryParse(expiresAtRaw)?.toUtc();

    if (expectedOtp.isEmpty || expectedOtp != enteredOtp) {
      throw ServerException();
    }

    if (expiresAt != null && DateTime.now().toUtc().isAfter(expiresAt)) {
      throw ServerException();
    }

    final now = DateTime.now().toUtc();
    final userId = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');

    return VerifyOtpResponseModel.fromJson({
      'status': 200,
      'statusText': 'SUCCESS',
      'message': 'OTP verified',
      'data': {
        'id': userId,
        'phoneNumber': phoneNumber,
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
        'accessToken': 'access_$userId',
        'refreshToken': 'refresh_$userId',
      },
    });
  }

  Future<SelfieResponseModel> uploadSelfie(String id, File file) async {
    await _backend.upsertDocument(collection: 'users', docId: id, data: {'selfiePath': file.path});
    return SelfieResponseModel.fromJson({'statusCode': 200, 'message': 'Selfie uploaded', 'data': {'selfie': file.path}});
  }

  Future<UserDataResponseModel> patchUser(String id, UserDataProgressModel body) async {
    await _backend.upsertDocument(collection: 'users', docId: id, data: body.toJson());
    return UserDataResponseModel.fromJson({'statusCode': 200, 'message': 'Updated', 'data': body.toJson()});
  }

  Future<TargetsResponseModel> getTargets() async {
    final targets = await _backend.getCollection(collection: 'targets');
    return TargetsResponseModel.fromJson({'statusCode': 200, 'message': 'Fetched', 'data': targets});
  }
}
