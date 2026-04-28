import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:athlorun/config/images/app_images.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/features/challenges/presentation/pages/challenges_page.dart';
import 'package:athlorun/features/events/presentation/pages/event_page.dart';
import 'package:athlorun/features/leaderboard/presentation/pages/leaderboard_page.dart';
import 'package:athlorun/features/profile/presentation/pages/profile_page.dart';
import 'package:athlorun/features/track/presentation/pages/track_page.dart';
import '../../../../core/utils/windows.dart';
import '../../../home/presentation/pages/home_page.dart';

import '../../../../config/styles/app_colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePageWrapper(),
    const LeaderboardPage(),
    const TrackPage(),
    const ChallengesPageWrapper(),
    // const PodcastHomeScreen(),
    const EventPageWrapper(),
  ];

  void updateIndex(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        padding: Window.getSymmetricPadding(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.neutral10,
          border: const Border(
            top: BorderSide(color: AppColors.neutral30, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_outlined, Icons.home, AppStrings.home, 0),
            // _buildNavItem(Icons.emoji_events, "Leaderboard", 1),
            // _buildNavItem(Icons.track_changes, "Track", 2),
            _buildNavItem(Icons.emoji_events_outlined, Icons.emoji_events,
                AppStrings.leaderBoard, 1),
            _buildNavItem(
                AppImages.track, AppImages.track, AppStrings.track, 2),
            // _buildNavItem(AppImages.challengesBottomIcon, "Challenges", 1),
            // _buildNavItem(AppImages.podcastBottomIcon, "Podcast", 3),
            // _buildNavItem(AppImages.profileBottomIcon, "Profile", 4),
            _buildNavItem(AppImages.golfCourse, AppImages.golfCourse,
                AppStrings.challenges, 3),
            _buildNavItem(Icons.event, Icons.event, AppStrings.events, 4),
            _buildNavItem(
                Icons.person_outline, Icons.person, AppStrings.profile, 5),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    dynamic icon,
    dynamic filledIcon,
    String label,
    int index,
  ) {
    final bool isSelected = _currentIndex == index;

    Widget iconWidget;
    if (icon is String && filledIcon is String) {
      // SVG path strings passed
      iconWidget = SvgPicture.asset(
        isSelected ? filledIcon : icon,
        width: 24,
        height: 24,
        color: isSelected ? Colors.blue : Colors.black,
      );
    } else {
      // IconData passed
      iconWidget = Icon(
        isSelected ? filledIcon : icon,
        color: isSelected ? Colors.blue : Colors.black,
      );
    }

    return GestureDetector(
      onTap: () {
        updateIndex(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.black,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
