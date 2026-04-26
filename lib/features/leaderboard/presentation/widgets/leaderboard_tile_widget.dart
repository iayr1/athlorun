import 'package:flutter/material.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class LeaderboardTileWidget extends StatelessWidget {
  final int position;
  final String name;
  final String distance;
  final String change;

  const LeaderboardTileWidget({
    super.key,
    required this.position,
    required this.name,
    required this.distance,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: Window.getSymmetricPadding(horizontal: 16), // Responsive padding
      leading: SizedBox(
        width: Window.getHorizontalSize(80), // Responsive width for leading content
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Align items vertically
          children: [
            SizedBox(
              width: Window.getSize(30), // Responsive width for position
              child: Text(
                '$position',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyBold.copyWith(color: AppColors.neutral100),
              ),
            ),
            SizedBox(width: Window.getHorizontalSize(8)), // Responsive spacing
            CircleAvatar(
              radius: Window.getSize(20), // Responsive avatar radius
              backgroundImage: const AssetImage('assets/profile/profile1.png'), // Replace with your asset path
            ),
          ],
        ),
      ),
      title: Text(
        name,
        style: AppTextStyles.bodyBold.copyWith(color: AppColors.neutral100), // Custom text style
      ),
      subtitle: Text(
        '$distance km',
        style: AppTextStyles.captionRegular.copyWith(color: AppColors.neutral60), // Custom text style
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            change,
            style: AppTextStyles.bodySemiBold.copyWith(
              color: change == '-'
                  ? AppColors.neutral60
                  : (change.contains('-') ? AppColors.secondaryPurple100 : AppColors.secondaryGreen100),
            ),
          ),
          if (change != '-')
            Icon(
              change.contains('-') ? Icons.arrow_drop_down : Icons.arrow_drop_up,
              color: change.contains('-') ? AppColors.secondaryPurple100 : AppColors.secondaryGreen100,
              size: Window.getSize(16), // Responsive icon size
            ),
        ],
      ),
    );
  }
}
