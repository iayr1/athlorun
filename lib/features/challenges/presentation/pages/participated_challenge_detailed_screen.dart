import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/config/routes/routes.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/config/styles/app_textstyles.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/core/utils/windows.dart';
import 'package:athlorun/core/widgets/custom_appbar.dart';
import 'package:athlorun/features/challenges/data/models/response/get_participated_challenges_response_model.dart';
import 'package:athlorun/features/challenges/presentation/bloc/challenges_cubit.dart';
import 'package:athlorun/features/home/presentation/widgets/leaderboard_widget.dart';

class ParticipatedChallengeDetailedScreenWrapper extends StatelessWidget {
  final String challengeId;
  const ParticipatedChallengeDetailedScreenWrapper(
      {super.key, required this.challengeId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChallengesCubit>(),
      child: ParticipatedChallengeDetailedScreen(
        challengeId: challengeId,
      ),
    );
  }
}

class ParticipatedChallengeDetailedScreen extends StatefulWidget {
  final String challengeId;
  const ParticipatedChallengeDetailedScreen(
      {super.key, required this.challengeId});

  @override
  State<ParticipatedChallengeDetailedScreen> createState() =>
      _ChallengeDetailsScreenState();
}

class _ChallengeDetailsScreenState
    extends State<ParticipatedChallengeDetailedScreen> {
  late final ChallengesCubit _cubit;

  bool isParticipated = true;

  @override
  void initState() {
    _cubit = context.read<ChallengesCubit>();
    _cubit.getUserParticipatedChallenges(widget.challengeId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: customAppBar(
        backgroundColor: Colors.transparent,
        arrowColor: AppColors.neutral10,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: BlocBuilder<ChallengesCubit, ChallengesState>(
        builder: (context, state) {
          return state.maybeWhen(
            loadingParticipatedChallenges: () {
              return const ParticipatedChallengeDetailedScreenSkeleton();
            },
            loadedParticipatedChallenges: (challengesData) {
              final challengeList = challengesData.data;
              String formattedDate = Utils.formatChallengeDate(
                challengeList!.challenge!.startDate,
                challengeList.challenge!.endDate,
              );

              int daysLeft =
                  Utils.calculateDaysLeft(challengeList.challenge!.endDate);
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Image with Stack
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: CachedNetworkImage(
                            imageUrl: challengeList.challenge!.banner!,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          ),
                        ),
                        Positioned(
                          bottom: -40,
                          left: Window.getHorizontalSize(16),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(Window.getRadiusSize(8)),
                            child: CachedNetworkImage(
                              imageUrl: challengeList.challenge!.badge!,
                              width: Window.getHorizontalSize(100),
                              height: Window.getVerticalSize(100),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: Window.getVerticalSize(56)),

                    // Challenge Title and Countdown
                    Padding(
                      padding: Window.getSymmetricPadding(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: Window.getSymmetricPadding(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryPurple100,
                                borderRadius: BorderRadius.circular(
                                    Window.getRadiusSize(16)),
                              ),
                              child: Text(
                                '$daysLeft ${daysLeft == 1 ? "day" : "days"} Left',
                                style: AppTextStyles.bodyBold
                                    .copyWith(color: AppColors.neutral10),
                              ),
                            ),
                          ),
                          SizedBox(height: Window.getVerticalSize(8)),
                          Text(
                            challengeList.challenge!.title!,
                            style: AppTextStyles.heading4Bold
                                .copyWith(color: AppColors.neutral100),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Window.getVerticalSize(16)),

                    Padding(
                      padding: Window.getSymmetricPadding(horizontal: 16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                color: AppColors.primaryBlue100,
                              ),
                              SizedBox(
                                width: Window.getHorizontalSize(
                                  8,
                                ),
                              ),
                              Text(
                                formattedDate,
                                style: AppTextStyles.bodyRegular
                                    .copyWith(color: AppColors.neutral60),
                              ),
                            ],
                          ),
                          SizedBox(height: Window.getVerticalSize(4)),
                          Row(
                            children: [
                              const Icon(
                                Icons.flag,
                                color: AppColors.primaryBlue100,
                              ),
                              SizedBox(
                                width: Window.getHorizontalSize(
                                  8,
                                ),
                              ),
                              Text(
                                '${challengeList.challenge!.targetDescription}',
                                style: AppTextStyles.bodyRegular
                                    .copyWith(color: AppColors.neutral60),
                              ),
                            ],
                          ),
                          SizedBox(height: Window.getVerticalSize(4)),
                          Row(
                            children: [
                              const Icon(
                                Icons.wine_bar,
                                color: AppColors.primaryBlue100,
                              ),
                              SizedBox(
                                width: Window.getHorizontalSize(
                                  8,
                                ),
                              ),
                              Text(
                                "${challengeList.challenge!.reward}",
                                style: AppTextStyles.bodyRegular.copyWith(
                                  color: AppColors.neutral60,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Window.getVerticalSize(20)),

                    _buildProgressBar(challengeList),
                    SizedBox(height: Window.getVerticalSize(20)),

                    // Divider(height: Window.getVerticalSize(32), thickness: 1),

                    // Description Section
                    Padding(
                      padding: Window.getSymmetricPadding(horizontal: 16),
                      child: Text(
                        AppStrings.description,
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.neutral100),
                      ),
                    ),
                    Padding(
                      padding: Window.getSymmetricPadding(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        "${challengeList.challenge!.description}",
                        style: AppTextStyles.bodyRegular
                            .copyWith(color: AppColors.neutral60),
                      ),
                    ),
                    // Divider(height: Window.getVerticalSize(32), thickness: 1),
                    SizedBox(height: Window.getVerticalSize(20)),

                    // Qualifying Activities
                    Padding(
                      padding: Window.getSymmetricPadding(horizontal: 16),
                      child: Text(
                        AppStrings.qualifyingActivities,
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.neutral100),
                      ),
                    ),
                    SizedBox(height: Window.getVerticalSize(12)),

                    Padding(
                      padding: Window.getSymmetricPadding(
                          horizontal: 16, vertical: 8),
                      child: Wrap(
                        spacing: Window.getHorizontalSize(12),
                        runSpacing: Window.getVerticalSize(8),
                        children: [
                          ...challengeList.challenge!.qualifyingSports!
                              .map((activity) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.network(
                                  activity.icon!,
                                  color: AppColors.primaryBlue90,
                                  width: 20,
                                ),
                                SizedBox(width: Window.getHorizontalSize(8)),
                                Text(activity.name!),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),

                    // Divider(height: Window.getVerticalSize(32), thickness: 1),
                    SizedBox(height: Window.getVerticalSize(20)),

                    // Stats
                    Padding(
                      padding: Window.getSymmetricPadding(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section Header
                          Text(
                            'Your Overall Stats',
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: AppColors.neutral100),
                          ),
                          SizedBox(height: Window.getVerticalSize(16)),

                          // Stats Grid
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Window.getRadiusSize(8)),
                            ),
                            child: const Column(
                              children: [
                                // First Row
                                Row(
                                  children: [
                                    Expanded(
                                      child: StatItem(
                                        title: 'Distance',
                                        value: '5,2 km',
                                        borderRight: true,
                                      ),
                                    ),
                                    Expanded(
                                      child: StatItem(
                                        title: 'Moving Time',
                                        value: '7,89 km',
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  height: 1,
                                  color: AppColors.neutral30,
                                  thickness: 2,
                                ),

                                // Second Row
                                Row(
                                  children: [
                                    Expanded(
                                      child: StatItem(
                                        title: 'Elevation Gain',
                                        value: '30 m',
                                        borderRight: true,
                                      ),
                                    ),
                                    Expanded(
                                      child: StatItem(
                                        title: 'Elapsed Time',
                                        value: '42:12',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Divider(height: Window.getVerticalSize(32), thickness: 1),

                    // Leaderboard
                    Padding(
                      padding: Window.getSymmetricPadding(horizontal: 16),
                      child: const LeaderboardWidget(),
                    ),
                    SizedBox(height: Window.getVerticalSize(16)),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, AppRoutes.scoreListScreen);
                        },
                        child: Text(
                          'See All Leaderboard',
                          style: AppTextStyles.bodyBold
                              .copyWith(color: AppColors.primaryBlue90),
                        ),
                      ),
                    ),
                    // Divider(height: Window.getVerticalSize(32), thickness: 1),

                    // Join Challenge
                    Padding(
                      padding: Window.getSymmetricPadding(horizontal: 16),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                Window.getRadiusSize(100)),
                            child: CachedNetworkImage(
                              imageUrl: challengeList.challenge!.badge!,
                              width: Window.getHorizontalSize(30),
                              height: Window.getVerticalSize(30),
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: Window.getHorizontalSize(8)),
                          Text(
                            '${challengeList.challenge!.participantsCount} Participants',
                            style: AppTextStyles.bodyRegular
                                .copyWith(color: AppColors.neutral100),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.neutral10,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: AppColors.primaryBlue100),
                                borderRadius: BorderRadius.circular(
                                    Window.getRadiusSize(24)),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: AppColors.primaryBlue90,
                                ),
                                SizedBox(width: Window.getHorizontalSize(8)),
                                Text(
                                  AppStrings.alreadyjoined,
                                  style: AppTextStyles.bodyBold.copyWith(
                                      color: AppColors.primaryBlue100),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: Window.getVerticalSize(16)),
                  ],
                ),
              );
            },
            orElse: () {
              return Container();
            },
          );
        },
      ),
    );
  }

  Widget _buildProgressBar(Data challengeList) {
    final progress =
        (double.tryParse(challengeList.progress ?? '0') ?? 0.0) / 100;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Value
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Activities',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Text(
                "${(progress * 100).toStringAsFixed(1)} %",
                style: AppTextStyles.bodyRegular.copyWith(
                  color: AppColors.neutral60,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryBlue80,
              ),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final String title;
  final String value;
  final bool borderRight;
  final bool borderBottom;
  final EdgeInsetsGeometry? padding;

  const StatItem({
    required this.title,
    required this.value,
    this.borderRight = false,
    this.borderBottom = false,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: borderRight
              ? const BorderSide(color: AppColors.neutral30, width: 2)
              : BorderSide.none,
          bottom: borderBottom
              ? const BorderSide(color: AppColors.neutral30, width: 2)
              : BorderSide.none,
        ),
      ),
      padding: padding ?? Window.getSymmetricPadding(vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTextStyles.captionMedium
                .copyWith(color: AppColors.neutral100),
          ),
          SizedBox(height: Window.getVerticalSize(4)),
          Text(
            value,
            style:
                AppTextStyles.bodyRegular.copyWith(color: AppColors.neutral60),
          ),
        ],
      ),
    );
  }
}

class ParticipatedChallengeDetailedScreenSkeleton extends StatelessWidget {
  const ParticipatedChallengeDetailedScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const customAppBar(
        backgroundColor: Colors.transparent,
        arrowColor: AppColors.neutral10,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image with Badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  height: Window.getVerticalSize(200),
                  color: AppColors.neutral20,
                ),
                Positioned(
                  bottom: -40,
                  left: Window.getHorizontalSize(16),
                  child: Container(
                    width: Window.getHorizontalSize(100),
                    height: Window.getVerticalSize(100),
                    decoration: BoxDecoration(
                      color: AppColors.neutral30,
                      borderRadius:
                          BorderRadius.circular(Window.getRadiusSize(8)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Window.getVerticalSize(56)),

            // Title and Countdown
            Padding(
              padding: Window.getSymmetricPadding(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: Window.getHorizontalSize(120),
                      height: Window.getVerticalSize(24),
                      color: AppColors.neutral20,
                    ),
                  ),
                  SizedBox(height: Window.getVerticalSize(8)),
                  Container(
                    width: double.infinity,
                    height: Window.getVerticalSize(20),
                    color: AppColors.neutral20,
                  ),
                  SizedBox(height: Window.getVerticalSize(4)),
                  Container(
                    width: double.infinity,
                    height: Window.getVerticalSize(16),
                    color: AppColors.neutral20,
                  ),
                ],
              ),
            ),
            SizedBox(height: Window.getVerticalSize(16)),

            // Rewards
            Padding(
              padding: Window.getSymmetricPadding(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    width: Window.getHorizontalSize(24),
                    height: Window.getVerticalSize(24),
                    color: AppColors.neutral20,
                  ),
                  SizedBox(width: Window.getHorizontalSize(8)),
                  Container(
                    width: Window.getHorizontalSize(100),
                    height: Window.getVerticalSize(16),
                    color: AppColors.neutral20,
                  ),
                ],
              ),
            ),
            Divider(height: Window.getVerticalSize(32), thickness: 1),

            // Description Section
            Padding(
              padding: Window.getSymmetricPadding(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: Window.getHorizontalSize(120),
                    height: Window.getVerticalSize(20),
                    color: AppColors.neutral20,
                  ),
                  SizedBox(height: Window.getVerticalSize(8)),
                  Container(
                    width: double.infinity,
                    height: Window.getVerticalSize(48),
                    color: AppColors.neutral20,
                  ),
                ],
              ),
            ),
            Divider(height: Window.getVerticalSize(32), thickness: 1),

            // Qualifying Activities
            Padding(
              padding: Window.getSymmetricPadding(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: Window.getHorizontalSize(160),
                    height: Window.getVerticalSize(20),
                    color: AppColors.neutral20,
                  ),
                  SizedBox(height: Window.getVerticalSize(8)),
                  Wrap(
                    spacing: Window.getHorizontalSize(12),
                    runSpacing: Window.getVerticalSize(8),
                    children: List.generate(
                      3,
                      (index) => Container(
                        padding: Window.getSymmetricPadding(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.neutral20,
                          borderRadius:
                              BorderRadius.circular(Window.getRadiusSize(16)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: Window.getHorizontalSize(16),
                              height: Window.getVerticalSize(16),
                              color: AppColors.neutral30,
                            ),
                            SizedBox(width: Window.getHorizontalSize(8)),
                            Container(
                              width: Window.getHorizontalSize(60),
                              height: Window.getVerticalSize(14),
                              color: AppColors.neutral30,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: Window.getVerticalSize(32), thickness: 1),

            // Stats
            Padding(
              padding: Window.getSymmetricPadding(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: Window.getHorizontalSize(160),
                    height: Window.getVerticalSize(20),
                    color: AppColors.neutral20,
                  ),
                  SizedBox(height: Window.getVerticalSize(16)),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.neutral30, width: 1),
                      borderRadius:
                          BorderRadius.circular(Window.getRadiusSize(8)),
                    ),
                    child: Column(
                      children: List.generate(
                        2,
                        (rowIndex) => Column(
                          children: [
                            Row(
                              children: List.generate(
                                2,
                                (colIndex) => Expanded(
                                  child: Padding(
                                    padding: Window.getSymmetricPadding(
                                        vertical: 8, horizontal: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: Window.getHorizontalSize(80),
                                          height: Window.getVerticalSize(14),
                                          color: AppColors.neutral20,
                                        ),
                                        SizedBox(
                                            height: Window.getVerticalSize(4)),
                                        Container(
                                          width: Window.getHorizontalSize(60),
                                          height: Window.getVerticalSize(12),
                                          color: AppColors.neutral30,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (rowIndex == 0)
                              const Divider(
                                  height: 1, color: AppColors.neutral30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: Window.getVerticalSize(32), thickness: 1),

            // Join Challenge Button
            Padding(
              padding: Window.getSymmetricPadding(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    width: Window.getHorizontalSize(30),
                    height: Window.getVerticalSize(30),
                    color: AppColors.neutral30,
                  ),
                  const Spacer(),
                  Container(
                    width: Window.getHorizontalSize(120),
                    height: Window.getVerticalSize(40),
                    decoration: BoxDecoration(
                      color: AppColors.neutral20,
                      borderRadius:
                          BorderRadius.circular(Window.getRadiusSize(24)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Window.getVerticalSize(16)),
          ],
        ),
      ),
    );
  }
}
