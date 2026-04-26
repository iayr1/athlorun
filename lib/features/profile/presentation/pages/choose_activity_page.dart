import 'package:flutter/material.dart';
import 'package:athlorun/core/widgets/custom_appbar.dart';
import '../../../../config/routes/routes.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class ChooseActivityPage extends StatelessWidget {
  const ChooseActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: "Activities",
        centerTitle: true,
        onBackPressed: () => Navigator.pop(context),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: Window.getHorizontalSize(16)),
            child: Icon(
              Icons.calendar_today_outlined,
              size: Window.getHorizontalSize(20),
              color: AppColors.neutral100,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: Window.getPadding(all: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Multiple Activity Cards
              const _BuildContainerWidget(),
              SizedBox(height: Window.getVerticalSize(10)),
              const _BuildContainerWidget(),
              SizedBox(height: Window.getVerticalSize(10)),
              const _BuildContainerWidget(),
              SizedBox(height: Window.getVerticalSize(10)),
              const _BuildContainerWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildContainerWidget extends StatelessWidget {
  const _BuildContainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.00, right: 16.00),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.activityDetailsPage);
        },
        child: Container(
          // padding: Window.getPadding(all: 16.0),
          decoration: BoxDecoration(
            color: AppColors.neutral10,
            borderRadius: BorderRadius.circular(Window.getRadiusSize(16.0)),
            border: Border.all(
              color: AppColors.neutral30,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(Window.getRadiusSize(8.0)),
                  child: Image.asset(
                    'assets/map/map6.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: Window.getVerticalSize(16)),
                Padding(
                  padding: Window.getPadding(left: 16.0, right: 16.0),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _Statistic(label: "Duration", value: "48 min"),
                      _Statistic(label: "Distance", value: "76.8 km"),
                      _Statistic(label: "Avg Pace", value: "12:03"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
              AppTextStyles.captionRegular.copyWith(color: AppColors.neutral60),
        ),
        SizedBox(height: Window.getVerticalSize(2)),
        Text(
          value,
          style: AppTextStyles.bodyBold.copyWith(color: AppColors.neutral100),
        ),
      ],
    );
  }
}
