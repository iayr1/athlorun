import 'package:dartz/dartz.dart';
import 'package:athlorun/core/global_store/data/models/user_data_response_model.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/profile/data/models/request/update_user_profile_request_model.dart';
import 'package:athlorun/features/profile/domain/repository/profile_repository.dart';

class UpdateUserProfileUsecase {
  final ProfileRepository _repository;
  UpdateUserProfileUsecase(this._repository);

  Future<Either<Failure, UserDataResponseModel>> call(
      String authId, UpdateUserProfileRequestModel body) {
    return _repository.updateUserProfile(authId, body);
  }
}
