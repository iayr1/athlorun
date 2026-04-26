import 'package:flutter/material.dart';
import '../../../../../config/styles/app_colors.dart';
import '../../../../../config/styles/app_textstyles.dart';
import '../utils/windows.dart';

class ProgressBarWidget extends StatelessWidget {
  final double currentScreen;
  final double totalScreens;
  final String stepText;

  const ProgressBarWidget({
    required this.currentScreen,
    required this.stepText,
    required this.totalScreens,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = currentScreen / totalScreens;

    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.neutral30,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue100),
            minHeight: Window.getVerticalSize(8),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        SizedBox(width: Window.getHorizontalSize(10)),
        Text(
          stepText,
          style: AppTextStyles.bodyRegular.copyWith(
            fontSize: Window.getFontSize(14),
            color: AppColors.neutral100,
          ),
        ),
      ],
    );
  }
}
