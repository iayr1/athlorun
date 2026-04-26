import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/config/routes/routes.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/core/widgets/custom_appbar.dart';
import 'package:athlorun/features/challenges/data/models/response/get_challenge_response_model.dart';
import 'package:athlorun/features/challenges/presentation/bloc/challenges_cubit.dart';
import 'package:athlorun/features/home/presentation/widgets/leaderboard_widget.dart';
import 'package:athlorun/features/settings/presentation/pages/notification_setting_screen.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class ChallengeDetailsScreenWrapper extends StatelessWidget {
  final GetChallengeResponseDataModel challengeDetails;
  const ChallengeDetailsScreenWrapper(
      {super.key, required this.challengeDetails});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChallengesCubit>(),
      child: ChallengeDetailsScreen(
        challengeDetails: challengeDetails,
      ),
    );
  }
}

class ChallengeDetailsScreen extends StatefulWidget {
  final GetChallengeResponseDataModel challengeDetails;
  const ChallengeDetailsScreen({super.key, required this.challengeDetails});

  @override
  State<ChallengeDetailsScreen> createState() => _ChallengeDetailsScreenState();
}

class _ChallengeDetailsScreenState extends State<ChallengeDetailsScreen> {
  late final ChallengesCubit _cubit;

  @override
  void initState() {
    _cubit = context.read<ChallengesCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = Utils.formatChallengeDate(
      widget.challengeDetails.startDate,
      widget.challengeDetails.endDate,
    );

    int daysLeft = Utils.calculateDaysLeft(widget.challengeDetails.endDate);
    String displayText;
    if (daysLeft == 0) {
      displayText = 'Last day';
    } else if (daysLeft > 0) {
      displayText = '$daysLeft days left';
    } else {
      displayText = 'Expired';
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: customAppBar(
        backgroundColor: Colors.transparent,
        arrowColor: AppColors.neutral10,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
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
                    imageUrl: widget.challengeDetails.banner!,
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
                      imageUrl: widget.challengeDetails.badge!,
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
                        borderRadius:
                            BorderRadius.circular(Window.getRadiusSize(16)),
                      ),
                      child: Text(
                        displayText,
                        style: AppTextStyles.bodyBold
                            .copyWith(color: AppColors.neutral10),
                      ),
                    ),
                  ),
                  SizedBox(height: Window.getVerticalSize(8)),
                  Text(
                    widget.challengeDetails.title!.toCapitalized,
                    style: AppTextStyles.heading4Bold
                        .copyWith(color: AppColors.neutral100),
                  ),
                ],
              ),
            ),
            SizedBox(height: Window.getVerticalSize(16)),

            // Rewards
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
                        '${widget.challengeDetails.targetDescription}',
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
                        "${widget.challengeDetails.reward}",
                        style: AppTextStyles.bodyRegular.copyWith(
                          color: AppColors.neutral60,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Divider(height: Window.getVerticalSize(32), thickness: 1),
            SizedBox(height: Window.getVerticalSize(20)),

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
              padding: Window.getSymmetricPadding(horizontal: 16, vertical: 8),
              child: Text(
                "${widget.challengeDetails.description}",
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
              padding: Window.getSymmetricPadding(horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: Window.getHorizontalSize(12),
                runSpacing: Window.getVerticalSize(8),
                children: [
                  ...widget.challengeDetails.qualifyingSports!.map((activity) {
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
            SizedBox(height: Window.getVerticalSize(20)),

            // Divider(height: Window.getVerticalSize(32), thickness: 1),

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
                      borderRadius:
                          BorderRadius.circular(Window.getRadiusSize(8)),
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
            SizedBox(height: Window.getVerticalSize(20)),

            // Leaderboard
            Padding(
              padding: Window.getSymmetricPadding(horizontal: 16),
              child: const LeaderboardWidget(),
            ),
            SizedBox(height: Window.getVerticalSize(16)),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.scoreListScreen);
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
                    borderRadius:
                        BorderRadius.circular(Window.getRadiusSize(100)),
                    child: CachedNetworkImage(
                      imageUrl: widget.challengeDetails.badge!,
                      width: Window.getHorizontalSize(30),
                      height: Window.getVerticalSize(30),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: Window.getHorizontalSize(8)),
                  Text(
                    '${widget.challengeDetails.participantsCount} Participants',
                    style: AppTextStyles.bodyRegular
                        .copyWith(color: AppColors.neutral100),
                  ),
                  const Spacer(),
                  BlocConsumer<ChallengesCubit, ChallengesState>(
                    listener: (context, state) {
                      state.maybeWhen(
                        participatingInChallenge: () {},
                        participatedInChallenge: (participateChallengeData) {
                          setState(() {
                            widget.challengeDetails.isParticipated = true;
                          });

                          Navigator.pushNamed(
                              context, AppRoutes.congratulationScreen,
                              arguments:
                                  widget.challengeDetails.title.toString());
                        },
                        participatingInChallengeError: (error) {
                          Utils.showCustomDialog(
                              context, AppStrings.error, error);
                        },
                        orElse: () {},
                      );
                    },
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: widget.challengeDetails.isParticipated!
                            ? null
                            : () {
                                _cubit.participateInTheChallenges(
                                    widget.challengeDetails.id!);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              widget.challengeDetails.isParticipated!
                                  ? AppColors.neutral10
                                  : AppColors.primaryBlue100,
                          disabledBackgroundColor: AppColors.neutral10,
                          shape: RoundedRectangleBorder(
                            side: widget.challengeDetails.isParticipated!
                                ? const BorderSide(
                                    color: AppColors.primaryBlue100)
                                : BorderSide.none,
                            borderRadius:
                                BorderRadius.circular(Window.getRadiusSize(24)),
                          ),
                        ),
                        child: Row(
                          children: [
                            widget.challengeDetails.isParticipated!
                                ? const Icon(
                                    Icons.check,
                                    color: AppColors.primaryBlue90,
                                  )
                                : const SizedBox.shrink(),
                            SizedBox(width: Window.getHorizontalSize(8)),
                            Text(
                              widget.challengeDetails.isParticipated!
                                  ? AppStrings.alreadyjoined
                                  : AppStrings.joinChallenge,
                              style: AppTextStyles.bodyBold.copyWith(
                                color: widget.challengeDetails.isParticipated!
                                    ? AppColors.primaryBlue100
                                    : AppColors.neutral10,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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
