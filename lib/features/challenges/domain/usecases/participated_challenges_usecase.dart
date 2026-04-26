import 'package:dartz/dartz.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/features/challenges/data/models/response/error_response.dart';
import 'package:athlorun/features/challenges/data/models/response/post_user_participated_challenges_response_model.dart';
import 'package:athlorun/features/challenges/domain/repository/challenges_repository.dart';

class ParticipatedChallengesUsecase {
  final ChallengesRepository _challengesRepository;
  ParticipatedChallengesUsecase(this._challengesRepository);

  Future<Either<ErrorResponse, PostUserParticipatedChallengesResponseModel>>
      call(String userId, String challengeId) async {
    try {
      return await _challengesRepository.participatedChallenges(
          userId, challengeId);
    } catch (e, stackTrace) {
      Utils.debugLog("Error in GetChallengesUsecase: $e");
      Utils.debugLog("StackTrace: $stackTrace");
      return Left(ErrorResponse(message: e.toString()));
    }
  }
}
