import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/profile/data/models/response/get_schedule_response_model.dart';
import 'package:athlorun/features/profile/domain/repository/profile_repository.dart';

class GetScheduleUsecase {
  final ProfileRepository _profileRepository;

  GetScheduleUsecase(this._profileRepository);

  Future<Either<Failure, GetScheduleResponseModel>> call(String id) async {
    return _profileRepository.getSchedule(id);
  }
}
