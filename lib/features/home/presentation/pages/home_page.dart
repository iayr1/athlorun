import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:athlorun/config/images/app_images.dart';

// Clean widgets (no wrappers)
import '../widgets/search_bar_widget.dart';
import '../widgets/notification_widget.dart';
import '../widgets/profile_widget.dart';
import '../widgets/points_widget.dart';
import '../widgets/graph_widget.dart';
import '../widgets/statistics_widget.dart';
import '../widgets/daily_mission_widget.dart';
import '../widgets/badge_widget.dart';
import '../widgets/friends_widget.dart';
import '../widgets/leaderboard_widget.dart';

// Your cleaned widgets
import '../widgets/install_health_connect_widget.dart';
import '../widgets/suggested_challenge_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Top Bar
              Row(
                children: [
                  const Expanded(child: SearchBarWidget()),
                  const SizedBox(width: 10),
                  SvgPicture.asset(
                    AppImages.chat,
                    width: 24,
                  ),
                  const NotificationWidget(),
                ],
              ),

              const SizedBox(height: 16),

              /// Health Connect Banner
              const InstallHealthConnectWidget(),

              const SizedBox(height: 20),

              /// Profile
              const ProfileWidget(),

              const SizedBox(height: 10),

              /// Points + Graph
              const Row(
                children: [
                  PointsWidget(),
                  SizedBox(width: 70),
                  GraphWidget(),
                ],
              ),

              const SizedBox(height: 16),

              /// Statistics
              const StatisticsWidget(),

              const SizedBox(height: 10),

              /// Daily Mission
              const DailyMissionWidget(),

              const SizedBox(height: 10),

              /// Badges
              const BadgeWidget(),

              const SizedBox(height: 10),

              /// Friends
              const FriendsWidget(),

              const SizedBox(height: 20),

              /// Challenges
              const SuggestedChallengeWidget(),

              const SizedBox(height: 10),

              /// Leaderboard
              const LeaderboardWidget(),
            ],
          ),
        ),
      ),
    );
  }
}