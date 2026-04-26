import 'dart:io';

import 'package:dio/dio.dart';
import 'package:athlorun/core/constants/api_strings.dart';
import 'package:athlorun/core/global_store/data/models/user_data_progress_model.dart';
import 'package:athlorun/core/global_store/data/models/user_data_response_model.dart';
import 'package:athlorun/features/account_registration/data/models/send_otp_request_model.dart';
import 'package:athlorun/features/account_registration/data/models/send_otp_response_model.dart';
import 'package:athlorun/features/account_registration/data/models/targets_response_model.dart';
import 'package:athlorun/features/account_registration/data/models/upload_selfie_response_model.dart';
import 'package:athlorun/features/account_registration/data/models/verify_otp_request_model.dart';
import 'package:athlorun/features/account_registration/data/models/verify_otp_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'account_registration_client.g.dart';

@RestApi()
abstract class AccountRegistrationClient {
  factory AccountRegistrationClient(Dio dio) = _AccountRegistrationClient;

  @POST(ApiStrings.sentOtp)
  Future<SendOtpResponseModel> sendOtp(
    @Body() SendOtpRequestModel body,
  );

  @POST(ApiStrings.verifyOtp)
  Future<VerifyOtpResponseModel> verifyOtp(
    @Body() VerifyOtpRequestModel body,
  );

  @PATCH(ApiStrings.uploadSelfie)
  @MultiPart()
  Future<SelfieResponseModel> uploadSelfie(
    @Path("id") String id,
    @Part(name: "file") File file,
  );

  @PATCH(ApiStrings.users)
  Future<UserDataResponseModel> patchUser(
    @Path("id") String id,
    @Body() UserDataProgressModel body,
  );

  @GET(ApiStrings.targets)
  Future<TargetsResponseModel> getTargets();
}
