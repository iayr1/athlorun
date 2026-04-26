import 'package:argon_buttons_flutter_fix/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../../config/styles/app_colors.dart';
import '../../../../../config/styles/app_textstyles.dart';
import '../utils/windows.dart';

class CustomActionButton extends StatelessWidget {
  final Function(
    Function startLoading,
    Function stopLoading,
    ButtonState btnState,
  ) onTap;
  final String name;
  final bool showAction;
  final bool isFormFilled; // Used to toggle enabled/disabled state
  final bool isOutlined;
  final Widget? leading;
  final bool isWhiteThemed;
  final bool shouldAnimate;
  final bool? isLoaded;
  final bool isError;
  final double? buttonWidth;
  final double? buttonHeight;

  const CustomActionButton({
    super.key,
    required this.onTap,
    required this.name,
    required this.isFormFilled,
    this.isError = false,
    this.showAction = true,
    this.isOutlined = false,
    this.leading,
    this.isWhiteThemed = false,
    this.shouldAnimate = true,
    this.isLoaded,
    this.buttonWidth,
    this.buttonHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isFormFilled
            ? AppColors.primaryBlue100 // Enabled state
            : AppColors.primaryBlue70, // Disabled state
        borderRadius:
            BorderRadius.circular(Window.getRadiusSize(30)), // Rounded edges
      ),
      child: ArgonButton(
        height: buttonHeight ?? Window.getVerticalSize(50),
        width: buttonWidth ??
            Window.getHorizontalSize(MediaQuery.of(context).size.width),
        loader: Container(
          height: Window.getVerticalSize(44),
          width: Window.getHorizontalSize(44),
          padding: const EdgeInsets.all(1),
          child: SpinKitDoubleBounce(
            color: isWhiteThemed || isOutlined
                ? AppColors.primaryBlue100
                : AppColors.neutral10,
          ),
        ),
        onTap: onTap,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) leading!,
              if (leading != null)
                SizedBox(width: Window.getHorizontalSize(10)),
              Text(
                name,
                style: AppTextStyles.subtitleSemiBold.copyWith(
                  color: AppColors.neutral10,
                  fontSize: Window.getFontSize(16),
                ),
              ),
              // if (showAction)
              //   Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       SizedBox(width: Window.getHorizontalSize(10)),
              //       Icon(
              //         Icons.east,
              //         color: isFormFilled
              //             ? AppColors.neutral10 // Enabled arrow color
              //             : AppColors.neutral70, // Disabled arrow color
              //         size: Window.getFontSize(15.5),
              //       ),
              //     ],
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
