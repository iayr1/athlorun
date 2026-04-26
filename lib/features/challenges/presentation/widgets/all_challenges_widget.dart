import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/features/challenges/data/models/response/get_challenge_response_model.dart';
import 'package:athlorun/features/challenges/presentation/bloc/challenges_cubit.dart';
import 'package:athlorun/features/challenges/presentation/widgets/challenge_item_widget.dart';
import 'package:athlorun/features/challenges/presentation/widgets/challenge_shimmer.dart';

class AllChallengesWidgetWrapper extends StatelessWidget {
  String? searchQuery;
  AllChallengesWidgetWrapper({super.key, this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChallengesCubit>(),
      child: AllChallengesPage(
        searchQuery: searchQuery,
      ),
    );
  }
}

class AllChallengesPage extends StatefulWidget {
  String? searchQuery;
  AllChallengesPage({super.key, this.searchQuery});

  @override
  State<AllChallengesPage> createState() => _AllChallengesPageState();
}

class _AllChallengesPageState extends State<AllChallengesPage> {
  late final ChallengesCubit _cubit;
  late List<GetChallengeResponseDataModel> challengeList = [];
  bool isLoading = false;

  List<GetChallengeResponseDataModel> get _filteredChallenges {
    return challengeList.where((challenge) {
      final query = widget.searchQuery?.toLowerCase() ?? '';
      return challenge.title!.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void initState() {
    _cubit = context.read<ChallengesCubit>();
    _cubit.getChallenges();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChallengesCubit, ChallengesState>(
      builder: (context, state) {
        return isLoading
            ? const ChallengeItemShimmer()
            : _buildChallenges(_filteredChallenges);
      },
      listener: (BuildContext context, ChallengesState state) {
        state.maybeWhen(
            gettingChallenges: () {
              setState(
                () {
                  isLoading = true;
                },
              );
            },
            gotChallenges: (challengesData) {
              setState(() {
                isLoading = false;
                challengeList = challengesData.data!.where((data) {
                  if (data.endDate != null) {
                    final endDate = data.endDate;
                    if (endDate != null) {
                      return endDate.isAfter(DateTime.now()) ||
                          DateTime(endDate.year, endDate.month, endDate.day)
                              .isAtSameMomentAs(
                            DateTime(DateTime.now().year, DateTime.now().month,
                                DateTime.now().day),
                          );
                    }
                  }
                  return false;
                }).toList();
              });
            },
            getChallengesError: (error) {
              setState(
                () {
                  isLoading = false;
                },
              );
            },
            orElse: () {});
      },
    );
  }

  Widget _buildChallenges(List<GetChallengeResponseDataModel> challenges) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        final challenge = challenges[index];

        return ChallengeItem(
          challengesList: challenge,
          title: challenge.title!,
          date:
              "${Utils.formatToDDMMMYYYY(challenge.startDate!)} to ${Utils.formatToDDMMMYYYY(challenge.endDate!)}",
          description: "${challenge.targetDescription}",
          imagePath: challenge.badge!,
        );
      },
    );
  }
}
