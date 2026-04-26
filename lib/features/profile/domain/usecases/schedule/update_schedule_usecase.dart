import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/profile/data/models/request/create_schedule_request_model.dart';
import 'package:athlorun/features/profile/domain/repository/profile_repository.dart';

class UpdateScheduleUsecase {
  final ProfileRepository _profileRepository;
  UpdateScheduleUsecase(this._profileRepository);

  Future<Either<Failure, CreateScheduleRequestModel>> call(
      String id, String scheduleId, CreateScheduleRequestModel body) async {
    return _profileRepository.updateSchedule(id, scheduleId, body);
  }
}
