import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../config/routes/routes.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class GraphicalWidget extends StatelessWidget {
  const GraphicalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: AppColors.neutral10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Icons
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Window.getHorizontalSize(18)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: AppColors.primaryBlue100,
                        size: Window.getFontSize(20),
                      ),
                      SizedBox(width: Window.getHorizontalSize(8)),
                      Text(
                        '5h 18m',
                        style: AppTextStyles.bodyBold
                            .copyWith(color: AppColors.neutral100),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '76.8',
                        style: AppTextStyles.heading2SemiBold
                            .copyWith(color: AppColors.neutral100),
                      ),
                      Text(
                        'km',
                        style: AppTextStyles.subtitleSemiBold
                            .copyWith(color: AppColors.neutral100),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.directions_run,
                        color: AppColors.primaryBlue100,
                        size: Window.getFontSize(20),
                      ),
                      SizedBox(width: Window.getHorizontalSize(8)),
                      Text(
                        '12:03',
                        style: AppTextStyles.bodyBold
                            .copyWith(color: AppColors.neutral100),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: Window.getVerticalSize(20)),

            // Graph
            Padding(
              padding: Window.getPadding(all: 16.0),
              child: AspectRatio(
                aspectRatio: 1.8,
                child: Padding(
                  padding: Window.getSymmetricPadding(horizontal: 8.0),
                  child: LineChart(
                    LineChartData(
                      backgroundColor: AppColors.neutral10,
                      gridData: const FlGridData(show: true),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const days = [
                                'Sun',
                                'Mon',
                                'Tue',
                                'Wed',
                                'Thu',
                                'Fri',
                                'Sat'
                              ];
                              return Text(
                                days[value.toInt()],
                                style: AppTextStyles.captionRegular
                                    .copyWith(color: AppColors.neutral60),
                              );
                            },
                            interval: 1,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          isCurved: true,
                          color: AppColors.primaryBlue100,
                          barWidth: 3,
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
                          spots: const [
                            FlSpot(0, 1),
                            FlSpot(1, 0.5),
                            FlSpot(2, 2),
                            FlSpot(3, 1.5),
                            FlSpot(4, 2.2),
                            FlSpot(5, 1.8),
                            FlSpot(6, 1),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: Window.getVerticalSize(8)),

            // Bottom Text
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.statisticsScreen);
              },
              child: Text(
                "View Detail Statistic",
                style: AppTextStyles.bodyBold
                    .copyWith(color: AppColors.primaryBlue100),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
