import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/config/images/app_images.dart';
import 'package:athlorun/config/routes/routes.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/features/challenges/data/models/response/get_user_participated_challenges_response_model.dart';
import 'package:athlorun/features/challenges/presentation/bloc/challenges_cubit.dart';
import 'package:athlorun/features/challenges/presentation/widgets/challenge_shimmer.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';
import '../../../dashboard/presentation/pages/dashboard_screen.dart';

class SuggestedChallengeWidgetWrapper extends StatelessWidget {
  const SuggestedChallengeWidgetWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChallengesCubit>(),
      child: const SuggestedChallengeWidget(),
    );
  }
}

class SuggestedChallengeWidget extends StatefulWidget {
  const SuggestedChallengeWidget({super.key});

  @override
  State<SuggestedChallengeWidget> createState() =>
      _SuggestedChallengeWidgetState();
}

class _SuggestedChallengeWidgetState extends State<SuggestedChallengeWidget> {
  late final ChallengesCubit _cubit;
  late List<ChallengeElement> challengesList = [];

  @override
  void initState() {
    _cubit = context.read<ChallengesCubit>();
    _cubit.getParticipatedChallenges("participated");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChallengesCubit, ChallengesState>(
      listener: (context, state) {
        state.maybeWhen(
            leavingChallenge: () {},
            leftChallenge: (leaveResponseModel) {
              final responseMsg = leaveResponseModel.message;
              Utils.showCustomDialog(
                context,
                responseMsg.toString(),
                AppStrings.dontStopNow,
              );
              _cubit.getParticipatedChallenges("participated");
            },
            leaveChallengeError: (error) {
              Utils.showCustomDialog(context, AppStrings.error, error);
            },
            orElse: () {});
      },
      builder: (context, state) {
        return state.maybeWhen(
          gettingParticipatedChallenges: () {
            return Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: Window.getVerticalSize(250),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) => const LeaveCardShimmer(),
                  ),
                ));
          },
          gotParticipatedChallenges: (challengesData) {
            challengesList = challengesData.data!.challenges ?? [];
            if (challengesList.isEmpty) {
              return _buildEmptyState();
            }

            return _buildChallengesList();
          },
          getParticipatedChallengesError: (error) {
            return _buildEmptyState();
          },
          orElse: () {
            return _buildEmptyState();
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events,
                size: 60, color: AppColors.neutral60),
            const SizedBox(height: 10),
            Text(AppStrings.noParticipatedChallengesAvailable,
                style: AppTextStyles.bodySemiBold
                    .copyWith(color: AppColors.neutral100)),
            const SizedBox(height: 5),
            Text(AppStrings.checkBackLaterForNewChallenege,
                style: AppTextStyles.captionRegular
                    .copyWith(color: AppColors.neutral60)),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          AppStrings.challenges,
          () {
            final dashboardState =
                context.findAncestorStateOfType<DashboardScreenState>();
            dashboardState?.updateIndex(3);
          },
        ),
        SizedBox(
          height: Window.getVerticalSize(10),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: challengesList.map((challengesListData) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.partcipatedChallengeDetailScreen,
                    arguments: challengesListData.challenge!.id.toString(),
                  );
                },
                child: _buildChallengeCard(
                  challengesListData.challenge!.title.toString(),
                  "${Utils.formatToDDMMMYYYY(challengesListData.challenge!.startDate!)} to ${Utils.formatToDDMMMYYYY(challengesListData.challenge!.endDate!)}",
                  AppColors.primaryBlue100,
                  challengesListData.isCompleted!,
                  challengesListData.challenge!.badge.toString(),
                  challengesListData.challenge!.targetValue.toString(),
                  challengesListData.challenge!.id.toString(),
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget _buildSectionHeader(
    String title,
    VoidCallback onPressed,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.subtitleMedium
              .copyWith(color: AppColors.neutral100),
        ),
        GestureDetector(
          onTap: () {
            onPressed();
          },
          child: Text(
            AppStrings.sellAll,
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.primaryBlue100),
          ),
        )
      ],
    );
  }

  Widget _buildChallengeCard(
    String title,
    String dateRange,
    Color buttonColor,
    bool isJoined,
    String imagePath,
    String badgeText,
    String challengeId,
  ) {
    return Padding(
      padding: Window.getSymmetricPadding(vertical: 8),
      child: Container(
        width: Window.getHorizontalSize(150),
        height: Window.getVerticalSize(230),
        margin: Window.getMargin(right: 12),
        decoration: BoxDecoration(
            color: AppColors.neutral10,
            borderRadius: BorderRadius.circular(Window.getRadiusSize(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                offset: const Offset(4, 4),
                blurRadius: 12,
                spreadRadius: 2,
              ),
              // BoxShadow(
              //   color: Colors.white.withOpacity(0.2),
              //   offset: const Offset(-2, -2),
              //   blurRadius: 6,
              //   spreadRadius: 1,
              // ),
            ],
            // gradient: LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   colors: [
            //     AppColors.neutral10.withOpacity(0.9),
            //     AppColors.neutral10,
            //     AppColors.neutral10.withOpacity(0.8),
            //   ],
            // ),
            border: Border.all(color: AppColors.neutral30)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container with Badge
            Stack(
              children: [
                Padding(
                  padding: Window.getPadding(all: 8),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(Window.getRadiusSize(8)),
                    child: CachedNetworkImage(
                      imageUrl: imagePath,
                      height: Window.getVerticalSize(70),
                      width: Window.getVerticalSize(70),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // if (badgeText.isNotEmpty)
                //   Positioned(
                //     left: 9,
                //     bottom: 8,
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.only(
                //         bottomLeft: Radius.circular(Window.getRadiusSize(9)),
                //         bottomRight: Radius.circular(Window.getRadiusSize(9)),
                //       ),
                //       child: Container(
                //         width: Window.getHorizontalSize(61),
                //         padding: Window.getSymmetricPadding(
                //             horizontal: 8, vertical: 4),
                //         color: AppColors.primaryBlue100,
                //         child: Center(
                //           child: Text(
                //             badgeText,
                //             style: AppTextStyles.captionBold
                //                 .copyWith(color: AppColors.neutral10),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
              ],
            ),
            SizedBox(height: Window.getVerticalSize(8)),

            // Challenge Title
            Padding(
              padding: Window.getSymmetricPadding(horizontal: 8),
              child: Text(
                title,
                style: AppTextStyles.bodyBold
                    .copyWith(color: AppColors.neutral100),
              ),
            ),
            SizedBox(height: Window.getVerticalSize(8)),

            // Date Range
            Padding(
              padding: Window.getSymmetricPadding(horizontal: 8),
              child: Text(
                dateRange,
                style: AppTextStyles.captionRegular
                    .copyWith(color: AppColors.neutral60),
              ),
            ),
            const Spacer(),

            // Join Button
            Padding(
              padding: Window.getPadding(all: 8),
              child: GestureDetector(
                onTap: () {
                  Utils.showLeaveChallengeDialog(
                      context: context,
                      onConfirm: () {
                        _cubit.leaveParticipatedChallenges(challengeId);
                      });
                },
                child: Container(
                  width: double.infinity,
                  height: Window.getVerticalSize(40),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue40,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primaryBlue90,
                    ),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: AppColors.primaryBlue90,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
