import 'package:flutter/material.dart';

import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';
import '../widgets/leaderboard_list_all_time_widget.dart';
import '../widgets/leaderboard_list_month_widget.dart';
import '../widgets/leaderboard_list_widget.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.neutral10, // Custom background color
            elevation: 0,
            title: Text(
              'Leaderboard',
              style: AppTextStyles.heading5Bold.copyWith(color: AppColors.neutral100), // Custom text style
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: Window.getHorizontalSize(16)), // Responsive padding
                child: Icon(
                  Icons.search,
                  color: AppColors.neutral100, // Custom icon color
                  size: Window.getSize(24), // Responsive icon size
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(Window.getVerticalSize(50)), // Responsive height
              child: TabBar(
                indicatorColor: AppColors.primaryBlue100, // Custom indicator color
                labelColor: AppColors.neutral100, // Active tab color
                unselectedLabelColor: AppColors.neutral60, // Inactive tab color
                labelStyle: AppTextStyles.bodyBold, // Custom text style
                unselectedLabelStyle: AppTextStyles.bodyRegular, // Custom text style
                tabs: const [
                  Tab(text: 'Today'),
                  Tab(text: 'Month'),
                  Tab(text: 'All Time'),
                ],
              ),
            ),
          ),
          body: const TabBarView(
            children: [
              LeaderboardListWidget(),
              LeaderboardListMonthWidget(),
              LeaderboardListAllTimeWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
