import 'package:dartz/dartz.dart';
import 'package:health/health.dart';
import 'package:athlorun/core/global_store/domain/repository/global_store_repository.dart';
import 'package:athlorun/core/status/failures.dart';

class RequestHealthAuthorizationUsecase {
  final GlobalStoreRepository _repository;
  RequestHealthAuthorizationUsecase(this._repository);
  Future<Either<Failure, bool>> call(List<HealthDataType> types,
      {List<HealthDataAccess>? permissions}) async {
    return _repository.requestHealthAuthorization(types,
        permissions: permissions);
  }
}
