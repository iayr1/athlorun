import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/config/images/app_images.dart';
import 'package:athlorun/features/home/presentation/bloc/home_page_cubit.dart';
import 'package:athlorun/features/home/presentation/widgets/install_health_connect_widget.dart';
import 'package:athlorun/features/home/presentation/widgets/suggested_challenge_widget.dart';
import '../widgets/notification_widget.dart';
import '../widgets/profile_widget.dart';

import 'package:athlorun/features/home/presentation/widgets/badge_widget.dart';
import 'package:athlorun/features/home/presentation/widgets/daily_mission_widget.dart';
import 'package:athlorun/features/home/presentation/widgets/friends_widget.dart';
import '../widgets/graph_widget.dart';
import '../widgets/leaderboard_widget.dart';
import '../widgets/points_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/statistics_widget.dart';

class HomePageWrapper extends StatelessWidget {
  const HomePageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomePageCubit>(),
      child: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late HomePageCubit _cubit;
  String? _fcmToken = "";
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<HomePageCubit>();
    _refreshHomePage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabController ??= TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _refreshHomePage() async {
    log("HomePage is being refreshed...");
    setState(() {});
    _cubit.getAuthData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomePageCubit, HomePageState>(
      listener: (context, state) {
        log("state : $state");
        state.maybeWhen(
          gotAuthData: (authData) {
            String deviceType = Platform.isAndroid ? "android" : "ios";
            _cubit.enableNotification(deviceType, authData.id, _fcmToken ?? "");
          },
          fetchedFcmToken: (fcmToken) {
            _fcmToken = fcmToken;
            _cubit.getAuthData();
          },
          requestedNotificationPermissiion: (settings) {
            _cubit.getFcmToken();
          },
          orElse: () {},
        );
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  SafeArea(
                    child: Row(
                      children: [
                        const SearchBarWidget(),
                        const SizedBox(width: 10),
                        SvgPicture.asset(
                          AppImages.chat,
                          width: 24,
                        ),
                        const NotificationWidget(),
                      ],
                    ),
                  ),
                  const InstallHealthConnectWidgetWrapper(),
                  const SizedBox(height: 20),

                  // Profile Section
                  const ProfileWidget(),
                  const SizedBox(height: 8),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left Section: Text and Points
                      PointsWidget(),
                      SizedBox(width: 70),
                      // Right Section: Graph
                      GraphWidget(),
                    ],
                  ),
                  // Stats Section
                  const InstallHealthConnectWidgetWrapper(),
                  const StatisticsWidget(),
                  const SizedBox(height: 10),

                  // Daily Mission Section
                  const DailyMissionWidget(),
                  const SizedBox(height: 10),

                  // Badges Section
                  const BadgeWidget(),
                  const SizedBox(height: 10),
                  const FriendsWidget(),
                  const SizedBox(height: 20),
                  const SuggestedChallengeWidgetWrapper(),
                  const SizedBox(height: 10),
                  const LeaderboardWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//
// class HomePageWrapper extends StatelessWidget {
//   const HomePageWrapper({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => sl<HomePageCubit>(),
//       child: const HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage>
//     with SingleTickerProviderStateMixin {
//   late HomePageCubit _cubit;
//   String? _fcmToken = "";
//   TabController? _tabController;
//
//   @override
//   void initState() {
//     super.comitState();
//     _cubit = context.read<HomePageCubit>();
//     _cubit.requesNotificationPermissiion();
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _tabController ??= TabController(length: 3, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _tabController?.dispose();
//     super.dispose();
//   }
//
//   Future<void> _refreshHomePage() async {
//     log("HomePage is being refreshed...");
//     setState(() {});
//     _cubit.getAuthData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<HomePageCubit, HomePageState>(
//       listener: (context, state) {
//         log("state : $state");
//         state.maybeWhen(
//           gotAuthData: (authData) {
//             String deviceType = Platform.isAndroid ? "android" : "ios";
//             _cubit.enableNotification(deviceType, authData.id, _fcmToken ?? "");
//           },
//           fetchedFcmToken: (fcmToken) {
//             _fcmToken = fcmToken;
//             _cubit.getAuthData();
//           },
//           requestedNotificationPermissiion: (settings) {
//             _cubit.getFcmToken();
//           },
//           orElse: () {},
//         );
//       },
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Stack(
//           children: [
//             Container(
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     AppColors.neutral10,
//                     AppColors.neutral10,
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//             ),
//             SafeArea(
//               child: LiquidPullToRefresh(
//                 onRefresh: _refreshHomePage,
//                 color: AppColors.primaryBlue90,
//                 backgroundColor: AppColors.neutral30,
//                 height: 100,
//                 animSpeedFactor: 1.5,
//                 showChildOpacityTransition: true,
//                 child: const SingleChildScrollView(
//                   physics: AlwaysScrollableScrollPhysics(),
//                   padding: EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           ProfileWidget(),
//                           Spacer(),
//                           RewardWidget(),
//                           SizedBox(width: 10),
//                           NotificationWidget(),
//                         ],
//                       ),
//                       InstallHealthConnectWidgetWrapper(),
//                       StepCountWidgetWrapper(),
//                       SizedBox(height: 20),
//                       SuggestedChallengeWidgetWrapper(),
//                       SizedBox(height: 100),
//                       KeepWalkingWidget(),
//                       SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
