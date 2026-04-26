import 'package:dartz/dartz.dart';
import 'package:athlorun/core/global_store/domain/repository/global_store_repository.dart';
import 'package:athlorun/core/status/failures.dart';

class LogoutUsecase {
  final GlobalStoreRepository _repository;
  LogoutUsecase(this._repository);
  Future<Either<Failure, void>> call() async {
    return _repository.logout();
  }
}
