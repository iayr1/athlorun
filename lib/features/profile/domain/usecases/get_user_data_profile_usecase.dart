import 'package:dartz/dartz.dart';
import 'package:athlorun/core/global_store/data/models/user_data_response_model.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/profile/domain/repository/profile_repository.dart';

class GetUserDataProfileUsecase {
  final ProfileRepository _repository;
  GetUserDataProfileUsecase(this._repository);

  Future<Either<Failure, UserDataResponseModel>> call(String authId) {
    return _repository.getUserData(authId);
  }
}
