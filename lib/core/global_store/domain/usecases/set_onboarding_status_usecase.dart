import 'package:dartz/dartz.dart';
import 'package:athlorun/core/global_store/domain/repository/global_store_repository.dart';
import 'package:athlorun/core/status/failures.dart';

class SetOnboardingStatusUsecase {
  final GlobalStoreRepository _repository;
  SetOnboardingStatusUsecase(this._repository);
  Future<Either<Failure, void>> call(bool status) async {
    return _repository.setOnboardingStatus(status);
  }
}
