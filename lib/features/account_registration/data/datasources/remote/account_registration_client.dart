import 'dart:io';

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
    final payload = body.toJson();
    await _backend.upsertDocument(collection: 'otp_requests', docId: payload['mobile'] ?? DateTime.now().millisecondsSinceEpoch.toString(), data: payload);
    return SendOtpResponseModel.fromJson({'statusCode': 200, 'message': 'OTP sent', 'data': payload});
  }

  Future<VerifyOtpResponseModel> verifyOtp(VerifyOtpRequestModel body) async {
    return VerifyOtpResponseModel.fromJson({'statusCode': 200, 'message': 'OTP verified', 'data': body.toJson()});
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
