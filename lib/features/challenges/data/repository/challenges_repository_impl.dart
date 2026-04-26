import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/features/challenges/data/datasources/remote/challenges_client.dart';
import 'package:athlorun/features/challenges/data/models/response/error_response.dart';
import 'package:athlorun/features/challenges/data/models/response/get_challenge_response_model.dart';
import 'package:athlorun/features/challenges/data/models/response/get_participated_challenges_response_model.dart';
import 'package:athlorun/features/challenges/data/models/response/get_user_participated_challenges_response_model.dart';
import 'package:athlorun/features/challenges/data/models/response/leave_participated_challenges_response_model.dart';
import 'package:athlorun/features/challenges/data/models/response/post_user_participated_challenges_response_model.dart';
import 'package:athlorun/features/challenges/domain/repository/challenges_repository.dart';

class ChallengesRepositoryImpl implements ChallengesRepository {
  final ChallengesClient _client;
  const ChallengesRepositoryImpl(this._client);

  @override
  Future<Either<Failure, GetChallengeResponseModel>> getChallenges(
      String userId) async {
    try {
      final response = await _client.getChallenges(userId);
      return right(response);
    } catch (e) {
      Utils.debugLog(e.toString());
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, GetUserParticipatedChallengesResponseModel>>
      getUserParticipatedChallenges(String userId, String? status) async {
    try {
      final response =
          await _client.getUserParticipatedChallenges(userId, status);
      return right(response);
    } catch (e) {
      Utils.debugLog(e.toString());
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<ErrorResponse, PostUserParticipatedChallengesResponseModel>>
      participatedChallenges(String userId, String challengeId) async {
    try {
      final response =
          await _client.participatedChallenges(userId, challengeId);
      return right(response);
    } on DioException catch (e) {
      final errorResponse = ErrorResponse(
        status: e.response?.statusCode,
        statusText: e.response?.statusMessage,
        message: e.response?.data?["message"] ?? "Something went wrong",
        data: e.response?.data,
      );
      return left(errorResponse);
    } catch (e) {
      return left(ErrorResponse(message: AppStrings.somethingWentWrong));
    }
  }

  @override
  Future<Either<Failure, GetParticipatedChallengesResponseModel>>
      getParticipatedChallenges(String userId, String challengeId) async {
    try {
      final response =
          await _client.getParticipatedChallenges(userId, challengeId);
      return right(response);
    } catch (e) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, LeaveParticipatedChallengesResponseModel>>
      leaveParticipatedChallenges(String userId, String challengeId) async {
    try {
      final response =
          await _client.leaveParticipatedChallenges(userId, challengeId);
      return right(response);
    } catch (e) {
      return left(ServerFailure());
    }
  }
}
