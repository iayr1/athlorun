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
import 'package:athlorun/core/widgets/custom_action_button.dart';
import 'package:athlorun/features/challenges/data/models/response/get_challenge_response_model.dart';
import 'package:athlorun/features/challenges/presentation/bloc/challenges_cubit.dart';
import 'package:athlorun/features/settings/presentation/pages/notification_setting_screen.dart';

class ChallengePosterScreenWrapper extends StatelessWidget {
  final GetChallengeResponseDataModel challengeList;
  const ChallengePosterScreenWrapper({super.key, required this.challengeList});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChallengesCubit>(),
      child: ChallengePosterScreen(
        challengeList: challengeList,
      ),
    );
  }
}

class ChallengePosterScreen extends StatefulWidget {
  final GetChallengeResponseDataModel challengeList;
  const ChallengePosterScreen({super.key, required this.challengeList});

  @override
  State<ChallengePosterScreen> createState() => _ChallengePosterScreenState();
}

class _ChallengePosterScreenState extends State<ChallengePosterScreen>
    with SingleTickerProviderStateMixin {
  late final ChallengesCubit _cubit;
  // late AnimationController _controller;
  // late Animation<Offset> _animation;

  @override
  void initState() {
    _cubit = context.read<ChallengesCubit>();
    // _controller = AnimationController(
    //   duration: const Duration(seconds: 1),
    //   vsync: this,
    // )..repeat(reverse: true);

    // _animation = Tween<Offset>(
    //   begin: const Offset(0, 0),
    //   end: const Offset(0, -10),
    // ).animate(
    //   CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    // );
    super.initState();
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = Utils.formatChallengeDate(
      widget.challengeList.startDate,
      widget.challengeList.endDate,
    );

    int daysLeft = Utils.calculateDaysLeft(widget.challengeList.endDate);
    String displayText;
    if (daysLeft == 0) {
      displayText = 'Last day';
    } else if (daysLeft > 0) {
      displayText = '$daysLeft days left';
    } else {
      displayText = 'Expired';
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: widget.challengeList.banner!,
              fit: BoxFit.cover,
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.chevron_left,
                          size: 35,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Challenge Icon and Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Challenge Icon
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(Window.getRadiusSize(8)),
                        child: CachedNetworkImage(
                          imageUrl: widget.challengeList.badge!,
                          width: Window.getHorizontalSize(100),
                          height: Window.getVerticalSize(100),
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      // Title
                      Text(
                        widget.challengeList.title!.to,
                        style: AppTextStyles.bodyBold.copyWith(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.sports_cricket,
                            color: AppColors.neutral10,
                            size: 18,
                          ),
                          SizedBox(width: Window.getHorizontalSize(8)),
                          Text(
                            widget.challengeList.description!,
                            style: AppTextStyles.subtitleRegular.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Date and Time Left
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              color: Colors.white, size: 16),
                          SizedBox(width: Window.getHorizontalSize(8)),
                          Text(
                            formattedDate,
                            style: AppTextStyles.bodyRegular.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            displayText,
                            style: AppTextStyles.bodyBold.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      // Join Challenge Button
                      BlocConsumer<ChallengesCubit, ChallengesState>(
                        builder: (context, state) {
                          return Center(
                            child: CustomActionButton(
                              name: AppStrings.seeMoreDetails,
                              isFormFilled: true,
                              onTap: (startLoading, stopLoading, btnState) {
                                Navigator.pushNamed(
                                    context, AppRoutes.challengeDetailScreen,
                                    arguments: widget.challengeList);
                              },
                            ),

                            // ElevatedButton(
                            //   onPressed: widget.challengeList.isParticipated!
                            //       ? null
                            //       : () {
                            //           _cubit.participateInTheChallenges(
                            //               widget.challengeList.id!);
                            //         },
                            //   style: ElevatedButton.styleFrom(
                            //     backgroundColor: Colors.blue,
                            //     padding: const EdgeInsets.symmetric(
                            //         horizontal: 120, vertical: 16),
                            //     shape: RoundedRectangleBorder(
                            //       side: widget.challengeList.isParticipated!
                            //           ? const BorderSide(
                            //               color: AppColors.primaryBlue100)
                            //           : BorderSide.none,
                            //       borderRadius: BorderRadius.circular(30),
                            //     ),
                            //   ),
                            //   child: Text(
                            //     widget.challengeList.isParticipated!
                            //         ? AppStrings.alreadyjoined
                            //         : AppStrings.joinChallenge,
                            //     style: AppTextStyles.bodyRegular.copyWith(
                            //       color: Colors.white,
                            //       fontSize: 16,
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //   ),
                            // ),
                          );
                        },
                        listener: (context, state) {
                          state.maybeWhen(
                            participatingInChallenge: () {},
                            participatedInChallenge:
                                (participateChallengeData) {
                              setState(() {
                                widget.challengeList.isParticipated = true;
                              });
                            },
                            participatingInChallengeError: (error) {
                              Utils.showCustomDialog(
                                  context, AppStrings.error, error);
                            },
                            orElse: () {},
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),

                // Swipe for Details with Animation
                // Center(
                //   child: GestureDetector(
                //     onVerticalDragEnd: (details) {
                //       if (details.primaryVelocity != null &&
                //           details.primaryVelocity! < 0) {
                //         Navigator.pushNamed(
                //             context, AppRoutes.challengeDetailScreen,
                //             arguments: widget.challengeList);
                //       }
                //     },
                //     child: Column(
                //       children: [
                //         AnimatedBuilder(
                //           animation: _animation,
                //           builder: (context, child) {
                //             return Transform.translate(
                //               offset: _animation.value,
                //               child: const Icon(
                //                 Icons.keyboard_arrow_up,
                //                 color: Colors.white,
                //                 size: 32,
                //               ),
                //             );
                //           },
                //         ),
                //         const Text(
                //           AppStrings.swipeForDetails,
                //           style: TextStyle(
                //             color: Colors.white70,
                //             fontSize: 14,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
