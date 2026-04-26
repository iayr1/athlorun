import 'package:flutter/material.dart';
import '../../../../config/routes/routes.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';

class RewardWidget extends StatelessWidget {
  const RewardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildRewardButton(context);
  }
}

Widget _buildRewardButton(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, AppRoutes.dailymission);
    },
    child: Container(
      width: 120,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.neutral10,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 2, color: AppColors.primaryBlue100),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.card_giftcard, color: AppColors.primaryBlue100),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                "Reward",
                style: AppTextStyles.captionBold
                    .copyWith(color: AppColors.primaryBlue100),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
