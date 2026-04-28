import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:athlorun/features/challenges/data/models/response/get_challenge_response_model.dart';
import 'package:athlorun/features/challenges/presentation/bloc/challenges_cubit.dart';
import 'package:athlorun/features/challenges/presentation/pages/challenge_poster_screen.dart';

class ChallengeItemWidget extends StatelessWidget {
  final GetChallengeResponseDataModel challenge;

  const ChallengeItemWidget({
    super.key,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(challenge.title),
      subtitle: Text(
        '${challenge.progress} / ${challenge.target} completed',
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      onTap: () async {
        final cubit = context.read<ChallengesCubit>();
        final navigator = Navigator.of(context);

        await cubit.loadChallenge(challenge);

        if (!context.mounted) return;

        navigator.push(
          MaterialPageRoute(
            builder: (_) => ChallengePosterScreenWrapper(challenge: challenge),
          ),
        );
      },
    );
  }
}
