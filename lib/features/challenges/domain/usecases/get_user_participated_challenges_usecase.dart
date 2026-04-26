import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/features/challenges/data/models/response/get_user_participated_challenges_response_model.dart';
import 'package:athlorun/features/challenges/domain/repository/challenges_repository.dart';

class GetUserParticipatedChallengesUsecase {
  final ChallengesRepository _challengesRepository;
  GetUserParticipatedChallengesUsecase(this._challengesRepository);

  Future<Either<Failure, GetUserParticipatedChallengesResponseModel>> call(
      String userId, String? status) async {
    try {
      return await _challengesRepository.getUserParticipatedChallenges(
          userId, status);
    } catch (e, stackTrace) {
      Utils.debugLog("Error in GetChallengesUsecase: $e");
      Utils.debugLog("StackTrace: $stackTrace");
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
