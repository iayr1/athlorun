import 'package:flutter/material.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/widgets/custom_appbar.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class ScoreListScreen extends StatelessWidget {
  // Mock Data for leaderboard
  final List<Map<String, dynamic>> leaderboardData = [
    {"name": "Jerome Bell", "distance": 5000.0, "rank": 1, "change": null},
    {"name": "Michaels", "distance": 4891.0, "rank": 2, "change": null},
    {"name": "Lexi Wilson", "distance": 4820.0, "rank": 3, "change": null},
    {"name": "Elanor Pena", "distance": 10.9, "rank": 1, "change": 3},
    {"name": "Devon Lane", "distance": 9.5, "rank": 2, "change": -1},
    {"name": "Jenny Wilson", "distance": 9.2, "rank": 3, "change": 0},
    {"name": "Robert Bell", "distance": 9.1, "rank": 4, "change": -1},
    {"name": "Arlene", "distance": 8.9, "rank": 5, "change": 2},
    {"name": "Hitesh", "distance": 8.8, "rank": 6, "change": 4},
    {"name": "Shivam", "distance": 8.7, "rank": 7, "change": 5},
  ];

  ScoreListScreen({super.key});

  Color getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700);
      case 2:
        return const Color(0xFF33D68B);
      case 3:
        return const Color(0xFF7B61FF);
      default:
        return AppColors.secondaryPurple50;
    }
  }

  @override
  Widget build(BuildContext context) {
    Window().adaptDeviceScreenSize(view: View.of(context));
    return Scaffold(
      appBar: customAppBar(
        title: AppStrings.finalResult,
        onBackPressed: () => Navigator.pop(context),
        backgroundColor: AppColors.primaryBlue100,
        centerTitle: true,
        arrowColor: AppColors.neutral10,
      ),
      body: Stack(
        children: [
          // Fullscreen background image
          Positioned.fill(
            child: Image.asset(
              'assets/badges/scoredetails.png',
              fit: BoxFit.cover,
            ),
          ),
          // Main content
          Column(
            children: [
              _buildTopThreeSection(),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.neutral10,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: _buildLeaderboardList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopThreeSection() {
    return Padding(
      padding: Window.getPadding(all: 16.0),
      child: Column(
        children: [
          Text(
            "January Running",
            style: AppTextStyles.heading4Regular
                .copyWith(color: AppColors.neutral10),
          ),
          Text(
            "Challenge",
            style: AppTextStyles.heading4Regular
                .copyWith(color: AppColors.neutral10),
          ),
          SizedBox(height: Window.getVerticalSize(20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTopThreeAvatar(
                leaderboardData[1]["name"],
                leaderboardData[1]["distance"],
                leaderboardData[1]["rank"],
                "assets/profile/profile1.png",
              ), // 2nd place
              _buildTopThreeAvatar(
                leaderboardData[0]["name"],
                leaderboardData[0]["distance"],
                leaderboardData[0]["rank"],
                "assets/profile/profile2.png",
              ), // 1st place
              _buildTopThreeAvatar(
                leaderboardData[2]["name"],
                leaderboardData[2]["distance"],
                leaderboardData[2]["rank"],
                "assets/profile/profile3.png",
              ), // 3rd place
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopThreeAvatar(
      String name, double distance, int rank, String imagePath) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: rank == 1 ? Window.getSize(60) : Window.getSize(35),
              child: CircleAvatar(
                radius: rank == 1 ? Window.getSize(55) : Window.getSize(30),
                backgroundImage: AssetImage(imagePath),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 10,
              left: 10,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: Window.getSize(10),
                child: CircleAvatar(
                  radius: Window.getSize(7),
                  backgroundColor: getRankColor(rank),
                  child: Text(
                    "$rank",
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: Window.getVerticalSize(8)),
        Text(
          name,
          style:
              AppTextStyles.bodySemiBold.copyWith(color: AppColors.neutral10),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          "${distance.toStringAsFixed(1)} km",
          style:
              AppTextStyles.captionRegular.copyWith(color: AppColors.neutral20),
        ),
      ],
    );
  }

  Widget _buildLeaderboardList() {
    return Padding(
      padding: Window.getPadding(top: 20),
      child: ListView.builder(
        itemCount: leaderboardData.length - 3,
        itemBuilder: (context, index) {
          final item = leaderboardData[index + 3];
          final isCurrentUser =
              item["name"] == "Arlene"; // <- highlight condition

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: isCurrentUser
                ? BoxDecoration(
                    color: Colors.white, // Highlighted background
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.neutral40,
                        blurRadius: 40,
                        offset: Offset(0, 2),
                      ),
                    ],
                  )
                : null,
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Rank Number
                  Text(
                    "${item["rank"]}",
                    style: const TextStyle(
                      color: AppColors.neutral100,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: Window.getHorizontalSize(20)),

                  // Profile Image
                  CircleAvatar(
                    radius: 25,
                    backgroundImage:
                        AssetImage("assets/profile/profile${index + 1}.png"),
                  ),
                ],
              ),
              title: Text(
                item["name"],
                style: AppTextStyles.subtitleBold
                    .copyWith(color: AppColors.neutral100),
              ),
              subtitle: Text(
                "${item["distance"]} km",
                style: AppTextStyles.bodyRegular
                    .copyWith(color: AppColors.neutral60),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item["change"] != null && item["change"] != 0) ...[
                    Text(
                      "${item["change"]}",
                      style: TextStyle(
                        color: item["change"]! > 0
                            ? AppColors.secondaryGreen100
                            : AppColors.secondaryPurple100,
                      ),
                    ),
                    Icon(
                      item["change"]! > 0
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: item["change"]! > 0
                          ? AppColors.secondaryGreen100
                          : AppColors.secondaryPurple100,
                      size: Window.getSize(16),
                    ),
                  ]
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
