import 'package:flutter/material.dart';
import '../../../../config/images/app_images.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class StepCountWidget extends StatelessWidget {
  const StepCountWidget({super.key});

  @override
  Widget build(BuildContext context) {

    /// Dummy UI values
    final int todaySteps = 4200;
    const int stepGoal = 10000;

    final double progress = todaySteps / stepGoal;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        const SizedBox(height: 30),

        /// Title
        Text(
          "Daily Steps",
          style: AppTextStyles.heading4Bold.copyWith(
            color: AppColors.primaryBlue100,
          ),
        ),

        const SizedBox(height: 5),

        /// Image
        Image.asset(
          AppImages.walkingGif,
          width: Window.getSize(100),
          height: Window.getSize(100),
          fit: BoxFit.contain,
        ),

        const SizedBox(height: 10),

        /// Steps Count
        Text(
          "$todaySteps Steps",
          style: AppTextStyles.heading2Bold.copyWith(
            color: AppColors.neutral100,
          ),
        ),

        const SizedBox(height: 10),

        /// Distance (dummy)
        Text(
          "3.2 km",
          style: AppTextStyles.bodyBold.copyWith(
            color: AppColors.primaryBlue100,
          ),
        ),

        const SizedBox(height: 30),

        /// Progress Bar
        _buildProgress(progress, todaySteps, stepGoal),

        const SizedBox(height: 30),

        /// Stats
        _buildStatsRow(),
      ],
    );
  }

  Widget _buildProgress(double progress, int steps, int goal) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 50,
          width: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [AppColors.primaryBlue70, AppColors.primaryBlue100],
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 50,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryBlue100,
              ),
            ),
          ),
        ),

        Text(
          "$steps / $goal Steps",
          style: AppTextStyles.bodyBold.copyWith(
            color: AppColors.neutral10,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        _StatItem("Distance", "3.2", "KM", Icons.directions_walk),
        _StatItem("Coins", "25", "Coins", Icons.currency_bitcoin),
        _StatItem("Calories", "120", "Cal", Icons.local_fire_department),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;

  const _StatItem(this.title, this.value, this.unit, this.icon);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryBlue100),
        const SizedBox(height: 5),
        Text(title, style: AppTextStyles.captionSemiBold),
        Text(value, style: AppTextStyles.subtitleBold),
        Text(
          unit,
          style: AppTextStyles.captionRegular.copyWith(
            color: AppColors.neutral70,
          ),
        ),
      ],
    );
  }
}