import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/features/challenges/data/models/response/get_user_participated_challenges_response_model.dart';
import 'package:athlorun/features/settings/presentation/pages/notification_setting_screen.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';
import '../../../../core/widgets/custom_action_button.dart';

class CompletedChallengeScreen extends StatelessWidget {
  final ChallengeChallenge challengeData;

  const CompletedChallengeScreen({super.key, required this.challengeData});

  @override
  Widget build(BuildContext context) {
    String formattedDate = Utils.formatChallengeDate(
      challengeData.startDate,
      challengeData.endDate,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.challengeDetails,
          style: AppTextStyles.heading5Bold.copyWith(
            color: AppColors.neutral10,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryBlue100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.neutral10),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: Window.getPadding(all: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Window.getRadiusSize(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15.0,
                      spreadRadius: 5.0,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(Window.getRadiusSize(16)),
                    child: CachedNetworkImage(
                      imageUrl: challengeData.badge!,
                      height: Window.getSize(150),
                      fit: BoxFit.cover,
                    )),
              ),
            ),
            SizedBox(height: Window.getVerticalSize(25)),
            Text(
              challengeData.title!,
              textAlign: TextAlign.start,
              style: AppTextStyles.subtitleBold.copyWith(
                color: AppColors.primaryBlue100,
                fontSize: Window.getFontSize(26),
              ),
            ),
            SizedBox(height: Window.getVerticalSize(12)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: AppColors.primaryBlue60,
                      size: 16,
                    ),
                    SizedBox(
                      width: Window.getHorizontalSize(
                        12,
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: AppTextStyles.bodyRegular.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: Window.getPadding(all: 18),
                  decoration: BoxDecoration(
                    color: AppColors.neutral20,
                    borderRadius:
                        BorderRadius.circular(Window.getRadiusSize(14)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryBlue100.withOpacity(0.1),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    "${challengeData.targetValue!} ${challengeData.targetUnit!.toCapitalized}",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyRegular.copyWith(
                      color: AppColors.neutral100,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Window.getVerticalSize(18)),
            SizedBox(height: Window.getVerticalSize(35)),
            const Spacer(),
            CustomActionButton(
              onTap: (startLoading, stopLoading, btnState) {
                Navigator.pop(context);
              },
              name: AppStrings.backToChallenges,
              isFormFilled: true,
            ),
          ],
        ),
      ),
    );
  }
}
