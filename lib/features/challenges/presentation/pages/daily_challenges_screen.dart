import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:athlorun/features/home/presentation/pages/health_page.dart';

class DailyChallengesScreen extends StatefulWidget {
  const DailyChallengesScreen({super.key});

  @override
  State<DailyChallengesScreen> createState() => _DailyChallengesScreenState();
}

class _DailyChallengesScreenState extends State<DailyChallengesScreen> {
  static const int _dailyStepsTarget = 10000;
  static const double _dailyRunKmTarget = 5;
  static const double _dailyCaloriesTarget = 600;
  static const double _dailySleepHoursTarget = 8;

  int _steps = 0;
  double _runningDistanceKm = 0;
  double _walkingDistanceKm = 0;
  double _calories = 0;
  double _sleepHours = 0;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDailyMetrics();
  }

  String get _todayKey {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  Future<void> _loadDailyMetrics() async {
    final prefs = await SharedPreferences.getInstance();
    await _rollOverDailyDataIfNeeded(prefs);

    if (!mounted) return;

    setState(() {
      _steps = prefs.getInt('steps') ?? 0;
      _runningDistanceKm = prefs.getDouble('runningDistance') ?? 0;
      _walkingDistanceKm = prefs.getDouble('walkingDistance') ?? 0;
      _calories = prefs.getDouble('calories') ?? 0;
      _sleepHours = prefs.getDouble('sleep_hours_$_todayKey') ?? 0;
      _isLoading = false;
    });
  }

  Future<void> _rollOverDailyDataIfNeeded(SharedPreferences prefs) async {
    final previousDate = prefs.getString('daily_metrics_date');
    if (previousDate == _todayKey) return;

    await prefs.setString('daily_metrics_date', _todayKey);
    await prefs.setInt('steps', 0);
    await prefs.setDouble('runningDistance', 0);
    await prefs.setDouble('walkingDistance', 0);
    await prefs.setDouble('calories', 0);
  }

  Future<void> _openSleepLogger() async {
    final now = DateTime.now();
    final TimeOfDay? sleepStart = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 23, minute: 0),
      helpText: 'When did you go to sleep?',
    );
    if (sleepStart == null || !mounted) return;

    final TimeOfDay? sleepEnd = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
      helpText: 'When did you wake up?',
    );
    if (sleepEnd == null) return;

    final sleptHours = _calculateSleepHours(sleepStart, sleepEnd);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('sleep_hours_$_todayKey', sleptHours);

    if (!mounted) return;

    setState(() {
      _sleepHours = sleptHours;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sleep logged: ${sleptHours.toStringAsFixed(1)} h')),
    );
  }

  double _calculateSleepHours(TimeOfDay start, TimeOfDay end) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    final minutes = endMinutes >= startMinutes
        ? endMinutes - startMinutes
        : (24 * 60 - startMinutes) + endMinutes;

    return minutes / 60;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Challenges'),
        actions: [
          IconButton(
            tooltip: 'Refresh progress',
            onPressed: _loadDailyMetrics,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadDailyMetrics,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildOverviewCard(),
                  const SizedBox(height: 14),
                  _ChallengeProgressCard(
                    icon: Icons.directions_walk,
                    title: '10,000 Steps',
                    subtitle: 'Walk at least 10,000 steps today',
                    valueLabel: '$_steps / $_dailyStepsTarget steps',
                    progress: (_steps / _dailyStepsTarget).clamp(0, 1),
                  ),
                  _ChallengeProgressCard(
                    icon: Icons.directions_run,
                    title: 'Run $_dailyRunKmTarget km',
                    subtitle: 'Complete your daily running distance',
                    valueLabel:
                        '${_runningDistanceKm.toStringAsFixed(2)} / ${_dailyRunKmTarget.toStringAsFixed(1)} km',
                    progress: (_runningDistanceKm / _dailyRunKmTarget)
                        .clamp(0, 1),
                  ),
                  _ChallengeProgressCard(
                    icon: Icons.local_fire_department,
                    title: 'Burn $_dailyCaloriesTarget kcal',
                    subtitle: 'Calories burned while walking and running',
                    valueLabel:
                        '${_calories.toStringAsFixed(0)} / ${_dailyCaloriesTarget.toStringAsFixed(0)} kcal',
                    progress: (_calories / _dailyCaloriesTarget).clamp(0, 1),
                  ),
                  _ChallengeProgressCard(
                    icon: Icons.bedtime,
                    title: 'Sleep $_dailySleepHoursTarget hours',
                    subtitle: 'Log and complete your sleep target daily',
                    valueLabel:
                        '${_sleepHours.toStringAsFixed(1)} / ${_dailySleepHoursTarget.toStringAsFixed(1)} h',
                    progress: (_sleepHours / _dailySleepHoursTarget).clamp(0, 1),
                    trailing: TextButton.icon(
                      onPressed: _openSleepLogger,
                      icon: const Icon(Icons.nightlight_round),
                      label: const Text('Log sleep'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.sensors),
                      title: const Text('Sync movement data'),
                      subtitle: const Text(
                        'Open health monitoring to update steps, distance and calories.',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SensorDataScreen(),
                          ),
                        );
                        _loadDailyMetrics();
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Running: ${_runningDistanceKm.toStringAsFixed(2)} km  •  Walking: ${_walkingDistanceKm.toStringAsFixed(2)} km',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildOverviewCard() {
    final completed = [
      _steps >= _dailyStepsTarget,
      _runningDistanceKm >= _dailyRunKmTarget,
      _calories >= _dailyCaloriesTarget,
      _sleepHours >= _dailySleepHoursTarget,
    ].where((v) => v).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF3B82F6)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today\'s challenge status',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 6),
          Text(
            '$completed / 4 completed',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: completed / 4,
            minHeight: 8,
            borderRadius: BorderRadius.circular(999),
            backgroundColor: Colors.white30,
          ),
        ],
      ),
    );
  }
}

class _ChallengeProgressCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String valueLabel;
  final double progress;
  final Widget? trailing;

  const _ChallengeProgressCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.valueLabel,
    required this.progress,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFE8EEFF),
                  child: Icon(icon, color: const Color(0xFF3B82F6)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 10),
            Text(valueLabel),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(999),
            ),
          ],
        ),
      ),
    );
  }
}
