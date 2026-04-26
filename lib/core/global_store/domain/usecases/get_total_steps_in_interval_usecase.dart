import 'package:dartz/dartz.dart';
import 'package:athlorun/core/global_store/domain/repository/global_store_repository.dart';
import 'package:athlorun/core/status/failures.dart';

class GetTotalStepsInIntervalUsecase {
  final GlobalStoreRepository _repository;
  GetTotalStepsInIntervalUsecase(this._repository);
  Future<Either<Failure, int>> call(
    DateTime startTime,
    DateTime endTime, {
    bool includeManualEntry = true,
  }) async {
    return _repository.getTotalStepsInInterval(
      startTime,
      endTime,
      includeManualEntry: includeManualEntry,
    );
  }
}
