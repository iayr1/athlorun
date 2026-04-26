import 'package:flutter/material.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class PointsWidget extends StatelessWidget {
  const PointsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: SizedBox(
        height: Window.getVerticalSize(100), // Responsive height
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                SizedBox(
                    width: Window.getHorizontalSize(10)), // Responsive spacing
                Text(
                  "Total",
                  style: AppTextStyles.subtitleSemiBold.copyWith(
                    color: AppColors.neutral50, // Custom color
                  ),
                ),
              ],
            ),
            SizedBox(height: Window.getVerticalSize(8)), // Responsive spacing
            Row(
              children: [
                SizedBox(
                    width: Window.getHorizontalSize(10)), // Responsive spacing
                Text(
                  "230",
                  style: AppTextStyles.heading3Bold.copyWith(
                    color: AppColors.neutral100, // Custom color
                  ),
                ),
                SizedBox(
                    width: Window.getHorizontalSize(2)), // Responsive spacing

                Text(
                  "/1,000 Pts",
                  style: AppTextStyles.bodyRegular.copyWith(
                    color: AppColors.neutral60, // Custom color
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
