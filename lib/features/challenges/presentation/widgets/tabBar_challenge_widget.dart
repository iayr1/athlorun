import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/config/routes/routes.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/config/styles/app_textstyles.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/core/utils/windows.dart';
import 'package:athlorun/features/challenges/data/models/response/get_user_participated_challenges_response_model.dart';
import 'package:athlorun/features/challenges/presentation/bloc/challenges_cubit.dart';
import 'package:athlorun/features/challenges/presentation/widgets/challenge_shimmer.dart';

class TabbarChallengeWidget extends StatelessWidget {
  const TabbarChallengeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChallengesCubit>(),
      child: const TabbarChallengesPage(),
    );
  }
}

class TabbarChallengesPage extends StatefulWidget {
  const TabbarChallengesPage({super.key});

  @override
  State<TabbarChallengesPage> createState() => _TState();
}

class _TState extends State<TabbarChallengesPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late final ChallengesCubit _cubit;
  late List<ChallengeElement> participatedChallenges = [];
  late List<ChallengeElement> completedChallenges = [];

  @override
  void initState() {
    _cubit = context.read<ChallengesCubit>();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.getParticipatedChallenges("participated");
    });

    super.initState();
  }

  // Function to listen for tab changes
  void _onTabChanged() {
    if (_tabController.index == 0) {
      _cubit.getParticipatedChallenges("participated");
    } else {
      _cubit.getParticipatedChallenges("completed");
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryBlue100,
          unselectedLabelColor: AppColors.neutral60,
          indicatorColor: AppColors.primaryBlue100,
          labelStyle: AppTextStyles.bodyBold,
          tabs: const [
            Tab(text: AppStrings.participateChallenges),
            Tab(text: AppStrings.completed),
          ],
        ),
        SizedBox(height: Window.getVerticalSize(10)),
        SizedBox(
            height: Window.getVerticalSize(250),
            child: BlocConsumer<ChallengesCubit, ChallengesState>(
              builder: (context, state) {
                return state.maybeWhen(
                  gettingParticipatedChallenges: () {
                    return const ChallengeShimmer();
                  },
                  gotParticipatedChallenges: (challengesData) {
                    return TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: [
                        _buildParticipatedChallenges(),
                        _buildCompletedChallenges()
                      ],
                    );
                  },
                  getParticipatedChallengesError: (error) {
                    return Utils.showError();
                  },
                  orElse: () {
                    return Utils.showError();
                  },
                );
              },
              listener: (BuildContext context, ChallengesState state) {
                state.maybeWhen(
                  gotParticipatedChallenges: (challengesData) {
                    participatedChallenges = challengesData.data!.challenges!;
                    completedChallenges = challengesData.data!.challenges!;
                  },
                  orElse: () {},
                );
              },
            )),
      ],
    );
  }

  Widget _buildParticipatedChallenges() {
    return participatedChallenges.isNotEmpty
        ? SizedBox(
            height: Window.getVerticalSize(250),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: Window.getPadding(all: 16.0),
              itemCount: participatedChallenges.length,
              itemBuilder: (context, index) {
                final challenge = participatedChallenges[index].challenge;
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, AppRoutes.completedChallengeScreen,
                        arguments: challenge);
                  },
                  child: Container(
                    width: Window.getHorizontalSize(220),
                    margin:
                        EdgeInsets.only(right: Window.getHorizontalSize(12)),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Window.getRadiusSize(16)),
                      image: const DecorationImage(
                        image: AssetImage("assets/rectanglecontainer.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    padding: EdgeInsets.all(Window.getSize(16)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 12.0,
                                spreadRadius: 3.0,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: CachedNetworkImage(
                            imageUrl: challenge!.badge!,
                            height: Window.getSize(70),
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: Window.getVerticalSize(12)),
                        Text(
                          challenge.title!,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.subtitleBold
                              .copyWith(color: Colors.white),
                        ),
                        SizedBox(height: Window.getVerticalSize(6)),
                        Text(
                          "${Utils.formatToDDMMMYYYY(challenge.startDate!)} to ${Utils.formatToDDMMMYYYY(challenge.endDate!)}",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyRegular
                              .copyWith(color: Colors.white70),
                        ),
                        SizedBox(height: Window.getVerticalSize(6)),
                        Text(
                          "${challenge.targetValue!} ${challenge.targetUnit!}",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyRegular
                              .copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.emoji_events,
                      size: 60, color: AppColors.neutral60),
                  const SizedBox(height: 10),
                  Text(
                    AppStrings.noParticipatedChallengesAvailable,
                    style: AppTextStyles.bodySemiBold
                        .copyWith(color: AppColors.neutral100),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    AppStrings.checkBackLaterForNewChallenege,
                    style: AppTextStyles.captionRegular
                        .copyWith(color: AppColors.neutral60),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildCompletedChallenges() {
    return completedChallenges.isNotEmpty
        ? SizedBox(
            height: Window.getVerticalSize(250),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: Window.getPadding(all: 16.0),
              itemCount: completedChallenges.length,
              itemBuilder: (context, index) {
                final challenge = completedChallenges[index].challenge;
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, AppRoutes.completedChallengeScreen,
                        arguments: challenge);
                  },
                  child: Container(
                    width: Window.getHorizontalSize(220),
                    margin:
                        EdgeInsets.only(right: Window.getHorizontalSize(12)),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Window.getRadiusSize(16)),
                      image: const DecorationImage(
                        image: AssetImage("assets/rectanglecontainer.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    padding: EdgeInsets.all(Window.getSize(16)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 12.0,
                                spreadRadius: 3.0,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: CachedNetworkImage(
                            imageUrl: challenge!.badge!,
                            height: Window.getSize(70),
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: Window.getVerticalSize(12)),
                        Text(
                          challenge.title!,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.subtitleBold
                              .copyWith(color: Colors.white),
                        ),
                        SizedBox(height: Window.getVerticalSize(6)),
                        Text(
                          "${Utils.formatToDDMMMYYYY(challenge.startDate!)} to ${Utils.formatToDDMMMYYYY(challenge.endDate!)}",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyRegular
                              .copyWith(color: Colors.white70),
                        ),
                        SizedBox(height: Window.getVerticalSize(6)),
                        Text(
                          "${challenge.targetValue!} ${challenge.targetUnit!}",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyRegular
                              .copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.emoji_events,
                      size: 60, color: AppColors.neutral60),
                  const SizedBox(height: 10),
                  Text(
                    AppStrings.noCompletedChallengesAvailable,
                    style: AppTextStyles.bodySemiBold
                        .copyWith(color: AppColors.neutral100),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    AppStrings.checkBackLaterForNewChallenege,
                    style: AppTextStyles.captionRegular
                        .copyWith(color: AppColors.neutral60),
                  ),
                ],
              ),
            ),
          );
  }
}
