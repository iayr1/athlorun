import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/profile/data/models/get_gear_response_model.dart';
import 'package:athlorun/features/profile/domain/repository/profile_repository.dart';

class GetGearAllUsecase {
  final ProfileRepository _repository;
  const GetGearAllUsecase(this._repository);
  Future<Either<Failure, GetGearResponseModel>> call(String id) async {
    return _repository.getGear(id);
  }
}
