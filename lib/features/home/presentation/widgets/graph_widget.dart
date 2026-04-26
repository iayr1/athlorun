import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../core/utils/windows.dart';

class GraphWidget extends StatelessWidget {
  const GraphWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: SizedBox(
        height: Window.getVerticalSize(60), // Responsive height
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: false), // Hides grid
            titlesData: const FlTitlesData(show: false), // Hides titles
            borderData: FlBorderData(show: false), // Hides borders
            minX: 0,
            maxX: 6,
            minY: 0,
            maxY: 10,
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 3),
                  FlSpot(2, 5),
                  FlSpot(3, 6),
                  FlSpot(4, 4),
                  FlSpot(6, 4),
                ],
                isCurved: true,
                color: AppColors.primaryBlue100, // Custom color
                barWidth: Window.getHorizontalSize(2), // Responsive bar width
                belowBarData: BarAreaData(
                  show: true,
                  color: AppColors.primaryBlue100
                      .withOpacity(0.3), // Custom shaded color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
