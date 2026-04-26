import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:health/health.dart';
import 'package:athlorun/config/images/app_images.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/config/styles/app_textstyles.dart';

class StatisticsWidget extends StatefulWidget {
  const StatisticsWidget({Key? key}) : super(key: key);

  @override
  State<StatisticsWidget> createState() => _StatisticsWidgetState();
}

class _StatisticsWidgetState extends State<StatisticsWidget> {
  final health = Health();
  List<HealthDataPoint> _healthData = [];

  // Using ValueNotifier for smoother updates
  final ValueNotifier<Map<HealthDataType, int>> _baseValuesNotifier =
      ValueNotifier({});
  final ValueNotifier<Map<HealthDataType, int>> _incrementsNotifier =
      ValueNotifier({});

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchHealthData();
    _startUpdateTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _baseValuesNotifier.dispose();
    _incrementsNotifier.dispose();
    super.dispose();
  }

  /// Fetch health data from the Health API
  Future<void> _fetchHealthData() async {
    final types = [
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.DISTANCE_WALKING_RUNNING,
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.HEART_RATE,
      HealthDataType.WEIGHT,
      HealthDataType.WATER,
    ];
    final permissions = types.map((type) => HealthDataAccess.READ).toList();

    bool granted =
        await health.requestAuthorization(types, permissions: permissions);
    if (!granted) return;

    try {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      // Fetch health data
      final data = await health.getHealthDataFromTypes(
        startTime: yesterday,
        endTime: now,
        types: types,
      );

      // Process and update data
      final processedData = _processHealthData(health.removeDuplicates(data));
      _baseValuesNotifier.value = processedData['baseValues']!;
      _incrementsNotifier.value = processedData['increments']!;
    } catch (e) {
      debugPrint("Error fetching health data: $e");
    }
  }

  /// Process fetched health data into base values and increments
  Map<String, Map<HealthDataType, int>> _processHealthData(
      List<HealthDataPoint> data) {
    final Map<HealthDataType, int> baseValues = {};
    final Map<HealthDataType, int> increments = {};

    for (var point in data) {
      final type = point.type;
      final value = _parseValue(point.value);

      if (value > (baseValues[type] ?? 0)) {
        final increment = value - (baseValues[type] ?? 0);
        baseValues[type] = value - increment;
        increments[type] = increment;
      }
    }

    return {'baseValues': baseValues, 'increments': increments};
  }

  /// Parse dynamic value safely into an integer
  int _parseValue(dynamic value) => value is num ? value.toInt() : 0;

  /// Start a timer to periodically fetch updated health data
  void _startUpdateTimer() {
    _timer =
        Timer.periodic(const Duration(seconds: 10), (_) => _fetchHealthData());
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ValueListenableBuilder<Map<HealthDataType, int>>(
          valueListenable: _baseValuesNotifier,
          builder: (context, baseValues, _) {
            return ValueListenableBuilder<Map<HealthDataType, int>>(
              valueListenable: _incrementsNotifier,
              builder: (context, increments, _) {
                return Row(
                  children: [
                    _buildStatCard(
                      "Walking",
                      HealthDataType.STEPS,
                      Icons.directions_walk,
                      Colors.blueAccent,
                      baseValues[HealthDataType.STEPS] ?? 0,
                      increments[HealthDataType.STEPS] ?? 0,
                    ),
                    _buildStatCard(
                      "Sprint ",
                      HealthDataType.ACTIVE_ENERGY_BURNED,
                      AppImages.sprint,
                      Colors.redAccent,
                      baseValues[HealthDataType.ACTIVE_ENERGY_BURNED] ?? 0,
                      increments[HealthDataType.ACTIVE_ENERGY_BURNED] ?? 0,
                    ),
                    _buildStatCard(
                      "Strectching",
                      HealthDataType.DISTANCE_WALKING_RUNNING,
                      AppImages.stretching,
                      Colors.green,
                      baseValues[HealthDataType.DISTANCE_WALKING_RUNNING] ?? 0,
                      increments[HealthDataType.DISTANCE_WALKING_RUNNING] ?? 0,
                    ),
                    _buildStatCard(
                      "Sleep",
                      HealthDataType.SLEEP_ASLEEP,
                      Icons.bedtime,
                      Colors.indigo,
                      baseValues[HealthDataType.SLEEP_ASLEEP] ?? 0,
                      increments[HealthDataType.SLEEP_ASLEEP] ?? 0,
                    ),
                    _buildStatCard(
                      "Heart Rate",
                      HealthDataType.HEART_RATE,
                      Icons.favorite,
                      Colors.red,
                      baseValues[HealthDataType.HEART_RATE] ?? 0,
                      increments[HealthDataType.HEART_RATE] ?? 0,
                    ),
                    _buildStatCard(
                      "Weight",
                      HealthDataType.WEIGHT,
                      Icons.scale,
                      Colors.teal,
                      baseValues[HealthDataType.WEIGHT] ?? 0,
                      increments[HealthDataType.WEIGHT] ?? 0,
                    ),
                    _buildStatCard(
                      "Water Intake",
                      HealthDataType.WATER,
                      Icons.water_drop,
                      Colors.blue,
                      baseValues[HealthDataType.WATER] ?? 0,
                      increments[HealthDataType.WATER] ?? 0,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  /// Build individual stat card
  Widget _buildStatCard(
    String title,
    HealthDataType type,
    dynamic icon, // Can be IconData or SVG path
    Color color,
    int baseValue,
    int increment,
  ) {
    Widget iconWidget;
    if (icon is IconData) {
      iconWidget = Icon(icon, color: AppColors.neutral10, size: 24);
    } else if (icon is String) {
      iconWidget = SvgPicture.asset(
        icon,
        height: 24,
        width: 24,
        color: AppColors.neutral10,
      );
    } else {
      iconWidget = const SizedBox(); // fallback
    }

    return SizedBox(
      height: 160,
      width: 160,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.9),
              child: iconWidget,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "$baseValue",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 4),
                if (increment > 0)
                  Text(
                    "+$increment",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                title,
                style: AppTextStyles.bodyRegular.copyWith(
                  color: AppColors.neutral70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
