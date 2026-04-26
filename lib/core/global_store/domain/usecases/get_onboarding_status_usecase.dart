import 'package:dartz/dartz.dart';
import 'package:athlorun/core/global_store/domain/repository/global_store_repository.dart';
import 'package:athlorun/core/status/failures.dart';

class GetOnboardingStatusUsecase {
  final GlobalStoreRepository _repository;
  GetOnboardingStatusUsecase(this._repository);
  Future<Either<Failure, void>> call() async {
    return _repository.getOnboardingStatus();
  }
}
