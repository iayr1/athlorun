import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:athlorun/core/global_store/data/models/user_auth_data_model.dart';
import 'package:athlorun/core/global_store/domain/usecases/get_user_auth_data_usecase.dart';
import 'package:athlorun/features/challenges/data/models/response/get_challenge_response_model.dart';
import 'package:athlorun/features/challenges/data/models/response/get_participated_challenges_response_model.dart';
import 'package:athlorun/features/challenges/data/models/response/get_user_participated_challenges_response_model.dart';
import 'package:athlorun/features/challenges/data/models/response/leave_participated_challenges_response_model.dart';
import 'package:athlorun/features/challenges/data/models/response/post_user_participated_challenges_response_model.dart';
import 'package:athlorun/features/challenges/domain/usecases/get_challenges_usecase.dart';
import 'package:athlorun/features/challenges/domain/usecases/get_participated_challenges_usecase.dart';
import 'package:athlorun/features/challenges/domain/usecases/get_user_participated_challenges_usecase.dart';
import 'package:athlorun/features/challenges/domain/usecases/leave_participated_challenges_usecase.dart';
import 'package:athlorun/features/challenges/domain/usecases/participated_challenges_usecase.dart';

part 'challenges_state.dart';
part 'challenges_cubit.freezed.dart';

class ChallengesCubit extends Cubit<ChallengesState> {
  final GetChallengesUsecase _getChallenges;
  final GetUserAuthDataUsecase _getUserAuthDataUsecase;
  final GetUserParticipatedChallengesUsecase _getChallengesUsercase;
  final GetParticipatedChallengesUsecase _getParticipatedChallengesUsecase;
  final ParticipatedChallengesUsecase _participatedChallengesUsecase;
  final LeaveParticipatedChallengesUsecase _leaveParticipatedChallengesUsecase;

  ChallengesCubit(
    this._getChallengesUsercase,
    this._getUserAuthDataUsecase,
    this._participatedChallengesUsecase,
    this._leaveParticipatedChallengesUsecase,
    this._getChallenges,
    this._getParticipatedChallengesUsecase,
  ) : super(const ChallengesState.comitial());

  //gettingAuthData
  Future<void> getAuthData() async {
    emit(const ChallengesState.gettingAuthData());
    final response = await _getUserAuthDataUsecase();
    response.fold((failure) {
      emit(ChallengesState.getAuthDataError(failure.message));
    }, (authData) {
      emit(ChallengesState.gotAuthData(authData));
    });
  }

  //getting challenges
  Future<void> getChallenges() async {
    emit(const ChallengesState.gettingChallenges());
    final authData = await _getUserAuthDataUsecase();
    authData.fold((l) {
      emit(ChallengesState.getChallengesError(l.message));
    }, (authData) async {
      final response = await _getChallenges.call(authData.id);
      response.fold((l) {
        emit(ChallengesState.getChallengesError(l.message));
      }, (r) {
        emit(ChallengesState.gotChallenges(r));
      });
    });
  }

  //getting participated Challenges
  Future<void> getParticipatedChallenges(String status) async {
    emit(const ChallengesState.gettingParticipatedChallenges());
    final authData = await _getUserAuthDataUsecase();
    authData.fold((l) {
      emit(ChallengesState.getParticipatedChallengesError(l.message));
    }, (authDate) async {
      final response = await _getChallengesUsercase.call(authDate.id, status);
      response.fold((l) {
        emit(ChallengesState.getParticipatedChallengesError(l.message));
      }, (r) {
        emit(ChallengesState.gotParticipatedChallenges(r));
      });
    });
  }

  //user participating in challenge
  Future<void> participateInTheChallenges(String challengeId) async {
    emit(const ChallengesState.participatingInChallenge());
    final authData = await _getUserAuthDataUsecase();
    authData.fold((l) {
      emit(ChallengesState.participatingInChallengeError(l.errorMessage));
    }, (authData) async {
      final response =
          await _participatedChallengesUsecase.call(authData.id, challengeId);
      response.fold((l) {
        emit(ChallengesState.participatingInChallengeError(
            l.message.toString()));
      }, (r) {
        emit(ChallengesState.participatedInChallenge(r));
      });
    });
  }

  //get user participated challenge
  Future<void> getUserParticipatedChallenges(String challengeId) async {
    emit(const ChallengesState.loadingParticipatedChallenges());
    final authData = await _getUserAuthDataUsecase();
    authData.fold((l) {
      emit(ChallengesState.loadedParticipatedChallengesError(l.errorMessage));
    }, (authData) async {
      final response = await _getParticipatedChallengesUsecase.call(
          authData.id, challengeId);
      response.fold((l) {
        emit(ChallengesState.loadedParticipatedChallengesError(
            l.message.toString()));
      }, (r) {
        emit(ChallengesState.loadedParticipatedChallenges(r));
      });
    });
  }

  //leave participated challenge
  Future<void> leaveParticipatedChallenges(String challengeId) async {
    emit(const ChallengesState.leavingChallenge());
    final authData = await _getUserAuthDataUsecase();
    authData.fold((l) {
      emit(ChallengesState.leaveChallengeError(l.message));
    }, (authData) async {
      final response = await _leaveParticipatedChallengesUsecase.call(
          authData.id, challengeId);
      response.fold((l) {
        emit(ChallengesState.leaveChallengeError(l.message));
      }, (r) {
        emit(ChallengesState.leftChallenge(r));
      });
    });
  }
}
