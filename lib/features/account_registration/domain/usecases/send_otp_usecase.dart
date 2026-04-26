import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/account_registration/data/models/send_otp_request_model.dart';
import 'package:athlorun/features/account_registration/data/models/send_otp_response_model.dart';
import 'package:athlorun/features/account_registration/domain/repositoy/account_registration_repository.dart';

class SendOtpUsecase {
  final AccountRegistrationRepository _repository;
  const SendOtpUsecase(this._repository);
  Future<Either<Failure, SendOtpResponseModel>> call(
      SendOtpRequestModel body) async {
    return _repository.sendOtp(body);
  }
}
