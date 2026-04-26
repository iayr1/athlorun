import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/account_registration/data/models/targets_response_model.dart';
import 'package:athlorun/features/account_registration/domain/repositoy/account_registration_repository.dart';

class GetTargetsUsecase {
  final AccountRegistrationRepository _repository;
  const GetTargetsUsecase(this._repository);
  Future<Either<Failure, TargetsResponseModel>> call() async {
    return _repository.getTargets();
  }
}
