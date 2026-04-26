import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/profile/data/models/request/create_schedule_request_model.dart';
import 'package:athlorun/features/profile/domain/repository/profile_repository.dart';

class CreateScheduleUsecase {
  final ProfileRepository _repository;
  const CreateScheduleUsecase(this._repository);

  Future<Either<Failure, CreateScheduleRequestModel>> call(
      String id, CreateScheduleRequestModel body) async {
    return _repository.createSchedule(id, body);
  }
}
