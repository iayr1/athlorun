import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/account_registration/data/models/verify_otp_request_model.dart';
import 'package:athlorun/features/account_registration/data/models/verify_otp_response_model.dart';
import 'package:athlorun/features/account_registration/domain/repositoy/account_registration_repository.dart';

class VerifyOtpUsecase {
  final AccountRegistrationRepository _repository;
  const VerifyOtpUsecase(this._repository);
  Future<Either<Failure, VerifyOtpResponseModel>> call(
      VerifyOtpRequestModel body) async {
    return _repository.verifyOtp(body);
  }
}
