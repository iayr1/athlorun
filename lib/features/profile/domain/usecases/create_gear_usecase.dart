import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/profile/data/models/create_gear_request_model.dart';
import 'package:athlorun/features/profile/domain/repository/profile_repository.dart';

class CreateGearUsecase {
  final ProfileRepository _repository;
  const CreateGearUsecase(this._repository);
  Future<Either<Failure, CreateGearRequestModel>> call(
    String id,
    String typeId,
    String sportId,
    String brand,
    String model,
    String weight,
    File photoFile,
  ) async {
    return _repository.createGear(
        id, typeId, sportId, brand, model, weight, photoFile);
  }
}
