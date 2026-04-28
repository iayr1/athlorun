import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/features/challenges/data/models/response/get_challenge_response_model.dart';
import 'package:athlorun/features/challenges/presentation/bloc/challenges_cubit.dart';
import 'package:athlorun/features/challenges/presentation/pages/challenge_detailed_screen.dart';

class ChallengePosterScreenWrapper extends StatelessWidget {
  final GetChallengeResponseDataModel challenge;

  const ChallengePosterScreenWrapper({
    super.key,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChallengesCubit>()..loadChallenge(challenge),
      child: ChallengePosterScreen(challenge: challenge),
    );
  }
}

class ChallengePosterScreen extends StatelessWidget {
  final GetChallengeResponseDataModel challenge;

  const ChallengePosterScreen({
    super.key,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChallengesCubit, ChallengesState>(
      listener: (context, state) {
        if (state is ChallengesNavigateToCongratulations) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Challenge completed successfully.')),
          );
        }
      },
      builder: (context, state) {
        if (state is ChallengesLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final challengeData = state is ChallengesLoaded ? state.challenge : challenge;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Challenge Poster'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/challenge/challengecoverbroad.png',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  challengeData.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  challengeData.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text('${challengeData.progress} / ${challengeData.target} completed'),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: challengeData.completionRatio.clamp(0, 1),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChallengeDetailsScreenWrapper(
                            challenge: challengeData,
                          ),
                        ),
                      );
                    },
                    child: const Text('Open challenge details'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () =>
                        context.read<ChallengesCubit>().completeChallenge(challengeData),
                    child: const Text('Mark as complete'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
