import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/home/data/models/request/step_request_model.dart';
import 'package:athlorun/features/home/domain/repository/home_repository.dart';

class UpdateStepDataUsecase {
  final HomeRepository _homeRepository;
  UpdateStepDataUsecase(this._homeRepository);
  Future<Either<Failure, dynamic>> call(
      String id, StepRequestModel body) async {
    return _homeRepository.updateStepsData(id, body);
  }
}
