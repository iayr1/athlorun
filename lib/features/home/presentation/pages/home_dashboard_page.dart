import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../config/themes/app_theme.dart';
import '../../../../core/services/metrics_store.dart';
import '../../../../core/services/step_tracker.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/ui_kit.dart';
import '../../../activity/presentation/pages/activity_history_page.dart';
import '../../../challenges/presentation/widgets/sleep_logger.dart';

/// Home tab, styled after the kit's "Home & Smart Health Metrics" screen.
class HomeDashboardPage extends StatelessWidget {
  /// Switches the bottom navigation to another tab.
  final ValueChanged<int> onNavigate;

  const HomeDashboardPage({super.key, required this.onNavigate});

  /// Average completion of the four daily goals, 0–100.
  static int score(DayMetrics today, Goals goals) {
    double part(double v, double goal) =>
        goal <= 0 ? 0 : (v / goal).clamp(0, 1);
    final total = part(today.steps.toDouble(), goals.steps.toDouble()) +
        part(today.runKm, goals.runKm) +
        part(today.calories, goals.calories) +
        part(today.sleepHours, goals.sleepHours);
    return (total / 4 * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    final store = MetricsStore.instance;
    return ListenableBuilder(
      listenable: Listenable.merge([store, StepTracker.instance]),
      builder: (context, _) {
        final today = store.today;
        final goals = store.goals;
        final s = score(today, goals);
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _Header(store: store, score: s)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
              sliver: SliverList.list(
                children: [
                  if (StepTracker.instance.permissionDenied) ...[
                    const _PermissionBanner(),
                    const SizedBox(height: 16),
                  ],
                  const _SectionTitle('Health Score'),
                  _ScoreCard(score: s),
                  const SizedBox(height: 24),
                  _SectionTitle(
                    'Smart Health Metrics',
                    action: 'See All',
                    onAction: () => onNavigate(3),
                  ),
                  _MetricTiles(store: store),
                  const SizedBox(height: 24),
                  _SectionTitle(
                    'Fitness & Activity Tracker',
                    action: 'Goals',
                    onAction: () => onNavigate(1),
                  ),
                  _TrackerList(
                    today: today,
                    goals: goals,
                    onSleep: () => showSleepLogger(context),
                    onSteps: () => onNavigate(3),
                    onChallenges: () => onNavigate(1),
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle('This Week'),
                  _WeeklyChart(store: store),
                  const SizedBox(height: 24),
                  _SectionTitle(
                    'Recent Workouts',
                    action: store.activities.isEmpty ? null : 'See All',
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

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const _SectionTitle(this.title, {this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(child: Text(title, style: AppText.textSmExtraBold)),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                action!,
                style: AppText.textSmSemiBold.copyWith(
                  color: AppPalette.blue60,
                  fontSize: 12,
                ),
              ),
            )
          else
            const Icon(Icons.more_horiz_rounded, color: AppPalette.gray40),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final MetricsStore store;
  final int score;

  const _Header({required this.store, required this.score});

  @override
  Widget build(BuildContext context) {
    final streak = store.streak;
    return Container(
      decoration: const BoxDecoration(
        color: AppPalette.gray80,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today_rounded,
                      color: AppPalette.gray30, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('EEE, d MMM yyyy').format(DateTime.now()),
                    style: AppText.textSmSemiBold.copyWith(
                      color: AppPalette.gray30,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.notifications_none_rounded,
                        color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppPalette.blue60,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      store.name.isEmpty ? 'A' : store.name[0].toUpperCase(),
                      style: AppText.textXlExtraBold.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, ${store.name.split(' ').first}! 👋',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.headingXs.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 12,
                          children: [
                            _HeaderChip(
                              icon: Icons.favorite_rounded,
                              color: AppPalette.blue20,
                              label: '$score%',
                            ),
                            _HeaderChip(
                              icon: Icons.local_fire_department_rounded,
                              color: AppPalette.amber,
                              label: streak == 0
                                  ? 'Start a streak'
                                  : '$streak day streak',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                '${Fmt.greeting(DateTime.now())}! Here’s your day so far.',
                style: AppText.paragraphSm.copyWith(color: AppPalette.gray30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _HeaderChip({
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppText.textSmSemiBold.copyWith(
            color: AppPalette.gray20,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final int score;

  const _ScoreCard({required this.score});

  @override
  Widget build(BuildContext context) {
    final message = score >= 100
        ? 'Every goal hit today. Outstanding!'
        : score >= 60
            ? 'Great progress — you’re well on track today.'
            : 'Based on your goals, there’s room to move more today.';
    return SurfaceCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppPalette.purple60, Color(0xFFB37BFF)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              '$score',
              style: AppText.headingXs.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AthloRun Score', style: AppText.textMdExtraBold),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: AppText.paragraphSm.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTiles extends StatelessWidget {
  final MetricsStore store;

  const _MetricTiles({required this.store});

  @override
  Widget build(BuildContext context) {
    final week = store.lastDays(7);
    final today = store.today;
    final tiles = [
      (
        'Steps',
        Icons.directions_walk_rounded,
        AppPalette.blue60,
        Fmt.steps(today.steps),
        'today',
        [for (final d in week) d.value.steps.toDouble()],
      ),
      (
        'Calories',
        Icons.local_fire_department_rounded,
        AppPalette.red50,
        today.calories.toStringAsFixed(0),
        'kcal',
        [for (final d in week) d.value.calories],
      ),
      (
        'Sleep',
        Icons.bedtime_rounded,
        AppPalette.cyan,
        today.sleepHours.toStringAsFixed(1),
        'hr',
        [for (final d in week) d.value.sleepHours],
      ),
      (
        'Distance',
        Icons.route_rounded,
        AppPalette.purple60,
        today.totalKm.toStringAsFixed(1),
        'km',
        [for (final d in week) d.value.totalKm],
      ),
    ];
    return SizedBox(
      height: 168,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: tiles.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final (label, icon, color, value, unit, series) = tiles[i];
          return Container(
            width: 136,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: AppText.textSmExtraBold.copyWith(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Icon(icon, color: Colors.white, size: 18),
                  ],
                ),
                const Spacer(),
                SizedBox(height: 48, child: _MiniBars(values: series)),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    text: value,
                    style: AppText.textXlExtraBold.copyWith(
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(
                        text: ' $unit',
                        style: AppText.textSmSemiBold.copyWith(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 11,
                        ),
                      ),
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

class _MiniBars extends StatelessWidget {
  final List<double> values;

  const _MiniBars({required this.values});

  @override
  Widget build(BuildContext context) {
    final max = values.fold<double>(0, (m, v) => v > m ? v : m);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < values.length; i++)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: FractionallySizedBox(
                heightFactor:
                    max <= 0 ? 0.08 : (values[i] / max).clamp(0.08, 1),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: i == values.length - 1 ? 1 : 0.45,
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _TrackerList extends StatelessWidget {
  final DayMetrics today;
  final Goals goals;
  final VoidCallback onSleep;
  final VoidCallback onSteps;
  final VoidCallback onChallenges;

  const _TrackerList({
    required this.today,
    required this.goals,
    required this.onSleep,
    required this.onSteps,
    required this.onChallenges,
  });

  @override
  Widget build(BuildContext context) {
    final stepsDone = today.steps >= goals.steps;
    final sleepPct = goals.sleepHours <= 0
        ? 0.0
        : (today.sleepHours / goals.sleepHours).clamp(0.0, 1.0);
    final caption = AppText.textSmSemiBold.copyWith(
      color: AppPalette.gray50,
      fontSize: 11,
    );
    return Column(
      children: [
        _TrackerRow(
          icon: Icons.local_fire_department_rounded,
          title: 'Calories Burned',
          onTap: onChallenges,
          below: Column(
            children: [
              const SizedBox(height: 8),
              GradientProgressBar(
                value:
                    goals.calories <= 0 ? 0 : today.calories / goals.calories,
                height: 6,
                gradient: AppPalette.fire,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text('${today.calories.toStringAsFixed(0)}kcal',
                      style: caption),
                  const Spacer(),
                  Text('${goals.calories.toStringAsFixed(0)}kcal',
                      style: caption),
                ],
              ),
            ],
          ),
        ),
        _TrackerRow(
          icon: Icons.directions_walk_rounded,
          title: 'Steps Taken',
          subtitle: 'You’ve taken ${Fmt.steps(today.steps)} of '
              '${Fmt.steps(goals.steps)} steps.',
          onTap: onSteps,
          trailing: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: stepsDone ? AppPalette.blue60 : AppPalette.blue10,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.check_rounded,
              size: 18,
              color: stepsDone ? Colors.white : AppPalette.blue60,
            ),
          ),
        ),
        _TrackerRow(
          icon: Icons.directions_run_rounded,
          title: 'Running',
          subtitle: '${today.runKm.toStringAsFixed(2)} of '
              '${goals.runKm.toStringAsFixed(1)} km today.',
          onTap: onChallenges,
          trailing: _RingBadge(
            value: goals.runKm <= 0 ? 0 : today.runKm / goals.runKm,
            color: AppPalette.green,
          ),
        ),
        _TrackerRow(
          icon: Icons.bedtime_rounded,
          title: 'Sleep',
          subtitle: today.sleepHours > 0
              ? '${today.sleepHours.toStringAsFixed(1)}h of '
                  '${goals.sleepHours.toStringAsFixed(0)}h goal · tap to edit'
              : 'Tap to log last night’s sleep.',
          onTap: onSleep,
          trailing: _RingBadge(value: sleepPct, color: AppPalette.purple60),
        ),
        _TrackerRow(
          icon: Icons.terrain_rounded,
          title: 'Climb',
          subtitle: '${today.climbM.toStringAsFixed(0)} m climbed today.',
          onTap: onSteps,
        ),
      ],
    );
  }
}

class _TrackerRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget? below;
  final VoidCallback onTap;

  const _TrackerRow({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailing,
    this.below,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SurfaceCard(
        padding: const EdgeInsets.all(12),
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppPalette.gray10,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppPalette.gray80, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.textSmExtraBold),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppText.paragraphSm.copyWith(fontSize: 11.5),
                    ),
                  ],
                  if (below != null) below!,
                ],
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 12), trailing!],
          ],
        ),
      ),
    );
  }
}

class _RingBadge extends StatelessWidget {
  final double value;
  final Color color;

  const _RingBadge({required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final v = value.isFinite ? value.clamp(0.0, 1.0) : 0.0;
    return ProgressRing(
      progress: v,
      size: 40,
      stroke: 4,
      colors: [color, color],
      trackColor: color.withValues(alpha: 0.15),
      child: Text(
        '${(v * 100).round()}%',
        style: AppText.textSmExtraBold.copyWith(fontSize: 9, color: color),
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
            icon: Icons.sensors_off_rounded,
            color: AppPalette.amber,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Allow physical activity access for accurate step counting.',
              style: AppText.textSmSemiBold.copyWith(fontSize: 13),
            ),
          ),
          TextButton(
            onPressed: StepTracker.instance.openSettings,
            child: const Text('Allow'),
          ),
        ],
      ),
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(Fmt.steps(total), style: AppText.headingXs),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('steps', style: AppText.paragraphSm),
              ),
              const Spacer(),
              Text(
                'avg ${Fmt.steps((total / 7).round())}/day',
                style: AppText.textSmExtraBold.copyWith(
                  color: AppPalette.blue60,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: BarChart(
              BarChartData(
                maxY: maxY <= 0 ? 1 : maxY,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: goal,
                      color: AppPalette.red50.withValues(alpha: 0.5),
                      strokeWidth: 1.2,
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
                      reservedSize: 26,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i < 0 || i >= days.length) {
                          return const SizedBox.shrink();
                        }
                        final isToday = i == days.length - 1;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            DateFormat('E').format(days[i].key),
                            style: AppText.textSmSemiBold.copyWith(
                              fontSize: 11,
                              color: isToday
                                  ? AppPalette.blue60
                                  : AppPalette.gray40,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppPalette.gray80,
                    getTooltipItem: (group, _, rod, __) => BarTooltipItem(
                      '${Fmt.steps(rod.toY.round())} steps',
                      const TextStyle(
                        fontFamily: AppText.family,
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
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                          color: days[i].value.steps >= goal
                              ? AppPalette.blue60
                              : AppPalette.blue20,
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: maxY <= 0 ? 1 : maxY,
                            color: AppPalette.gray10,
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
