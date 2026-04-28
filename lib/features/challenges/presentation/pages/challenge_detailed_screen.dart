import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/config/routes/routes.dart';
import 'package:athlorun/features/challenges/data/models/response/get_challenge_response_model.dart';
import 'package:athlorun/features/challenges/presentation/bloc/challenges_cubit.dart';

class ChallengeDetailsScreenWrapper extends StatelessWidget {
  final GetChallengeResponseDataModel challenge;

  const ChallengeDetailsScreenWrapper({
    super.key,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChallengesCubit>()..loadChallenge(challenge),
      child: ChallengeDetailsScreen(challenge: challenge),
    );
  }
}

class ChallengeDetailsScreen extends StatefulWidget {
  final GetChallengeResponseDataModel challenge;

  const ChallengeDetailsScreen({
    super.key,
    required this.challenge,
  });

  @override
  State<ChallengeDetailsScreen> createState() => _ChallengeDetailsScreenState();
}

class _ChallengeDetailsScreenState extends State<ChallengeDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChallengesCubit, ChallengesState>(
      listener: (context, state) {
        if (state is ChallengesNavigateToCongratulations) {
          Navigator.pushNamed(context, AppRoutes.congratulationScreen);
        }
      },
      builder: (context, state) {
        if (state is ChallengesLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final challenge = state is ChallengesLoaded
            ? state.challenge
            : widget.challenge;

        return Scaffold(
          appBar: AppBar(title: Text(challenge.title)),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.modulate,
                  ),
                  child: Image.asset(
                    'assets/challenge/challengecoverbroad.png',
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(challenge.description),
                const SizedBox(height: 16),
                LinearProgressIndicator(value: challenge.completionRatio),
                const Spacer(),
                FilledButton(
                  onPressed: () => context
                      .read<ChallengesCubit>()
                      .completeChallenge(challenge),
                  child: const Text('Complete challenge'),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.scoreListScreen,
                  ),
                  child: const Text('View score list'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
