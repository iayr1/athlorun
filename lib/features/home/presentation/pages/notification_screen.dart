import 'package:flutter/material.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/widgets/custom_appbar.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: AppStrings.notification,
        centerTitle: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Window.getHorizontalSize(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Today",
                style: AppTextStyles.heading5Bold.copyWith(
                  color: AppColors.neutral100,
                  fontSize: Window.getFontSize(18),
                ),
              ),
              SizedBox(height: Window.getVerticalSize(16)),
              const NotificationCard(
                icon: Icons.check_circle,
                iconColor: AppColors.secondaryGreen100,
                title: "Congratulations!",
                description: "You have completed the challenge today",
                time: "2m ago",
              ),
              const NotificationCard(
                icon: Icons.add_circle,
                iconColor: AppColors.primaryBlue70,
                title: "Great Work!",
                description: "You added a new activity successfully",
                time: "2m ago",
              ),
              SizedBox(height: Window.getVerticalSize(40)),

              // Yesterday's Notifications Section
              Text(
                "Yesterday",
                style: AppTextStyles.heading5Bold.copyWith(
                  color: AppColors.neutral100,
                  fontSize: Window.getFontSize(18),
                ),
              ),
              SizedBox(height: Window.getVerticalSize(16)),
              const NotificationCard(
                icon: Icons.cancel,
                iconColor: AppColors.secondaryPurple100,
                title: "Missed Schedule",
                description: "You missed your morning run schedule",
                time: "31 Jan",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String time;

  const NotificationCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Window.getVerticalSize(16)),
      padding: EdgeInsets.all(Window.getHorizontalSize(12)),
      decoration: BoxDecoration(
        color: AppColors.neutral10,
        borderRadius: BorderRadius.circular(Window.getHorizontalSize(16)),
        border: Border.all(color: AppColors.neutral30),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: SizedBox(
          width: Window.getHorizontalSize(48),
          height: Window.getHorizontalSize(48),
          child: Icon(
            icon,
            color: iconColor,
            size: Window.getFontSize(48),
          ),
        ),
        title: Text(
          title,
          style: AppTextStyles.subtitleBold.copyWith(
            color: AppColors.neutral100,
            fontSize: Window.getFontSize(16),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Window.getVerticalSize(4)),
            Text(
              description,
              style: AppTextStyles.bodyRegular.copyWith(
                color: AppColors.neutral50,
                fontSize: Window.getFontSize(14),
              ),
            ),
            SizedBox(height: Window.getVerticalSize(4)),
            Text(
              time,
              style: AppTextStyles.captionRegular.copyWith(
                color: AppColors.neutral50,
                fontSize: Window.getFontSize(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
