import 'package:flutter/material.dart';

import 'package:athlorun/config/themes/app_theme.dart';
import 'package:athlorun/core/services/metrics_store.dart';
import 'package:athlorun/core/utils/formatters.dart';
import 'package:athlorun/core/widgets/ui_kit.dart';
import 'package:athlorun/features/challenges/presentation/widgets/sleep_logger.dart';

class DailyChallengesScreen extends StatelessWidget {
  const DailyChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = MetricsStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final today = store.today;
        final goals = store.goals;
        final challenges = [
          _Challenge(
            icon: Icons.directions_walk_rounded,
            gradient: AppPalette.hero,
            title: '${Fmt.steps(goals.steps)} steps',
            subtitle: 'Walk your way to the daily step goal',
            current: today.steps.toDouble(),
            target: goals.steps.toDouble(),
            unit: 'steps',
            format: (v) => Fmt.steps(v.round()),
          ),
          _Challenge(
            icon: Icons.directions_run_rounded,
            gradient: AppPalette.fresh,
            title: 'Run ${goals.runKm.toStringAsFixed(1)} km',
            subtitle: 'Tracked runs and running steps count',
            current: today.runKm,
            target: goals.runKm,
            unit: 'km',
            format: (v) => v.toStringAsFixed(2),
          ),
          _Challenge(
            icon: Icons.local_fire_department_rounded,
            gradient: AppPalette.fire,
            title: 'Burn ${goals.calories.toStringAsFixed(0)} kcal',
            subtitle: 'Calories from walking, running and rides',
            current: today.calories,
            target: goals.calories,
            unit: 'kcal',
            format: (v) => v.toStringAsFixed(0),
          ),
          _Challenge(
            icon: Icons.bedtime_rounded,
            gradient: AppPalette.dream,
            title: 'Sleep ${goals.sleepHours.toStringAsFixed(1)} hours',
            subtitle: 'Recovery is part of the training',
            current: today.sleepHours,
            target: goals.sleepHours,
            unit: 'h',
            format: (v) => v.toStringAsFixed(1),
            actionLabel: today.sleepHours > 0 ? 'Edit' : 'Log sleep',
            onAction: () => showSleepLogger(context),
          ),
        ];
        final completed = challenges.where((c) => c.isDone).length;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              const SliverAppBar(
                pinned: true,
                backgroundColor: AppPalette.background,
                title: Text('Daily Challenges'),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                sliver: SliverList.list(
                  children: [
                    _OverviewCard(
                      completed: completed,
                      total: challenges.length,
                      streak: store.streak,
                    ),
                    const SizedBox(height: 22),
                    const SectionHeader(title: 'Today\'s goals'),
                    for (final c in challenges) ...[
                      _ChallengeCard(challenge: c),
                      const SizedBox(height: 14),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      'Goals reset every midnight. Adjust targets from your profile.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppPalette.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Challenge {
  final IconData icon;
  final LinearGradient gradient;
  final String title;
  final String subtitle;
  final double current;
  final double target;
  final String unit;
  final String Function(double) format;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _Challenge({
    required this.icon,
    required this.gradient,
    required this.title,
    required this.subtitle,
    required this.current,
    required this.target,
    required this.unit,
    required this.format,
    this.actionLabel,
    this.onAction,
  });

  double get progress => target <= 0 ? 0 : (current / target).clamp(0, 1);
  bool get isDone => target > 0 && current >= target;
}

class _OverviewCard extends StatelessWidget {
  final int completed;
  final int total;
  final int streak;

  const _OverviewCard({
    required this.completed,
    required this.total,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    final allDone = completed == total;
    return GradientCard(
      gradient: AppPalette.night,
      child: Row(
        children: [
          ProgressRing(
            progress: completed / total,
            size: 96,
            stroke: 10,
            colors: const [
              Color(0xFF22D3EE),
              Color(0xFFA78BFA),
              Color(0xFF22D3EE)
            ],
            trackColor: Colors.white.withValues(alpha: 0.12),
            child: Text(
              '$completed/$total',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  allDone ? 'All challenges done!' : 'Keep pushing',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  allDone
                      ? 'You completed every goal today. Legendary.'
                      : '${total - completed} challenge${total - completed == 1 ? '' : 's'} left for today',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.75)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department_rounded,
                        color: Color(0xFFFDBA74), size: 18),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '$streak day step streak',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final _Challenge challenge;

  const _ChallengeCard({required this.challenge});

  @override
  Widget build(BuildContext context) {
    final c = challenge;
    final color = c.gradient.colors.first;
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: c.gradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(c.icon, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      c.subtitle,
                      style: const TextStyle(
                        color: AppPalette.inkSoft,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              if (c.isDone)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppPalette.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: Colors.white, size: 18),
                ),
            ],
          ),
          const SizedBox(height: 16),
          GradientProgressBar(value: c.progress, gradient: c.gradient),
          const SizedBox(height: 10),
          Row(
            children: [
              Flexible(
                child: Text.rich(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: c.format(c.current),
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: color,
                        ),
                      ),
                      TextSpan(
                        text: ' / ${c.format(c.target)} ${c.unit}',
                        style: const TextStyle(color: AppPalette.inkSoft),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (c.onAction != null)
                TextButton.icon(
                  onPressed: c.onAction,
                  style: TextButton.styleFrom(
                    foregroundColor: color,
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: const Icon(Icons.edit_calendar_rounded, size: 18),
                  label: Text(c.actionLabel ?? ''),
                )
              else
                Text(
                  '${(c.progress * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppPalette.inkSoft,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
