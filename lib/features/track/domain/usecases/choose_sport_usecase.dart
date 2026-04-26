import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/track/data/models/choose_sport_response_model.dart';
import 'package:athlorun/features/track/domain/repositories/track_repositories.dart';

class ChooseSportsUsecase {
  final TrackRepository _repository;
  const ChooseSportsUsecase(this._repository);
  Future<Either<Failure, SportsResponseModel>> call() async {
    return _repository.chooseSports();
  }
}
