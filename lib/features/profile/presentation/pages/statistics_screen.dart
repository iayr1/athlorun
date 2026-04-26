import 'package:flutter/material.dart';
import 'package:athlorun/core/widgets/custom_appbar.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class StatisticScreen extends StatelessWidget {
  const StatisticScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral10,
      appBar: customAppBar(
        title: "Statistic",
        centerTitle: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // Tabs for activities
          Padding(
            padding: Window.getSymmetricPadding(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActivityTab(
                  context,
                  icon: Icons.directions_run,
                  label: "Run",
                  isSelected: true,
                ),
                _buildActivityTab(
                  context,
                  icon: Icons.directions_bike,
                  label: "Cycling",
                  isSelected: false,
                ),
                _buildActivityTab(
                  context,
                  icon: Icons.hiking,
                  label: "Hiking",
                  isSelected: false,
                ),
                _buildActivityTab(
                  context,
                  icon: Icons.fitness_center,
                  label: "Gym",
                  isSelected: false,
                ),
              ],
            ),
          ),
          Divider(thickness: 1, color: AppColors.neutral30),

          // Statistic Details
          Expanded(
            child: ListView(
              padding: Window.getSymmetricPadding(horizontal: 16),
              children: [
                _buildStatisticSection(
                  title: "Activity",
                  data: const [
                    {"label": "Avg Runs/Week", "value": "8"},
                    {"label": "Avg Time/Week", "value": "8h 42m"},
                    {"label": "Avg Distance/Week", "value": "61 mi"},
                  ],
                ),
                SizedBox(height: Window.getVerticalSize(16)),
                _buildStatisticSection(
                  title: "Year to Date",
                  data: const [
                    {"label": "Runs", "value": "34"},
                    {"label": "Time", "value": "36h 6m"},
                    {"label": "Distance", "value": "257 mi"},
                    {"label": "Elev Gain", "value": "10,014 ft"},
                  ],
                ),
                SizedBox(height: Window.getVerticalSize(16)),
                _buildStatisticSection(
                  title: "All Time",
                  data: const [
                    {"label": "Runs", "value": "1,867"},
                    {"label": "Distance", "value": "10,931 mi"},
                  ],
                ),
                SizedBox(height: Window.getVerticalSize(16)),
                _buildStatisticSection(
                  title: "Best Efforts",
                  data: const [
                    {"label": "400m", "value": "0:41"},
                    {"label": "1/2 mile", "value": "1:32"},
                    {"label": "1k", "value": "2:13"},
                    {"label": "1 mile", "value": "3:45"},
                    {"label": "2 mile", "value": "9:15"},
                    {"label": "5k", "value": "12:48"},
                    {"label": "10k", "value": "35:25"},
                    {"label": "15k", "value": "53:43"},
                    {"label": "20k", "value": "1:11:08"},
                    {"label": "Half-Marathon", "value": "1:15:01"},
                    {"label": "Marathon", "value": "5:10:23"},
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTab(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return Column(
      children: [
        Icon(icon,
            color: isSelected ? AppColors.primaryBlue100 : AppColors.neutral40),
        SizedBox(height: Window.getVerticalSize(4)),
        Text(
          label,
          style: AppTextStyles.bodySemiBold.copyWith(
            color: isSelected ? AppColors.primaryBlue100 : AppColors.neutral40,
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticSection({
    required String title,
    required List<Map<String, String>> data,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.titleBold.copyWith(color: AppColors.neutral100),
        ),
        SizedBox(height: Window.getVerticalSize(8)),
        ...data.map((entry) {
          return Padding(
            padding: Window.getSymmetricPadding(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry["label"]!,
                  style: AppTextStyles.bodyRegular
                      .copyWith(color: AppColors.neutral90),
                ),
                Text(
                  entry["value"]!,
                  style: AppTextStyles.bodyBold
                      .copyWith(color: AppColors.primaryBlue100),
                ),
              ],
            ),
          );
        }).toList(),
        Divider(thickness: 1, color: AppColors.neutral30),
      ],
    );
  }
}
