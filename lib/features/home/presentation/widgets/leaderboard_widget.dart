import 'package:flutter/material.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';
import '../../../dashboard/presentation/pages/dashboard_screen.dart';

class LeaderboardWidget extends StatelessWidget {
  const LeaderboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Example leaderboard data
    final List<Map<String, dynamic>> leaderboard = [
      {
        'name': 'Alice Johnson',
        'distance': '25 km',
        'avatar': 'assets/profile/profile1.png'
      },
      {
        'name': 'Bob Smith',
        'distance': '20 km',
        'avatar': 'assets/profile/profile2.png'
      },
      {
        'name': 'Catherine Brown',
        'distance': '18 km',
        'avatar': 'assets/profile/profile3.png'
      },
      {
        'name': 'Daniel Clark',
        'distance': '15 km',
        'avatar': 'assets/profile/profile4.png'
      },
      {
        'name': 'Evelyn Garcia',
        'distance': '12 km',
        'avatar': 'assets/profile/profile5.png'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        _buildSectionHeader('Leaderboard', () {
          final dashboardState =
              context.findAncestorStateOfType<DashboardScreenState>();
          if (dashboardState != null) {
            dashboardState.updateIndex(1); // Index for ChallengesPage
          }
        }),

        // Leaderboard List
        ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: leaderboard.length,
          itemBuilder: (context, index) {
            return _buildLeaderboardItem(
              rank: index + 1,
              name: leaderboard[index]['name'],
              distance: leaderboard[index]['distance'],
              avatarPath: leaderboard[index]['avatar'],
            );
          },
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral100),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            "See all",
            style: AppTextStyles.bodySemiBold
                .copyWith(color: AppColors.primaryBlue90),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardItem({
    required int rank,
    required String name,
    required String distance,
    required String avatarPath,
  }) {
    return ListTile(
      leading: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: Window.getSize(25), // Responsive avatar size
            backgroundImage: AssetImage(avatarPath),
          ),
          // Rank Badge
          Positioned(
            bottom: -4,
            right: -4,
            child: Container(
              padding: Window.getPadding(all: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue100,
                shape: BoxShape.circle,
              ),
              child: Text(
                rank.toString(),
                style: AppTextStyles.captionBold
                    .copyWith(color: AppColors.neutral10),
              ),
            ),
          ),
        ],
      ),
      title: Text(
        name,
        style: AppTextStyles.bodyBold.copyWith(color: AppColors.neutral100),
      ),
      subtitle: Text(
        distance,
        style:
            AppTextStyles.captionRegular.copyWith(color: AppColors.neutral60),
      ),
      trailing: Icon(
        rank == 1 ? Icons.arrow_drop_up : Icons.arrow_drop_down_outlined,
        color: rank == 1
            ? AppColors.secondaryGreen100
            : AppColors.secondaryPurple100,
        size: Window.getSize(24), // Responsive icon size
      ),
    );
  }
}
