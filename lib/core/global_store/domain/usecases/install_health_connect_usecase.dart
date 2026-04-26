import 'package:dartz/dartz.dart';
import 'package:athlorun/core/global_store/domain/repository/global_store_repository.dart';
import 'package:athlorun/core/status/failures.dart';

class InstallHealthConnectUsecase {
  final GlobalStoreRepository _repository;
  InstallHealthConnectUsecase(this._repository);
  Future<Either<Failure, void>> call() async {
    return _repository.installHealthConnect();
  }
}
