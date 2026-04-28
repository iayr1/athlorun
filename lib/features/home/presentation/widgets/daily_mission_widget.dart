import 'package:flutter/material.dart';
import 'package:athlorun/config/routes/routes.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class DailyMissionWidget extends StatelessWidget {
  const DailyMissionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        _buildSectionHeader('Daily Mission', () {
          // Navigate to the Daily Mission screen
          Navigator.pushNamed(context, AppRoutes.dailymission);
        }),
        SizedBox(height: Window.getVerticalSize(10)), // Responsive spacing

        // Horizontal Scrollable Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(width: Window.getHorizontalSize(8)),
              // Responsive spacing
              _buildChip(
                "Walking",
                "assets/static/static1.png",
                AppColors.primaryBlue90, // Custom color
                0.7, // 70% progress
              ),
              _buildChip(
                "Climbing",
                "assets/static/static2.png",
                AppColors.secondaryGreen90, // Custom color
                0.5, // 50% progress
              ),
              _buildChip(
                "Diet Management",
                "assets/static/static3.png",
                AppColors.secondaryPurple90, // Custom color
                0.9, // 90% progress
              ),
            ],
          ),
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
          style: AppTextStyles.subtitleMedium
              .copyWith(color: AppColors.neutral100), // Custom text style
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            "See all",
            style: AppTextStyles.bodySemiBold
                .copyWith(color: AppColors.primaryBlue90), // Custom text style
          ),
        ),
      ],
    );
  }

  Widget _buildChip(
    String label,
    String imagePath,
    Color progressColor,
    double progressValue,
  ) {
    return Padding(
      padding: Window.getSymmetricPadding(vertical: 8),
      // Responsive vertical padding
      child: Container(
        width: Window.getHorizontalSize(140),
        // Responsive width
        height: Window.getVerticalSize(140),
        // Responsive height
        padding: Window.getPadding(all: 16),
        // Responsive padding
        margin: Window.getMargin(right: 10),
        // Responsive margin
        decoration: BoxDecoration(
            color: AppColors.neutral10,
            // Custom background color
            borderRadius: BorderRadius.circular(Window.getRadiusSize(16)),
            border: Border.all(
                color: AppColors.neutral20,
                width: 2,
                style: BorderStyle.solid)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Add a circular background color
                Container(
                  height: Window.getSize(38), // Responsive size
                  width: Window.getSize(38), // Responsive size
                  decoration: BoxDecoration(
                    color: progressColor.withValues(alpha: 0.2),
                    // Subtle background color
                    shape: BoxShape.circle,
                  ),
                ),
                // Circular progress indicator
                SizedBox(
                  height: Window.getSize(45), // Responsive size
                  width: Window.getSize(45), // Responsive size
                  child: CircularProgressIndicator(
                    strokeCap: StrokeCap.round,
                    value: progressValue, // Progress percentage (0.0 - 1.0)
                    strokeWidth: 4,
                    backgroundColor: AppColors.neutral20,
                    color: AppColors.primaryBlue100,
                  ),
                ),
                // Centered image
                Image.asset(
                  imagePath,
                  width: Window.getSize(20), // Responsive width
                  height: Window.getSize(20), // Responsive height
                  fit: BoxFit.cover,
                  color: AppColors.neutral100,
                ),
              ],
            ),
            const Spacer(),
            FittedBox(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyBold
                    .copyWith(color: AppColors.neutral100), // Custom text style
              ),
            ),
          ],
        ),
      ),
    );
  }
}
