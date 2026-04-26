import 'package:flutter/material.dart';
import 'package:athlorun/config/images/app_images.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';
import '../../../../core/widgets/custom_action_button.dart'; // Import CustomActionButton

class CoinRedeemScreen extends StatelessWidget {
  const CoinRedeemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve arguments safely
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Default values if arguments are null
    final String title = args?["title"] ?? "No Title";
    final String date = args?["date"] ?? "Unknown Date";
    final String time = args?["time"] ?? "Unknown Time";
    final String points = args?["points"] ?? "0";

    return Scaffold(
      backgroundColor: AppColors.neutral10,
      appBar: AppBar(
        title: Text(
          "Redeem Details",
          style:
              AppTextStyles.heading4Bold.copyWith(color: AppColors.neutral100),
        ),
        backgroundColor: AppColors.neutral10,
        iconTheme: const IconThemeData(color: AppColors.neutral100),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Coin GIF
          Container(
            padding: EdgeInsets.all(Window.getHorizontalSize(10)),
            child: Image.asset(
              AppImages.stepCoinGif,
              width: Window.getHorizontalSize(160),
              height: Window.getVerticalSize(160),
              fit: BoxFit.contain,
            ),
          ),

          SizedBox(height: Window.getVerticalSize(25)),

          // Title
          Text(
            title,
            style: AppTextStyles.heading3Bold.copyWith(
              color: AppColors.primaryBlue100,
              fontSize: Window.getFontSize(24),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Window.getVerticalSize(10)),

          // Date & Time
          Text(
            "Date: $date | Time: $time",
            style: AppTextStyles.bodyRegular.copyWith(
              color: AppColors.neutral50,
              fontSize: Window.getFontSize(16),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Window.getVerticalSize(20)),

          // Points Redeemed
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Window.getHorizontalSize(32),
              vertical: Window.getVerticalSize(14),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryBlue60, AppColors.primaryBlue40],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(Window.getHorizontalSize(16)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue60.withOpacity(0.4),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Text(
              "$points Points",
              style: AppTextStyles.heading2Bold.copyWith(
                color: Colors.white,
                fontSize: Window.getFontSize(26),
              ),
            ),
          ),
          SizedBox(height: Window.getVerticalSize(40)),
          Spacer(),

          // Custom Action Button (Replacing ElevatedButton)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: CustomActionButton(
                name: "Back",
                isFormFilled: true,
                onTap: (startLoading, stopLoading, btnState) {
                  Navigator.pop(context);
                },
                buttonWidth: Window.getHorizontalSize(180),
                buttonHeight: Window.getVerticalSize(50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
