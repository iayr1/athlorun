import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../config/routes/routes.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/windows.dart';

class SuggestedChallengeWidget extends StatelessWidget {
  const SuggestedChallengeWidget({super.key});

  @override
  Widget build(BuildContext context) {

    /// Dummy UI data
    final challenges = [
      {
        "title": "10K Steps Challenge",
        "date": "01 Mar - 10 Mar",
        "image":
            "https://cdn-icons-png.flaticon.com/512/888/888879.png",
      },
      {
        "title": "Cycling Pro",
        "date": "05 Mar - 20 Mar",
        "image":
            "https://cdn-icons-png.flaticon.com/512/2972/2972185.png",
      },
    ];

    if (challenges.isEmpty) {
      return _emptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.challenges,
              style: AppTextStyles.subtitleMedium
                  .copyWith(color: AppColors.neutral100),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                    context, AppRoutes.partcipatedChallengeDetailScreen);
              },
              child: Text(
                AppStrings.sellAll,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.primaryBlue100),
              ),
            )
          ],
        ),

        SizedBox(height: Window.getVerticalSize(10)),

        /// List
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: challenges.map((item) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.partcipatedChallengeDetailScreen,
                  );
                },
                child: _challengeCard(
                  item["title"]!,
                  item["date"]!,
                  item["image"]!,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const Icon(Icons.emoji_events,
                size: 60, color: AppColors.neutral60),
            const SizedBox(height: 10),
            Text(
              AppStrings.noParticipatedChallengesAvailable,
              style: AppTextStyles.bodySemiBold
                  .copyWith(color: AppColors.neutral100),
            ),
            const SizedBox(height: 5),
            Text(
              AppStrings.checkBackLaterForNewChallenege,
              style: AppTextStyles.captionRegular
                  .copyWith(color: AppColors.neutral60),
            ),
          ],
        ),
      ),
    );
  }

  Widget _challengeCard(
    String title,
    String date,
    String image,
  ) {
    return Container(
      width: Window.getHorizontalSize(150),
      height: Window.getVerticalSize(230),
      margin: Window.getMargin(right: 12, top: 8),
      decoration: BoxDecoration(
        color: AppColors.neutral10,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neutral30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 12,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Image
          Padding(
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: image,
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 8),

          /// Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              title,
              style: AppTextStyles.bodyBold,
            ),
          ),

          const SizedBox(height: 8),

          /// Date
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              date,
              style: AppTextStyles.captionRegular
                  .copyWith(color: AppColors.neutral60),
            ),
          ),

          const Spacer(),

          /// Button
          Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue40,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryBlue90),
              ),
              child: const Icon(
                Icons.check,
                color: AppColors.primaryBlue90,
              ),
            ),
          ),
        ],
      ),
    );
  }
}