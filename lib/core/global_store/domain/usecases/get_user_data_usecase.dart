import 'package:dartz/dartz.dart';
import 'package:athlorun/core/global_store/data/models/user_auth_data_model.dart';
import 'package:athlorun/core/global_store/data/models/user_data_response_model.dart';
import 'package:athlorun/core/global_store/domain/repository/global_store_repository.dart';
import 'package:athlorun/core/status/failures.dart';

class GetUserDataUsecase {
  final GlobalStoreRepository _repository;
  GetUserDataUsecase(this._repository);

  Future<Either<Failure, UserData>> call(UserAuthDataModel authData) {
    return _repository.getUserData(authData);
  }
}
