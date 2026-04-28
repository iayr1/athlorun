import 'package:get_it/get_it.dart';

import 'package:athlorun/features/challenges/presentation/bloc/challenges_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  if (!sl.isRegistered<ChallengesCubit>()) {
    sl.registerFactory<ChallengesCubit>(ChallengesCubit.new);
  }
}
