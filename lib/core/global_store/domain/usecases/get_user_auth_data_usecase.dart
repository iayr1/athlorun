import 'package:dartz/dartz.dart';
import 'package:athlorun/core/global_store/data/models/user_auth_data_model.dart';
import 'package:athlorun/core/global_store/domain/repository/global_store_repository.dart';
import 'package:athlorun/core/status/failures.dart';

class GetUserAuthDataUsecase {
  final GlobalStoreRepository _repository;
  GetUserAuthDataUsecase(this._repository);
  Future<Either<Failure, UserAuthDataModel>> call() async {
    return _repository.getUserAuthData();
  }
}
