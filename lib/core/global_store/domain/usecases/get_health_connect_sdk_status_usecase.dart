import 'package:dartz/dartz.dart';
import 'package:athlorun/core/global_store/domain/repository/global_store_repository.dart';
import 'package:athlorun/core/status/failures.dart';

class GetHealthConnectSdkStatusUsecase {
  final GlobalStoreRepository _repository;
  GetHealthConnectSdkStatusUsecase(this._repository);
  Future<Either<Failure, bool>> call() async {
    return _repository.getHealthConnectSdkStatus();
  }
}
