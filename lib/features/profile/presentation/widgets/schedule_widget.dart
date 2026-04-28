import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../config/routes/routes.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/windows.dart';

class ScheduleWidget extends StatelessWidget {
  const ScheduleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    /// Dummy UI data
    final scheduleList = [
      {
        "title": "Morning Run",
        "date": "12 Mar",
        "icon": "https://www.svgrepo.com/show/475123/run.svg"
      },
      {
        "title": "Gym Workout",
        "date": "14 Mar",
        "icon": "https://www.svgrepo.com/show/475099/dumbbell.svg"
      },
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        /// Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.schedule,
              style: AppTextStyles.subtitleMedium
                  .copyWith(color: AppColors.neutral100),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.scheduleScreen);
              },
              child: Text(
                AppStrings.sellAll,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.primaryBlue100),
              ),
            ),
          ],
        ),

        SizedBox(height: Window.getVerticalSize(20)),

        /// List
        scheduleList.isNotEmpty
            ? SizedBox(
                height: Window.getVerticalSize(80),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: scheduleList.length,
                  itemBuilder: (context, index) {
                    final item = scheduleList[index];

                    return Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: _buildScheduleItem(
                        title: item["title"]!,
                        type: item["date"]!,
                        imagePath: item["icon"]!,
                      ),
                    );
                  },
                ),
              )
            : GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.scheduleScreen);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      size: 60,
                      color: Colors.grey.shade300,
                    ),
                    Text(
                      AppStrings.clickToCreateSchedule,
                      style: AppTextStyles.bodyBold
                          .copyWith(color: AppColors.neutral60),
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  Widget _buildScheduleItem({
    required String title,
    required String type,
    required String imagePath,
  }) {
    return Container(
      width: Window.getHorizontalSize(300),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.neutral30),
        borderRadius: BorderRadius.circular(Window.getRadiusSize(16)),
      ),
      child: Padding(
        padding: Window.getPadding(all: 16),
        child: Row(
          children: [

            /// Icon
            CircleAvatar(
              radius: Window.getHorizontalSize(24),
              backgroundColor: AppColors.primaryBlue20,
              child: SvgPicture.network(
                imagePath,
                width: Window.getHorizontalSize(25),
                height: Window.getHorizontalSize(25),
              ),
            ),

            SizedBox(width: Window.getHorizontalSize(16)),

            /// Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyBold
                        .copyWith(color: AppColors.neutral100),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: Window.getVerticalSize(4)),

                  Row(
                    children: [
                      Text(
                        "${AppStrings.schedule} • ",
                        style: AppTextStyles.captionBold
                            .copyWith(color: AppColors.neutral70),
                      ),
                      Text(
                        type,
                        style: AppTextStyles.captionRegular
                            .copyWith(color: AppColors.neutral60),
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