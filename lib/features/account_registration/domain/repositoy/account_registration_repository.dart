import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:athlorun/core/global_store/data/models/user_data_progress_model.dart';
import 'package:athlorun/core/global_store/data/models/user_data_response_model.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/account_registration/data/models/send_otp_request_model.dart';
import 'package:athlorun/features/account_registration/data/models/send_otp_response_model.dart';
import 'package:athlorun/features/account_registration/data/models/targets_response_model.dart';
import 'package:athlorun/features/account_registration/data/models/upload_selfie_response_model.dart';
import 'package:athlorun/features/account_registration/data/models/verify_otp_request_model.dart';
import 'package:athlorun/features/account_registration/data/models/verify_otp_response_model.dart';

abstract class AccountRegistrationRepository {
  Future<Either<Failure, SendOtpResponseModel>> sendOtp(
    SendOtpRequestModel body,
  );

  Future<Either<Failure, VerifyOtpResponseModel>> verifyOtp(
    VerifyOtpRequestModel body,
  );

  Future<Either<Failure, SelfieResponseModel>> uploadSelfie(
    String id,
    File file,
  );

  Future<Either<Failure, UserData>> patchUser(
    String id,
    String token,
    UserDataProgressModel body,
  );

  Future<Either<Failure, TargetsResponseModel>> getTargets();
}
