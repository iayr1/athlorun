import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlorun/features/challenges/data/models/response/get_challenge_response_model.dart';
import 'package:athlorun/features/challenges/presentation/bloc/challenges_cubit.dart';
import 'package:athlorun/features/settings/presentation/pages/notification_setting_screen.dart';
import '../../../../config/routes/routes.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class ChallengeItem extends StatelessWidget {
  final GetChallengeResponseDataModel challengesList;
  final String title;
  final String date;
  final String description;
  final String imagePath;

  const ChallengeItem({
    super.key,
    required this.challengesList,
    required this.title,
    required this.date,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.challengePosterScreen,
                arguments: challengesList)
            .then((_) {
          context
              .read<ChallengesCubit>()
              .getParticipatedChallenges("participated");
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: Window.getPadding(all: 16),
        decoration: BoxDecoration(
          color: AppColors.neutral10,
          borderRadius: BorderRadius.circular(Window.getRadiusSize(12)),
          border: Border.all(color: AppColors.neutral30),
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(Window.getRadiusSize(8)),
              child: CachedNetworkImage(
                imageUrl: imagePath,
                width: Window.getHorizontalSize(100),
                height: Window.getVerticalSize(100),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: Window.getHorizontalSize(16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title.toCapitalized,
                    style: AppTextStyles.bodyBold.copyWith(
                      fontSize: Window.getFontSize(14),
                      color: AppColors.neutral100,
                    ),
                  ),
                  SizedBox(height: Window.getVerticalSize(8)),

                  // Date
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: AppColors.primaryBlue100,
                        size: 18,
                      ),
                      SizedBox(width: Window.getHorizontalSize(5)),
                      Text(
                        date,
                        style: AppTextStyles.captionRegular.copyWith(
                          fontSize: Window.getFontSize(12),
                          color: AppColors.neutral60,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Window.getVerticalSize(4)),

                  // Description
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.sports_cricket,
                        color: AppColors.primaryBlue100,
                        size: 18,
                      ),
                      SizedBox(width: Window.getHorizontalSize(5)),
                      Expanded(
                        child: Text(
                          description,
                          style: AppTextStyles.captionRegular.copyWith(
                            fontSize: Window.getFontSize(12),
                            color: AppColors.neutral60,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
