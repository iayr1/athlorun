import 'package:flutter/material.dart';
import 'package:athlorun/config/routes/routes.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class ChallengeCard extends StatelessWidget {
  final String title;
  final String description;
  final Color color;

  const ChallengeCard({
    Key? key,
    required this.title,
    required this.description,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.challengePosterScreen);
      },
      child: Container(
        width: Window.getHorizontalSize(300), // Responsive width
        margin: Window.getMargin(right: 16), // Responsive margin
        padding: Window.getPadding(all: 16), // Responsive padding
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(
              Window.getRadiusSize(12)), // Responsive radius
          boxShadow: [
            BoxShadow(
              color: AppColors.neutral100.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.titleBold.copyWith(
                color: AppColors.neutral10, // White text color
              ),
            ),
            SizedBox(height: Window.getVerticalSize(8)), // Responsive spacing
            Text(
              description,
              style: AppTextStyles.subtitleRegular.copyWith(
                color: AppColors.neutral20, // Slightly dimmed white color
                fontSize: Window.getFontSize(20), // Responsive font size
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Handle join challenge action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.neutral10, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      Window.getRadiusSize(8), // Responsive radius
                    ),
                  ),
                  elevation: 0, // Flat button style
                  padding: Window.getSymmetricPadding(
                      horizontal: 16, vertical: 8), // Responsive padding
                ),
                child: Text(
                  'Join Challenge',
                  style: AppTextStyles.captionBold.copyWith(
                    color: AppColors.neutral100, // White text color
                    fontSize: Window.getFontSize(12), // Smaller font size
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
