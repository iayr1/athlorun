import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/challenges/data/models/response/error_response.dart';
import 'package:athlorun/features/challenges/data/models/response/get_challenge_response_model.dart';
import 'package:athlorun/features/challenges/data/models/response/get_participated_challenges_response_model.dart';
import 'package:athlorun/features/challenges/data/models/response/get_user_participated_challenges_response_model.dart';
import 'package:athlorun/features/challenges/data/models/response/leave_participated_challenges_response_model.dart';
import 'package:athlorun/features/challenges/data/models/response/post_user_participated_challenges_response_model.dart';

abstract class ChallengesRepository {
  Future<Either<Failure, GetChallengeResponseModel>> getChallenges(
      String userId);

  Future<Either<Failure, GetUserParticipatedChallengesResponseModel>>
      getUserParticipatedChallenges(String userId, String? status);

  Future<Either<ErrorResponse, PostUserParticipatedChallengesResponseModel>>
      participatedChallenges(String userId, String challengeId);

  Future<Either<Failure, GetParticipatedChallengesResponseModel>>
      getParticipatedChallenges(String userId, String challengeId);

  Future<Either<Failure, LeaveParticipatedChallengesResponseModel>>
      leaveParticipatedChallenges(String userId, String challengeId);
}
