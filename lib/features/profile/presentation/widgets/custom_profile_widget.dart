import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/config/images/app_images.dart';
import 'package:athlorun/config/routes/routes.dart';
import 'package:athlorun/core/global_store/data/models/user_data_response_model.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:athlorun/features/profile/presentation/skeleton/profile_screen_skeleton.dart';
import 'package:athlorun/features/settings/presentation/pages/notification_setting_screen.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class CustomProfileWidgetWrapper extends StatelessWidget {
  const CustomProfileWidgetWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (context) => sl<ProfileCubit>(),
      child: const CustomProfileWidget(),
    );
  }
}

class CustomProfileWidget extends StatefulWidget {
  const CustomProfileWidget({super.key});

  @override
  State<CustomProfileWidget> createState() => _CustomProfileWidgetState();
}

class _CustomProfileWidgetState extends State<CustomProfileWidget> {
  bool _isExpanded = false;
  UserData? userData;

  late final ProfileCubit _cubit;

  @override
  void initState() {
    _cubit = context.read<ProfileCubit>();
    _cubit.getUserProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        state.maybeWhen(
          gettingUserProfile: () {},
          gotUserProfile: (authData) {
            userData = authData.data;
          },
          getUserProfileError: (error) {},
          orElse: () {},
        );
      },
      builder: (context, state) {
        return state.maybeWhen(
          gettingUserProfile: () {
            return const CustomProfileWidgetSkeleton();
          },
          gotUserProfile: (authData) {
            return Column(
              children: [
                Row(
                  children: [
                    userData != null
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: userData!.profilePhoto,
                              height: Window.getVerticalSize(80),
                              width: Window.getVerticalSize(80),
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            AppImages.profileImagePlaceHolder,
                            height: Window.getVerticalSize(80),
                            width: Window.getVerticalSize(80),
                            fit: BoxFit.cover,
                          ),
                    SizedBox(width: Window.getHorizontalSize(16)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                userData?.name ?? AppStrings.guestUser,
                                style: AppTextStyles.titleBold
                                    .copyWith(color: AppColors.neutral100),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.pushNamed(
                                      context, AppRoutes.profileUpdateScreen,
                                      arguments: userData);
                                  if (result == true) {
                                    // Re-fetch user profile when user returns
                                    _cubit.getUserProfileData();
                                  }
                                },
                                child: const Icon(
                                  Icons.edit,
                                  color: AppColors.primaryBlue70,
                                  size: 20,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.settingsPage);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    Icons.settings,
                                    color: AppColors.neutral80,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            userData?.exerciseLevel.toString().toCapitalized ??
                                "N/A",
                            style: AppTextStyles.subtitleRegular
                                .copyWith(color: AppColors.neutral80),
                          ),
                          SizedBox(height: Window.getVerticalSize(8)),
                          // Container(
                          //   width: Window.getHorizontalSize(200),
                          //   height: Window.getVerticalSize(8),
                          //   decoration: BoxDecoration(
                          //     color: AppColors.neutral30,
                          //     borderRadius: BorderRadius.circular(
                          //         Window.getRadiusSize(5)), // Responsive radius
                          //   ),
                          //   child: FractionallySizedBox(
                          //     widthFactor: 0.7, // Example progress (70%)
                          //     alignment: Alignment.centerLeft,
                          //     child: Container(
                          //       decoration: BoxDecoration(
                          //         color: AppColors
                          //             .secondaryGreen100, // Custom progress bar color
                          //         borderRadius: BorderRadius.circular(
                          //             Window.getRadiusSize(5)), // Responsive radius
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //     height:
                          //         Window.getVerticalSize(4)), // Responsive spacing

                          // // Level
                          // Text(
                          //   'Level 27',
                          //   style: AppTextStyles.captionRegular.copyWith(
                          //       color: AppColors.neutral70), // Custom text style
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Theme(
                  data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    minTileHeight: 2,
                    tilePadding: EdgeInsets.zero,
                    trailing: const SizedBox.shrink(),
                    collapsedIconColor: AppColors.neutral80,
                    iconColor: AppColors.neutral80,
                    onExpansionChanged: (bool expanded) {
                      setState(
                        () {
                          _isExpanded = expanded;
                        },
                      );
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.viewMoreDetails,
                          style: AppTextStyles.captionRegular.copyWith(
                            color: AppColors.primaryBlue100,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          _isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: Colors.grey[800],
                        ),
                      ],
                    ),
                    childrenPadding: EdgeInsets.zero,
                    children: userData != null
                        ? [
                            ListTile(
                              minTileHeight: 10,
                              title: Text(AppStrings.registerEmailLabel,
                                  style: AppTextStyles.bodyBold
                                      .copyWith(color: AppColors.neutral100)),
                              subtitle: Text(userData?.email ?? 'N/A',
                                  style: AppTextStyles.captionRegular
                                      .copyWith(color: AppColors.neutral60)),
                            ),
                            ListTile(
                              minTileHeight: 10,
                              title: Text(AppStrings.phoneNumber,
                                  style: AppTextStyles.bodyBold
                                      .copyWith(color: AppColors.neutral100)),
                              subtitle: Text(userData?.phoneNumber ?? 'N/A',
                                  style: AppTextStyles.captionRegular
                                      .copyWith(color: AppColors.neutral60)),
                            ),
                            ListTile(
                              minTileHeight: 10,
                              title: Text(AppStrings.height,
                                  style: AppTextStyles.bodyBold
                                      .copyWith(color: AppColors.neutral100)),
                              subtitle: Text("${userData?.height ?? 'N/A'} Cm",
                                  style: AppTextStyles.captionRegular
                                      .copyWith(color: AppColors.neutral60)),
                            ),
                            ListTile(
                              minTileHeight: 10,
                              title: Text(AppStrings.weight,
                                  style: AppTextStyles.bodyBold
                                      .copyWith(color: AppColors.neutral100)),
                              subtitle: Text("${userData?.weight ?? 'N/A'} Kg",
                                  style: AppTextStyles.captionRegular
                                      .copyWith(color: AppColors.neutral60)),
                            ),
                            ListTile(
                              minTileHeight: 10,
                              title: Text(AppStrings.gender,
                                  style: AppTextStyles.bodyBold
                                      .copyWith(color: AppColors.neutral100)),
                              subtitle: Text(
                                  (userData?.gender.toString() ?? 'N/A')
                                      .toCapitalized,
                                  style: AppTextStyles.captionRegular
                                      .copyWith(color: AppColors.neutral60)),
                            ),
                            ListTile(
                              minTileHeight: 10,
                              title: Text(AppStrings.age,
                                  style: AppTextStyles.bodyBold
                                      .copyWith(color: AppColors.neutral100)),
                              subtitle: Text(userData?.age.toString() ?? 'N/A',
                                  style: AppTextStyles.captionRegular
                                      .copyWith(color: AppColors.neutral60)),
                            ),
                            ListTile(
                              minTileHeight: 10,
                              title: Text(AppStrings.target,
                                  style: AppTextStyles.bodyBold
                                      .copyWith(color: AppColors.neutral100)),
                              subtitle: Text(userData?.target ?? 'N/A',
                                  style: AppTextStyles.captionRegular
                                      .copyWith(color: AppColors.neutral60)),
                            ),
                          ]
                        : [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                AppStrings.noUserDataAvailable,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                  ),
                )
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     _buildProfileStatistic(
                //       context,
                //       label: 'Challenge',
                //       value: '32',
                //       isChallenge: true,
                //     ),
                //     _buildProfileStatistic(
                //       context,
                //       label: 'Following',
                //       value: '1,891',
                //       tabIndex: 0,
                //     ),
                //     _buildProfileStatistic(
                //       context,
                //       label: 'Followers',
                //       value: '11.8K',
                //       tabIndex: 1,
                //     ),

                //   ],
                // ),
              ],
            );
          },
          orElse: () {
            return Container();
          },
        );
      },
    );
  }
}

// Widget _buildProfileStatistic(
//   BuildContext context, {
//   required String label,
//   required String value,
//   int? tabIndex,
//   bool isChallenge = false,
// }) {
//   return GestureDetector(
//     onTap: () {
//       if (isChallenge) {
//         // Navigate to the challenge screen by updating the dashboard index
//         final dashboardState =
//             context.findAncestorStateOfType<DashboardScreenState>();
//         if (dashboardState != null) {
//           dashboardState.updateIndex(3); // Index for ChallengesPage
//         }
//       } else if (tabIndex != null) {
//         // Navigate with tab index for following or followers
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => FriendsScreen(initialTabIndex: tabIndex),
//           ),
//         );
//       }
//     },
//     child: Column(
//       children: [
//         Text(
//           label,
//           style: const TextStyle(color: Colors.grey),
//         ),
//         Text(
//           value,
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//         ),
//       ],
//     ),
//   );
// }
