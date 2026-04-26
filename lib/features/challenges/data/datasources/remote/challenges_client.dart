import 'package:dio/dio.dart';
import 'package:athlorun/core/constants/api_strings.dart';
import 'package:athlorun/features/challenges/data/models/response/get_challenge_response_model.dart';
import 'package:athlorun/features/challenges/data/models/response/get_participated_challenges_response_model.dart';
import 'package:athlorun/features/challenges/data/models/response/get_user_participated_challenges_response_model.dart';
import 'package:athlorun/features/challenges/data/models/response/leave_participated_challenges_response_model.dart';
import 'package:athlorun/features/challenges/data/models/response/post_user_participated_challenges_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'challenges_client.g.dart';

@RestApi()
abstract class ChallengesClient {
  factory ChallengesClient(Dio dio) = _ChallengesClient;

  //get api for allChallenges
  @GET(ApiStrings.getUserChallenges)
  Future<GetChallengeResponseModel> getChallenges(
    @Query("userId") String userId,
  );

  //get api for Challenges based on status
  @GET(ApiStrings.getUserParticipatedChallenges)
  Future<GetUserParticipatedChallengesResponseModel>
      getUserParticipatedChallenges(
    @Path("id") String userId,
    @Query("status") String? status,
  );

  //post api for participating in challenge
  @POST(ApiStrings.participateUserInTheChallenge)
  Future<PostUserParticipatedChallengesResponseModel> participatedChallenges(
    @Path("id") String userId,
    @Path("challengeId") String challengeId,
  );

  //get api for single participated challenge
  @GET(ApiStrings.getParticipateUserInTheChallenge)
  Future<GetParticipatedChallengesResponseModel> getParticipatedChallenges(
    @Path("id") String userId,
    @Path("challengeId") String challengeId,
  );

  //leave participated challenge api
  @DELETE(ApiStrings.leaveParticipatedChallenge)
  Future<LeaveParticipatedChallengesResponseModel> leaveParticipatedChallenges(
    @Path("id") String userId,
    @Path("challengeId") String challengeId,
  );
}
