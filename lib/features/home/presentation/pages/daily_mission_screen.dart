import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:athlorun/config/images/app_images.dart';
import 'package:athlorun/config/routes/routes.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/widgets/custom_action_button.dart';
import 'package:athlorun/core/widgets/custom_appbar.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class DailyMissionScreen extends StatelessWidget {
  const DailyMissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// Dummy UI data
    final transactions = [
      {
        "icon": AppImages.walkingSvg,
        "title": "100K Run Reward Earned",
        "date": "10 Jan 2023",
        "points": "+8",
        "isCredit": true
      },
      {
        "icon": AppImages.walkingSvg,
        "title": "Reward Claimed",
        "date": "6 Jan 2023",
        "points": "-5",
        "isCredit": false
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.neutral20,
      appBar: customAppBar(
        backgroundColor: AppColors.neutral20,
        title: AppStrings.dailyMission,
        centerTitle: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Total Points
                  const TotalPointsContainer(),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Window.getHorizontalSize(16),
                    ),
                    child: Text(
                      AppStrings.historyPoint,
                      style: AppTextStyles.bodySemiBold.copyWith(
                        color: AppColors.neutral100,
                        fontSize: Window.getFontSize(18),
                      ),
                    ),
                  ),

                  SizedBox(height: Window.getVerticalSize(16)),

                  /// Transactions
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                        horizontal: Window.getHorizontalSize(16)),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final item = transactions[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            item["isCredit"] == true
                                ? AppRoutes.coinsCreditScreen
                                : AppRoutes.coinsRedeemScreen,
                          );
                        },
                        child: const PointTransactionCard(
                          title: "Morning Run Reward",
                          date: "12 March 2024",
                          points: "+10",
                          isCredit: true,
                          icon: AppImages.walkingSvg,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: Window.getPadding(left: 16, right: 16, bottom: 16),
        child: CustomActionButton(
          onTap: (s, st, state) {
            Navigator.pushNamed(context, AppRoutes.rewardclaim);
          },
          name: AppStrings.claimReward,
          isFormFilled: true,
        ),
      ),
    );
  }
}

class PointTransactionCard extends StatelessWidget {
  final String icon;
  final String title;
  final String date;
  final String points;
  final bool isCredit;

  const PointTransactionCard({
    super.key,
    required this.title,
    required this.date,
    required this.points,
    required this.isCredit,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Window.getVerticalSize(12)),
      padding: EdgeInsets.symmetric(
        horizontal: Window.getHorizontalSize(12),
        vertical: Window.getVerticalSize(8),
      ),
      decoration: BoxDecoration(
        color: AppColors.neutral10,
        borderRadius: BorderRadius.circular(Window.getHorizontalSize(10)),
        border: Border.all(color: AppColors.neutral30),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: Window.getHorizontalSize(24),
          backgroundColor: AppColors.primaryBlue40.withValues(alpha: 0.9),
          child: SvgPicture.asset(
            icon,
            colorFilter: const ColorFilter.mode(
              AppColors.neutral90,
              BlendMode.srcIn,
            ),
            width: 24,
          ),
        ),
        title: Text(
          title,
          style: AppTextStyles.subtitleBold.copyWith(
            color: AppColors.neutral100,
            fontSize: Window.getFontSize(16),
          ),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date,
              style: AppTextStyles.bodyRegular.copyWith(
                color: AppColors.neutral50,
                fontSize: Window.getFontSize(14),
              ),
            ),
            Row(
              children: [
                SvgPicture.asset(AppImages.coinSvg, width: 18, height: 18),
                SizedBox(width: Window.getHorizontalSize(4)),
                Text(
                  "$points pts",
                  style: AppTextStyles.captionSemiBold.copyWith(
                    color: isCredit
                        ? AppColors.secondaryGreen100
                        : AppColors.primaryBlue60,
                    fontSize: Window.getFontSize(16),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class StepCoinContainer extends StatelessWidget {
  const StepCoinContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: EdgeInsets.symmetric(
        horizontal: Window.getHorizontalSize(16),
        vertical: Window.getVerticalSize(20),
      ),
      padding: EdgeInsets.all(Window.getHorizontalSize(16)),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue100,
        borderRadius: BorderRadius.circular(Window.getHorizontalSize(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: Window.getVerticalSize(20)),
          Text(
            "Total Step Coins",
            style: AppTextStyles.subtitleRegular.copyWith(
              color: AppColors.neutral10,
              fontSize: Window.getFontSize(14),
            ),
          ),
          SizedBox(height: Window.getVerticalSize(20)),
          Text(
            "230 / 1,000 Coins",
            style: AppTextStyles.heading2Bold.copyWith(
              color: AppColors.neutral10,
              fontSize: Window.getFontSize(28),
            ),
          ),
          SizedBox(height: Window.getVerticalSize(15)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: Window.getVerticalSize(8)),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue90,
              borderRadius: BorderRadius.circular(Window.getHorizontalSize(8)),
            ),
            child: Text(
              "Latest Update: 31 Jan 2024",
              textAlign: TextAlign.center,
              style: AppTextStyles.captionRegular.copyWith(
                color: AppColors.neutral10,
                fontSize: Window.getFontSize(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// TotalPointsContainer Integrated
class TotalPointsContainer extends StatelessWidget {
  const TotalPointsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: EdgeInsets.symmetric(
        horizontal: Window.getHorizontalSize(16),
        vertical: Window.getVerticalSize(20),
      ),
      // padding: EdgeInsets.all(Window.getHorizontalSize(16)),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue90,
        borderRadius: BorderRadius.circular(Window.getHorizontalSize(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 4,
            left: 4,
            child: Icon(
              Icons.star,
              size: Window.getHorizontalSize(50),
              color: AppColors.primaryBlue100,
            ),
          ),
          Positioned(
            top: 30,
            left: 60,
            child: Icon(
              Icons.star,
              size: Window.getHorizontalSize(25),
              color: AppColors.primaryBlue100,
            ),
          ),
          Positioned(
            top: 40,
            right: 12,
            child: Icon(
              Icons.star,
              size: Window.getHorizontalSize(40),
              color: AppColors.primaryBlue100,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Window.getVerticalSize(20)),
              Text(
                "Total Point",
                style: AppTextStyles.subtitleRegular.copyWith(
                  color: AppColors.neutral10,
                  fontSize: Window.getFontSize(14),
                ),
              ),
              SizedBox(height: Window.getVerticalSize(20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "230",
                    style: AppTextStyles.heading2Bold.copyWith(
                      color: AppColors.neutral10,
                    ),
                  ),
                  Text(
                    "/1,000 Pts",
                    style: AppTextStyles.heading5Bold.copyWith(
                      color: AppColors.neutral10,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Window.getVerticalSize(30)),
              Container(
                width: double.infinity,
                padding:
                    EdgeInsets.symmetric(vertical: Window.getVerticalSize(8)),
                decoration: const BoxDecoration(
                  color: AppColors.primaryBlue100,
                ),
                child: Text(
                  "Latest Update: 31 Jan 2024",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.captionRegular.copyWith(
                    color: AppColors.neutral10,
                    fontSize: Window.getFontSize(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MissionCard extends StatelessWidget {
  final String title;
  final String date;
  final String points;
  final IconData icon;
  final Color iconColor;

  const MissionCard({
    super.key,
    required this.title,
    required this.date,
    required this.points,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Window.getVerticalSize(12)),
      padding: EdgeInsets.all(Window.getHorizontalSize(16)),
      decoration: BoxDecoration(
        color: AppColors.neutral10,
        borderRadius: BorderRadius.circular(Window.getHorizontalSize(10)),
        border: Border.all(color: AppColors.neutral30),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: Window.getHorizontalSize(40),
            height: Window.getHorizontalSize(40),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(Window.getHorizontalSize(20)),
            ),
            child: Icon(icon, color: iconColor, size: Window.getFontSize(24)),
          ),
          SizedBox(width: Window.getHorizontalSize(16)),

          // Mission Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.subtitleBold.copyWith(
                    color: AppColors.neutral100,
                    fontSize: Window.getFontSize(16),
                  ),
                ),
                SizedBox(height: Window.getVerticalSize(4)),
                Text(
                  date,
                  style: AppTextStyles.bodyRegular.copyWith(
                    color: AppColors.neutral50,
                    fontSize: Window.getFontSize(14),
                  ),
                ),
              ],
            ),
          ),

          // Points with Coin Icon
          Row(
            children: [
              Icon(
                Icons
                    .monetization_on, // Use a coin-like icon or an image of a coin
                color: Colors.amber,
                size: Window.getFontSize(16),
              ),
              SizedBox(width: Window.getHorizontalSize(4)),
              Text(
                points,
                style: AppTextStyles.heading5Bold.copyWith(
                  color: AppColors.secondaryPurple100,
                  fontSize: Window.getFontSize(16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
