import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/profile/data/models/get_gear_types_response_model.dart';
import 'package:athlorun/features/profile/domain/repository/profile_repository.dart';

class GetGearTypesUsecase {
  final ProfileRepository _repository;
  const GetGearTypesUsecase(this._repository);
  Future<Either<Failure, GetGearTypesResponseModel>> call() async {
    return _repository.getGearTypes();
  }
}
