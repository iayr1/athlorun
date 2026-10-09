import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../config/themes/app_theme.dart';
import '../../../../core/services/metrics_store.dart';
import '../../../../core/services/step_tracker.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/ui_kit.dart';
import '../../../activity/presentation/pages/activity_history_page.dart';
import '../../../challenges/presentation/widgets/sleep_logger.dart';

/// Main landing tab: today's progress, weekly trend and recent workouts.
class HomeDashboardPage extends StatelessWidget {
  /// Switches the bottom navigation to another tab.
  final ValueChanged<int> onNavigate;

  const HomeDashboardPage({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final store = MetricsStore.instance;
    return ListenableBuilder(
      listenable: Listenable.merge([store, StepTracker.instance]),
      builder: (context, _) {
        final today = store.today;
        final goals = store.goals;
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _Header(store: store)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              sliver: SliverList.list(
                children: [
                  if (StepTracker.instance.permissionDenied) ...[
                    const _PermissionBanner(),
                    const SizedBox(height: 16),
                  ],
                  _QuickActions(onNavigate: onNavigate),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: StatTile(
                          icon: Icons.route_rounded,
                          color: AppPalette.blue,
                          value: '${Fmt.km(today.totalKm)} km',
                          label: 'Distance',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatTile(
                          icon: Icons.local_fire_department_rounded,
                          color: AppPalette.orange,
                          value: today.calories.toStringAsFixed(0),
                          label: 'kcal burned',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatTile(
                          icon: Icons.bedtime_rounded,
                          color: AppPalette.purple,
                          value: '${today.sleepHours.toStringAsFixed(1)} h',
                          label: 'Sleep',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'This week'),
                  _WeeklyChart(store: store),
                  const SizedBox(height: 24),
                  SectionHeader(
                    title: 'Daily challenges',
                    actionLabel: 'View all',
                    onAction: () => onNavigate(1),
                  ),
                  _ChallengeSummary(
                    today: today,
                    goals: goals,
                    onTap: () => onNavigate(1),
                  ),
                  const SizedBox(height: 24),
                  SectionHeader(
                    title: 'Recent workouts',
                    actionLabel: store.activities.isEmpty ? null : 'See all',
                    onAction: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ActivityHistoryPage(),
                      ),
                    ),
                  ),
                  if (store.activities.isEmpty)
                    SurfaceCard(
                      child: EmptyState(
                        icon: Icons.directions_run_rounded,
                        title: 'Your first workout awaits',
                        message:
                            'Track a run, walk or ride with live GPS mapping.',
                        action: FilledButton.icon(
                          onPressed: () => onNavigate(2),
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text('Start tracking'),
                        ),
                      ),
                    )
                  else
                    for (final a in store.activities.take(3)) ...[
                      ActivityTile(activity: a),
                      const SizedBox(height: 12),
                    ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final MetricsStore store;

  const _Header({required this.store});

  @override
  Widget build(BuildContext context) {
    final today = store.today;
    final goal = store.goals.steps;
    final progress = goal == 0 ? 0.0 : today.steps / goal;
    final streak = store.streak;

    return Container(
      decoration: const BoxDecoration(
        gradient: AppPalette.hero,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white.withValues(alpha: 0.22),
                    child: Text(
                      store.name.isEmpty ? 'A' : store.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${Fmt.greeting(DateTime.now())},',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          store.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _Pill(
                    icon: Icons.local_fire_department_rounded,
                    label:
                        streak == 0 ? 'Start a streak' : '$streak day streak',
                  ),
                ],
              ),
              const SizedBox(height: 26),
              ProgressRing(
                progress: progress,
                size: 196,
                stroke: 16,
                colors: const [
                  Color(0xFFA5F3FC),
                  Colors.white,
                  Color(0xFFA5F3FC)
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.directions_walk_rounded,
                        color: Colors.white, size: 26),
                    const SizedBox(height: 4),
                    Text(
                      Fmt.steps(today.steps),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                    Text(
                      'of ${Fmt.steps(goal)} steps',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text(
                progress >= 1
                    ? 'Goal crushed! Keep the momentum going 🎉'
                    : '${(progress * 100).clamp(0, 100).toStringAsFixed(0)}% of your daily goal · '
                        '${Fmt.steps((goal - today.steps).clamp(0, goal))} to go',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.92),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Pill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFFDBA74), size: 18),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionBanner extends StatelessWidget {
  const _PermissionBanner();

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          const IconBadge(
              icon: Icons.sensors_off_rounded, color: AppPalette.amber),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Allow physical activity access for accurate step counting.',
              style: TextStyle(fontSize: 13),
            ),
          ),
          TextButton(
            onPressed: () async {
              await StepTracker.instance.openSettings();
            },
            child: const Text('Allow'),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final ValueChanged<int> onNavigate;

  const _QuickActions({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final actions = [
      (
        Icons.play_arrow_rounded,
        'Workout',
        AppPalette.hero,
        () => onNavigate(2)
      ),
      (
        Icons.bedtime_rounded,
        'Log sleep',
        AppPalette.dream,
        () => showSleepLogger(context)
      ),
      (
        Icons.emoji_events_rounded,
        'Goals',
        AppPalette.fire,
        () => onNavigate(1)
      ),
      (
        Icons.monitor_heart_rounded,
        'Sensors',
        AppPalette.fresh,
        () => onNavigate(3)
      ),
    ];
    return Row(
      children: [
        for (final (icon, label, gradient, onTap) in actions)
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              behavior: HitTestBehavior.opaque,
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: gradient.colors.first.withValues(alpha: 0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: Colors.white, size: 28),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  final MetricsStore store;

  const _WeeklyChart({required this.store});

  @override
  Widget build(BuildContext context) {
    final days = store.lastDays(7);
    final goal = store.goals.steps.toDouble();
    final maxSteps =
        days.fold<int>(0, (m, e) => e.value.steps > m ? e.value.steps : m);
    final maxY = (maxSteps > goal ? maxSteps : goal) * 1.15;
    final total = days.fold<int>(0, (s, e) => s + e.value.steps);

    return SurfaceCard(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Fmt.steps(total),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const Text(
                    'steps in the last 7 days',
                    style: TextStyle(color: AppPalette.inkSoft, fontSize: 12.5),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                'avg ${Fmt.steps((total / 7).round())}/day',
                style: const TextStyle(
                  color: AppPalette.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                maxY: maxY <= 0 ? 1 : maxY,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: goal,
                      color: AppPalette.orange.withValues(alpha: 0.6),
                      strokeWidth: 1.5,
                      dashArray: [6, 4],
                    ),
                  ],
                ),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i < 0 || i >= days.length) {
                          return const SizedBox.shrink();
                        }
                        final isToday = i == days.length - 1;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            Fmt.weekday(days[i].key),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  isToday ? FontWeight.w800 : FontWeight.w500,
                              color: isToday
                                  ? AppPalette.primary
                                  : AppPalette.muted,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppPalette.ink,
                    getTooltipItem: (group, _, rod, __) => BarTooltipItem(
                      '${Fmt.steps(rod.toY.round())} steps',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                barGroups: [
                  for (var i = 0; i < days.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: days[i].value.steps.toDouble(),
                          width: 18,
                          borderRadius: BorderRadius.circular(8),
                          gradient: days[i].value.steps >= goal
                              ? AppPalette.fresh
                              : const LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Color(0xFF6366F1),
                                    Color(0xFF22D3EE),
                                  ],
                                ),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: maxY <= 0 ? 1 : maxY,
                            color: const Color(0xFFF1F4FA),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengeSummary extends StatelessWidget {
  final DayMetrics today;
  final Goals goals;
  final VoidCallback onTap;

  const _ChallengeSummary({
    required this.today,
    required this.goals,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        Icons.directions_walk_rounded,
        AppPalette.blue,
        today.steps / goals.steps
      ),
      (
        Icons.directions_run_rounded,
        AppPalette.green,
        today.runKm / goals.runKm
      ),
      (
        Icons.local_fire_department_rounded,
        AppPalette.orange,
        today.calories / goals.calories
      ),
      (
        Icons.bedtime_rounded,
        AppPalette.purple,
        today.sleepHours / goals.sleepHours
      ),
    ];
    final done = items.where((e) => e.$3 >= 1).length;

    return SurfaceCard(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$done of ${items.length} complete',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  done == items.length
                      ? 'Perfect day — every goal hit!'
                      : 'Keep going, you\'re on your way.',
                  style: const TextStyle(
                      color: AppPalette.inkSoft, fontSize: 12.5),
                ),
              ],
            ),
          ),
          for (final (icon, color, value) in items)
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: ProgressRing(
                progress: value.isFinite ? value : 0,
                size: 40,
                stroke: 4.5,
                colors: [color, color],
                trackColor: color.withValues(alpha: 0.14),
                child: Icon(icon, size: 17, color: color),
              ),
            ),
        ],
      ),
    );
  }
}
