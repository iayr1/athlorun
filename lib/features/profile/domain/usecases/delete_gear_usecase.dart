import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/profile/data/models/delete_gear_response_model.dart';
import 'package:athlorun/features/profile/domain/repository/profile_repository.dart';

class DeleteGearUsecase {
  final ProfileRepository _repository;
  const DeleteGearUsecase(this._repository);

  Future<Either<Failure, DeleteGearResponseModel>> call(
      String id, String gearId) async {
    return _repository.deleteGear(id, gearId);
  }
}
