import 'package:flutter/material.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import '../../../../config/routes/routes.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class DashboardTabBar extends StatelessWidget {
  final TabController tabController;

  const DashboardTabBar({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    Window().adaptDeviceScreenSize(
        view: View.of(context)); // Initialize responsive utilities

    return Container(
      margin: Window.getSymmetricPadding(horizontal: 0, vertical: 16),
      padding: Window.getSymmetricPadding(vertical: 0),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue20, // Centralized white background
        borderRadius: BorderRadius.circular(Window.getRadiusSize(32)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Make it horizontally scrollable
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTab(
              context,
              text: AppStrings.track,
              index: 0,
            ),
            _buildTab(
              context,
              text: AppStrings.events,
              index: 1,
            ),
            _buildTab(
              context,
              text: AppStrings.podcast,
              index: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required String text,
    required int index,
  }) {
    final bool isSelected = index == tabController.index;

    return GestureDetector(
      onTap: () {
        tabController.animateTo(index); // Smoothly animates tab change
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, AppRoutes.dashboardScreen);
            break;
          case 1:
            Navigator.pushReplacementNamed(
                context, AppRoutes.dashboardScreenEvent);
            break;
          case 2:
            Navigator.pushReplacementNamed(
                context, AppRoutes.dashboardScreenPodcast);
            break;
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: Window.getSymmetricPadding(horizontal: 0),
        padding: Window.getSymmetricPadding(vertical: 12, horizontal: 0),
        width: Window.getHorizontalSize(110),
        height: Window.getVerticalSize(50),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue100 : Colors.transparent,
          borderRadius: BorderRadius.circular(Window.getRadiusSize(24)),
        ),
        child: Center(
          child: Text(
            text,
            style: isSelected
                ? AppTextStyles.bodyRegular.copyWith(color: AppColors.neutral10)
                : AppTextStyles.bodyRegular
                    .copyWith(color: AppColors.neutral100),
          ),
        ),
      ),
    );
  }
}
