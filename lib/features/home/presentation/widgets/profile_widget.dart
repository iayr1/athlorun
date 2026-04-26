import 'package:flutter/material.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
            context, '/profile'); // Replace with AppRoutes.profile
      },
      child: Row(
        children: [
          // Profile Image
          Image.asset(
            "assets/profilephoto.png",
            height: Window.getVerticalSize(80), // Use responsive height
            fit: BoxFit.fitHeight,
          ),
          SizedBox(width: Window.getHorizontalSize(16)), // Responsive spacing

          // Profile Details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              Text(
                'Roberto Carlos',
                style: AppTextStyles.titleBold
                    .copyWith(color: AppColors.neutral100), // Custom text style
              ),
              // Skill Level
              Text(
                'Intermediate',
                style: AppTextStyles.subtitleRegular
                    .copyWith(color: AppColors.neutral70), // Custom text style
              ),
              SizedBox(height: Window.getVerticalSize(8)), // Responsive spacing

              // Progress Bar
              Container(
                width: Window.getHorizontalSize(200), // Responsive width
                height: Window.getVerticalSize(6), // Responsive height
                decoration: BoxDecoration(
                  color: AppColors.neutral20, // Custom background color
                  borderRadius: BorderRadius.circular(
                      Window.getRadiusSize(5)), // Responsive radius
                ),
                child: FractionallySizedBox(
                  widthFactor: 0.7, // Example progress (70%)
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors
                          .secondaryGreen100, // Custom progress bar color
                      borderRadius: BorderRadius.circular(
                          Window.getRadiusSize(5)), // Responsive radius
                    ),
                  ),
                ),
              ),
              SizedBox(height: Window.getVerticalSize(4)), // Responsive spacing

              // Level
              Text(
                'Level 27',
                style: AppTextStyles.captionRegular
                    .copyWith(color: AppColors.neutral100), // Custom text style
              ),
            ],
          ),
        ],
      ),
    );
  }
}
