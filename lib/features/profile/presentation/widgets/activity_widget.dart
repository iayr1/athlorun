import 'package:flutter/material.dart';
import '../../../../config/routes/routes.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class ActivityWidget extends StatelessWidget {
  const ActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Page Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Activity",
              style: AppTextStyles.subtitleMedium
                  .copyWith(color: AppColors.neutral100),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.chooseActivity);
              },
              child: Text(
                "See all",
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.primaryBlue100),
              ),
            ),
          ],
        ),
        SizedBox(height: Window.getVerticalSize(20)),

        // Activity Card
        Container(
          padding: Window.getPadding(all: 16.0),
          decoration: BoxDecoration(
            color: AppColors.neutral10,
            borderRadius: BorderRadius.circular(Window.getRadiusSize(16.0)),
            border: Border.all(
              color: AppColors.neutral30,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row with Icon, Title, and Date
              Row(
                children: [
                  CircleAvatar(
                    radius: Window.getHorizontalSize(24),
                    backgroundColor: AppColors.primaryBlue20,
                    child: Icon(
                      Icons.directions_run,
                      color: AppColors.neutral100,
                      size: Window.getFontSize(28),
                    ),
                  ),
                  SizedBox(width: Window.getHorizontalSize(16)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Running Night",
                        style: AppTextStyles.bodyBold
                            .copyWith(color: AppColors.neutral100),
                      ),
                      SizedBox(height: Window.getVerticalSize(4)),
                      Text(
                        "Friday, 30 Jan",
                        style: AppTextStyles.captionRegular
                            .copyWith(color: AppColors.neutral60),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: Window.getVerticalSize(16)),

              // Map Placeholder
              Container(
                height: Window.getVerticalSize(150),
                decoration: BoxDecoration(
                  color: AppColors.neutral20,
                  borderRadius:
                      BorderRadius.circular(Window.getRadiusSize(8.0)),
                ),
                child: const Center(
                  child: Image(
                    image: AssetImage(
                        'assets/map/map4.png'), // Replace with your image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: Window.getVerticalSize(16)),

              // Statistics Row (Duration, Distance, Avg Pace)
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _Statistic(label: "Duration", value: "48 min"),
                  _Statistic(label: "Distance", value: "76.8 km"),
                  _Statistic(label: "Avg Pace", value: "12:03"),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Statistic extends StatelessWidget {
  final String label;
  final String value;

  const _Statistic({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style:
              AppTextStyles.captionBold.copyWith(color: AppColors.neutral100),
        ),
        SizedBox(height: Window.getVerticalSize(4)),
        Text(
          value,
          style: AppTextStyles.bodyRegular.copyWith(color: AppColors.neutral70),
        ),
      ],
    );
  }
}
