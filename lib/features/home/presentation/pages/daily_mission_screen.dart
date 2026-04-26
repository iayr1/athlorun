import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/config/images/app_images.dart';
import 'package:athlorun/config/routes/routes.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/widgets/custom_action_button.dart';
import 'package:athlorun/core/widgets/custom_appbar.dart';
import 'package:athlorun/features/home/presentation/bloc/home_page_cubit.dart';
import 'package:athlorun/features/home/presentation/pages/coins_credit_screen.dart';
import 'package:athlorun/features/home/presentation/pages/coins_redeem_screen.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class DailyMissionScreenWrapper extends StatelessWidget {
  const DailyMissionScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomePageCubit>(),
      child: const DailyMissionScreen(),
    );
  }
}

class DailyMissionScreen extends StatefulWidget {
  const DailyMissionScreen({super.key});

  @override
  State<DailyMissionScreen> createState() => _DailyMissionScreenState();
}

class _DailyMissionScreenState extends State<DailyMissionScreen> {
  late HomePageCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<HomePageCubit>();
    _cubit.getUserWalletData();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> transactions = [
      {
        "icon": AppImages.walkingSvg,
        "title": "100K Run Reward Earned",
        "date": "10 Jan 2023",
        "time": "10:30 AM",
        "points": "+8",
        "isCredit": true
      },
      {
        "icon": AppImages.walkingSvg,
        "title": "Reward Claimed",
        "date": "6 Jan 2023",
        "time": "2:00 PM",
        "points": "-5",
        "isCredit": false
      },
      {
        "icon": AppImages.walkingSvg,
        "title": "100K Run Reward Earned",
        "date": "29 Dec 2023",
        "time": "3:15 PM",
        "points": "+3",
        "isCredit": true
      },
      {
        "icon": AppImages.walkingSvg,
        "title": "Purchase Reward Claimed",
        "date": "19 Dec 2023",
        "time": "5:45 PM",
        "points": "-8",
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
                  // Total Points Section
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

                  // List of Points Transactions
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                        horizontal: Window.getHorizontalSize(16)),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];

                      return GestureDetector(
                        onTap: () {
                          final route = transaction["points"].startsWith('+')
                              ? MaterialPageRoute(
                                  builder: (context) =>
                                      const CoinsCreditScreen(),
                                  settings: RouteSettings(arguments: {
                                    "icon": transaction["icon"],
                                    "title": transaction["title"],
                                    "date": transaction["date"],
                                    "time": transaction["time"],
                                    "points": transaction["points"],
                                  }),
                                )
                              : MaterialPageRoute(
                                  builder: (context) =>
                                      const CoinRedeemScreen(),
                                  settings: RouteSettings(arguments: {
                                    "icon": transaction["icon"],
                                    "title": transaction["title"],
                                    "date": transaction["date"],
                                    "time": transaction["time"],
                                    "points": transaction["points"],
                                  }),
                                );

                          Navigator.push(context, route);
                        },
                        child: PointTransactionCard(
                          title: transaction["title"],
                          date: transaction["date"],
                          points: transaction["points"],
                          isCredit: transaction["isCredit"],
                          icon: transaction["icon"],
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
          onTap: (startLoading, stopLoading, state) {
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
          backgroundColor: AppColors.primaryBlue40.withOpacity(0.9),
          child: SvgPicture.asset(icon, color: AppColors.neutral90, width: 24),
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
            color: Colors.black.withOpacity(0.1),
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
            color: Colors.black.withOpacity(0.1),
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
              color: iconColor.withOpacity(0.2),
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
