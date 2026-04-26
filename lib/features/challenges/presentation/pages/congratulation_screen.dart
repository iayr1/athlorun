import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:athlorun/config/images/app_images.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/core/utils/app_strings.dart';

class CongratulationScreen extends StatelessWidget {
  final String challengeName;

  const CongratulationScreen({
    super.key,
    required this.challengeName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue40,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background Confetti Animation
          Positioned.fill(
            child: Lottie.asset(
              AppImages.confettiLottie,
              fit: BoxFit.cover,
              repeat: false,
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Trophy Animation or Success Icon
                Lottie.asset(
                  AppImages.trophyLottie,
                  width: 300,
                  height: 400,
                  repeat: false,
                ),

                const SizedBox(height: 24),

                // Title
                const Text(
                  AppStrings.congratulations,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue80,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // Subtitle
                Text(
                  'You’ve successfully joined the "$challengeName" challenge.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Continue Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue80,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    AppStrings.continueTxt,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
