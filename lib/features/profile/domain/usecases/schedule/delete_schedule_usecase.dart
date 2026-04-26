import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/profile/data/models/response/delete_schedule_response_model.dart';
import 'package:athlorun/features/profile/domain/repository/profile_repository.dart';

class DeleteScheduleUsecase {
  final ProfileRepository _profileRepository;
  DeleteScheduleUsecase(this._profileRepository);

  Future<Either<Failure, DeleteScheduleResponseModel>> call(
      String id, String scheduleId) async {
    return _profileRepository.deleteSchedule(id, scheduleId);
  }
}
