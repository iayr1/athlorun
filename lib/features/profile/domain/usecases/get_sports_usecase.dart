import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/profile/data/models/get_sports_response_model.dart';
import 'package:athlorun/features/profile/domain/repository/profile_repository.dart';

class GetSportsUsecase {
  final ProfileRepository _repository;
  const GetSportsUsecase(this._repository);
  Future<Either<Failure, GetSportsResponseModel>> call() async {
    return _repository.getSports();
  }
}
