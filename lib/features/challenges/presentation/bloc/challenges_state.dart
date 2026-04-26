part of 'challenges_cubit.dart';

@freezed
class ChallengesState with _$ChallengesState {
  const factory ChallengesState.comitial() = _Initial;

  //auth state
  const factory ChallengesState.gettingAuthData() = _GettingAuthData;
  const factory ChallengesState.gotAuthData(UserAuthDataModel authData) =
      _GotAuthData;
  const factory ChallengesState.getAuthDataError(String error) =
      _GetAuthDataError;

  //get challenge state
  const factory ChallengesState.gettingChallenges() = _GettingChallenges;
  const factory ChallengesState.gotChallenges(
      GetChallengeResponseModel challengesData) = _GotChallenges;
  const factory ChallengesState.getChallengesError(String error) =
      _GetChallengesError;

  //get Participated challenge state
  const factory ChallengesState.gettingParticipatedChallenges() =
      _GettingParticipatedChallenges;
  const factory ChallengesState.gotParticipatedChallenges(
          GetUserParticipatedChallengesResponseModel challengesData) =
      _GotParticipatedChallenges;
  const factory ChallengesState.getParticipatedChallengesError(String error) =
      _GetParticipatedChallengesError;

  //get user specific Participated challenge state
  const factory ChallengesState.loadingParticipatedChallenges() =
      _LoadingParticipatedChallenges;
  const factory ChallengesState.loadedParticipatedChallenges(
          GetParticipatedChallengesResponseModel challengesData) =
      _LoadedParticipatedChallenges;
  const factory ChallengesState.loadedParticipatedChallengesError(
      String error) = _LoadedParticipatedChallengesError;

  //participating in challenge state
  const factory ChallengesState.participatingInChallenge() =
      _ParticipatingInChallenge;
  const factory ChallengesState.participatedInChallenge(
      PostUserParticipatedChallengesResponseModel
          participateChallengeData) = _ParticipatedInChallenge;
  const factory ChallengesState.participatingInChallengeError(String error) =
      _ParticipatingInChallengeError;

  //leaving challenge state
  const factory ChallengesState.leavingChallenge() = _LeavingChallenge;
  const factory ChallengesState.leftChallenge(
          LeaveParticipatedChallengesResponseModel leaveResponseModel) =
      _LeftChallenge;
  const factory ChallengesState.leaveChallengeError(String error) =
      _LeaveChallengeError;
}
