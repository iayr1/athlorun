import 'package:dartz/dartz.dart';
import 'package:athlorun/core/global_store/data/models/user_auth_data_model.dart';
import 'package:athlorun/core/global_store/domain/repository/global_store_repository.dart';
import 'package:athlorun/core/status/failures.dart';

class SetUserAuthDataUsecase {
  final GlobalStoreRepository _repository;
  SetUserAuthDataUsecase(this._repository);

  Future<Either<Failure, void>> call(
    UserAuthDataModel authData,
  ) async {
    return _repository.setUserAuthData(authData);
  }
}
