import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/features/challenges/data/models/response/get_challenge_response_model.dart';
import 'package:athlorun/features/challenges/domain/repository/challenges_repository.dart';

class GetChallengesUsecase {
  final ChallengesRepository _challengesRepository;
  GetChallengesUsecase(this._challengesRepository);

  Future<Either<Failure, GetChallengeResponseModel>> call(String userId) async {
    try {
      return await _challengesRepository.getChallenges(userId);
    } catch (e, stackTrace) {
      Utils.debugLog("Error in GetChallengesUsecase: $e");
      Utils.debugLog("StackTrace: $stackTrace");
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
