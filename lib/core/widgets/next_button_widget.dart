import 'package:flutter/material.dart';
import '../../../../../config/styles/app_colors.dart';
import '../../../../../config/styles/app_textstyles.dart';
import '../utils/windows.dart';

class NextButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isEnabled;
  final String text;

  const NextButtonWidget({
    required this.onPressed,
    this.isEnabled = true,
    super.key,
    this.text = "Next",
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Window.getHorizontalSize(150),
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isEnabled ? AppColors.primaryBlue100 : AppColors.neutral30,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Window.getRadiusSize(30)),
          ),
          padding: Window.getSymmetricPadding(
            horizontal: 35,
            vertical: 15,
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.subtitleSemiBold.copyWith(
            color: AppColors.neutral10,
            fontSize: Window.getFontSize(16),
          ),
        ),
      ),
    );
  }
}
