import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/account_registration/data/models/upload_selfie_response_model.dart';
import 'package:athlorun/features/account_registration/domain/repositoy/account_registration_repository.dart';

class UploadSelfieUsecase {
  final AccountRegistrationRepository _repository;
  const UploadSelfieUsecase(this._repository);
  Future<Either<Failure, SelfieResponseModel>> call(
      String id, File file) async {
    return _repository.uploadSelfie(id, file);
  }
}
