import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/profile/data/models/response/profile_targets_response_model.dart';
import 'package:athlorun/features/profile/domain/repository/profile_repository.dart';

class ProfileGetTargetsUsecase {
  final ProfileRepository _repository;
  const ProfileGetTargetsUsecase(this._repository);
  Future<Either<Failure, ProfileTargetsResponseModel>> call() async {
    return _repository.getTargets();
  }
}
