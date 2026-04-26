import 'package:flutter/material.dart';
import '../../../../../config/styles/app_colors.dart';
import '../../../../../config/styles/app_textstyles.dart';
import '../utils/windows.dart';

class BackButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const BackButtonWidget({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Window.getHorizontalSize(150),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neutral20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Window.getRadiusSize(30)),
          ),
          padding: Window.getSymmetricPadding(
            horizontal: 35,
            vertical: 15,
          ),
        ),
        child: Text(
          "Back",
          style: AppTextStyles.subtitleSemiBold.copyWith(
            color: AppColors.neutral70,
            fontSize: Window.getFontSize(16),
          ),
        ),
      ),
    );
  }
}
