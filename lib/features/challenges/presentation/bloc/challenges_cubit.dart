import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:athlorun/features/challenges/data/models/response/get_challenge_response_model.dart';

sealed class ChallengesState {
  const ChallengesState();
}

class ChallengesInitial extends ChallengesState {
  const ChallengesInitial();
}

class ChallengesLoading extends ChallengesState {
  const ChallengesLoading();
}

class ChallengesLoaded extends ChallengesState {
  final GetChallengeResponseDataModel challenge;

  const ChallengesLoaded(this.challenge);
}

class ChallengesNavigateToCongratulations extends ChallengesState {
  final GetChallengeResponseDataModel challenge;

  const ChallengesNavigateToCongratulations(this.challenge);
}

class ChallengesError extends ChallengesState {
  final String message;

  const ChallengesError(this.message);
}

class ChallengesCubit extends Cubit<ChallengesState> {
  ChallengesCubit() : super(const ChallengesInitial());

  Future<void> loadChallenge(GetChallengeResponseDataModel challenge) async {
    emit(const ChallengesLoading());
    emit(ChallengesLoaded(challenge));
  }

  void completeChallenge(GetChallengeResponseDataModel challenge) {
    emit(ChallengesNavigateToCongratulations(challenge));
  }
}
