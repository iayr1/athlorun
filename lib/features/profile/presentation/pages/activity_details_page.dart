import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:athlorun/core/widgets/custom_appbar.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';
import '../../../../core/widgets/custom_action_button.dart';

class ActivityDetailsPage extends StatelessWidget {
  const ActivityDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Builder(
        builder: (BuildContext context) {
          final TabController tabController = DefaultTabController.of(context)!;

          return Scaffold(
            appBar: customAppBar(
              title: "Activities Details",
              centerTitle: true,
              onBackPressed: () => Navigator.pop(context),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Map Section
                Container(
                  height: Window.getVerticalSize(200),
                  width: double.infinity, // Container height
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/map/map6.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Title and Date Section
                Padding(
                  padding: Window.getSymmetricPadding(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Night Run",
                        style: AppTextStyles.heading5SemiBold,
                      ),
                      SizedBox(height: Window.getVerticalSize(8)),
                      Row(
                        children: [
                          const Icon(Icons.directions_run,
                              size: 16, color: AppColors.primaryBlue100),
                          SizedBox(width: Window.getHorizontalSize(8)),
                          Text(
                            "Saturday, 31 Jan",
                            style: AppTextStyles.bodyRegular
                                .copyWith(color: AppColors.neutral60),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // TabBar Section
                TabBar(
                  controller: tabController,
                  labelColor: AppColors.primaryBlue100,
                  unselectedLabelColor: AppColors.neutral60,
                  indicator: BoxDecoration(
                    color: AppColors.primaryBlue40,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primaryBlue80),
                  ),
                  indicatorColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: AppTextStyles.bodyBold,
                  unselectedLabelStyle: AppTextStyles.bodyRegular,
                  splashFactory: NoSplash.splashFactory,
                  tabs: const [
                    SizedBox(width: 80, child: Tab(text: "Details")),
                    SizedBox(width: 80, child: Tab(text: "Results")),
                    SizedBox(width: 80, child: Tab(text: "Analysis")),
                  ],
                ),

                // TabBarView Section
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      DetailsTab(tabController: tabController),
                      const ResultsTab(),
                      const AnalysisTab(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DetailsTab extends StatelessWidget {
  final TabController tabController;

  const DetailsTab({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Section
                Padding(
                  padding: Window.getSymmetricPadding(horizontal: 16),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Icon(Icons.watch,
                            color: AppColors.neutral100, size: 20),
                        title: Text("Apple Watch",
                            style: AppTextStyles.bodyRegular),
                        horizontalTitleGap: 16.0,
                      ),
                      Divider(
                        color: AppColors.neutral20,
                      ),
                      ListTile(
                        leading: Icon(Icons.sports_handball,
                            color: AppColors.neutral100, size: 20),
                        title: Text("Nike Revolution 7",
                            style: AppTextStyles.bodyRegular),
                        horizontalTitleGap: 16.0,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Window.getVerticalSize(8)),

                // Statistics Section
                Padding(
                  padding: Window.getSymmetricPadding(horizontal: 25),
                  child: const Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _Statistic(label: "Distance", value: "12.5 km"),
                          _Statistic(label: "Avg Power", value: "14.6 mi/h"),
                          _Statistic(label: "Avg Speed", value: "95 W"),
                        ],
                      ),
                      Divider(
                        color: AppColors.neutral20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _Statistic(label: "Moving Time", value: "48 min"),
                          _Statistic(label: "Elevation Gain", value: "968 ft"),
                          _Statistic(label: "Calories", value: "513 Cal"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // View Analysis Button
        Padding(
          padding: Window.getPadding(all: 16),
          child: CustomActionButton(
            name: "View Analysis",
            isFormFilled: true,
            onTap: (startLoading, stopLoading, btnState) {
              startLoading();
              Future.delayed(const Duration(milliseconds: 500), () {
                stopLoading();
                tabController.animateTo(2);
              });
            },
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
              AppTextStyles.captionRegular.copyWith(color: AppColors.neutral60),
        ),
        SizedBox(height: Window.getVerticalSize(4)),
        Text(
          value,
          style: AppTextStyles.bodyBold.copyWith(color: AppColors.neutral100),
        ),
      ],
    );
  }
}

class ResultsTab extends StatelessWidget {
  const ResultsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: Window.getPadding(all: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Statistic(label: "Achievements", value: "28"),
              _Statistic(label: "Best Efforts", value: "11"),
              _Statistic(label: "Segments", value: "28"),
            ],
          ),
          SizedBox(height: Window.getVerticalSize(16)),
          ...List.generate(
            3,
            (index) => ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primaryBlue100,
                child: Text(
                  "2",
                  style: AppTextStyles.captionBold
                      .copyWith(color: AppColors.neutral10),
                ),
              ),
              title: Text("1 mile", style: AppTextStyles.bodyRegular),
              subtitle: Text(
                "2nd faster time - 6:23 - 6:23 /mi",
                style: AppTextStyles.captionRegular,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnalysisTab extends StatelessWidget {
  const AnalysisTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: Window.getPadding(all: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pace Analysis",
            style: AppTextStyles.heading5Bold
                .copyWith(color: AppColors.neutral100),
          ),
          SizedBox(height: Window.getVerticalSize(16)),
          SizedBox(
            height: Window.getVerticalSize(200),
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, _) => Text(
                        value.toInt().toString(),
                        style: AppTextStyles.captionRegular
                            .copyWith(color: AppColors.neutral60),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, _) => Text(
                        "Day ${value.toInt() + 1}",
                        style: AppTextStyles.captionRegular
                            .copyWith(color: AppColors.neutral60),
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(10, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: (index % 2 == 0) ? 5.0 : 6.0,
                        color: AppColors.primaryBlue100,
                        width: 10,
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          SizedBox(height: Window.getVerticalSize(16)),
          Text(
            "Splits",
            style: AppTextStyles.heading5Bold
                .copyWith(color: AppColors.neutral100),
          ),
          SizedBox(height: Window.getVerticalSize(8)),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 7,
            itemBuilder: (context, index) {
              return Padding(
                padding: Window.getSymmetricPadding(vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Text("Mile ${index + 1}",
                            style: AppTextStyles.bodyRegular)),
                    Expanded(
                        flex: 3,
                        child: Text("Pace: 5:${30 + index}",
                            style: AppTextStyles.bodyRegular)),
                    Expanded(
                        flex: 2,
                        child: Text("Elev: ${-30 + index * 10}",
                            style: AppTextStyles.bodyRegular)),
                    Expanded(
                        flex: 2,
                        child: Text("HR: ${150 + index} bpm",
                            style: AppTextStyles.bodyRegular)),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: Window.getVerticalSize(16)),
          Text(
            "Power",
            style: AppTextStyles.heading5Bold
                .copyWith(color: AppColors.neutral100),
          ),
          SizedBox(height: Window.getVerticalSize(16)),
          SizedBox(
            height: Window.getVerticalSize(200),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, _) => Text(
                        "${value.toInt()} W",
                        style: AppTextStyles.captionRegular
                            .copyWith(color: AppColors.neutral60),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, _) => Text(
                        "${value.toInt()} sec",
                        style: AppTextStyles.captionRegular
                            .copyWith(color: AppColors.neutral60),
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      10,
                      (index) => FlSpot(
                          index.toDouble(), (index % 2 == 0) ? 400 : 500),
                    ),
                    isCurved: true,
                    color: AppColors.primaryBlue100,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryBlue100.withOpacity(0.8),
                          AppColors.primaryBlue100.withOpacity(0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: Window.getVerticalSize(16)),
          const Divider(),
          SizedBox(height: Window.getVerticalSize(16)),
          Text(
            "Summary",
            style: AppTextStyles.heading5Bold
                .copyWith(color: AppColors.neutral100),
          ),
          SizedBox(height: Window.getVerticalSize(8)),
          _buildSummaryRow("Avg Power:", "496 W"),
          _buildSummaryRow("Total Work:", "2,416 KJ"),
          _buildSummaryRow("Max Power:", "837 W"),
          _buildSummaryRow("Weighted Avg Power:", "519 W"),
          _buildSummaryRow("Training Load:", "228"),
          _buildSummaryRow("Intensity:", "130"),
          SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: Window.getSymmetricPadding(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppTextStyles.bodyRegular
                  .copyWith(color: AppColors.neutral60)),
          Text(value,
              style:
                  AppTextStyles.bodyBold.copyWith(color: AppColors.neutral100)),
        ],
      ),
    );
  }
}
