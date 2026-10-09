import 'package:flutter/material.dart';

import 'package:athlorun/config/themes/app_theme.dart';
import 'package:athlorun/core/services/auth_service.dart';
import 'package:athlorun/core/services/cloud_sync.dart';
import 'package:athlorun/core/services/metrics_store.dart';
import 'package:athlorun/core/utils/formatters.dart';
import 'package:athlorun/core/widgets/ui_kit.dart';
import 'package:athlorun/features/activity/presentation/pages/activity_history_page.dart';
import 'package:athlorun/features/assessment/presentation/pages/assessment_page.dart';

/// Profile tab: lifetime stats, personal bests, goals and app data.
class AthleteProfilePage extends StatelessWidget {
  const AthleteProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = MetricsStore.instance;
    return ListenableBuilder(
      listenable: Listenable.merge([store, CloudSync.instance]),
      builder: (context, _) {
        final activities = store.activities;
        final longest = activities.isEmpty
            ? null
            : activities.reduce((a, b) => a.distanceKm >= b.distanceKm ? a : b);
        final runs = activities
            .where((a) => a.kind == ActivityKind.run && a.paceMinPerKm != null)
            .toList();
        final fastest = runs.isEmpty
            ? null
            : runs.reduce((a, b) => a.paceMinPerKm! <= b.paceMinPerKm! ? a : b);
        final goals = store.goals;

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _ProfileHeader(store: store)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              sliver: SliverList.list(
                children: [
                  const SectionHeader(title: 'Personal bests'),
                  Row(
                    children: [
                      Expanded(
                        child: StatTile(
                          icon: Icons.straighten_rounded,
                          color: AppPalette.blue,
                          value: longest == null
                              ? '—'
                              : '${Fmt.km(longest.distanceKm)} km',
                          label: 'Longest workout',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatTile(
                          icon: Icons.bolt_rounded,
                          color: AppPalette.pink,
                          value: fastest == null
                              ? '—'
                              : '${Fmt.pace(fastest.paceMinPerKm)} /km',
                          label: 'Fastest run pace',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'Daily goals'),
                  SurfaceCard(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      children: [
                        _SettingTile(
                          icon: Icons.directions_walk_rounded,
                          color: AppPalette.blue,
                          title: 'Steps',
                          value: Fmt.steps(goals.steps),
                          onTap: () => _editGoal(
                            context,
                            title: 'Daily step goal',
                            value: goals.steps.toDouble(),
                            min: 2000,
                            max: 30000,
                            divisions: 56,
                            format: (v) => '${Fmt.steps(v.round())} steps',
                            onSave: (v) => store.updateGoals(
                              goals.copyWith(steps: v.round()),
                            ),
                          ),
                        ),
                        _SettingTile(
                          icon: Icons.directions_run_rounded,
                          color: AppPalette.green,
                          title: 'Running distance',
                          value: '${goals.runKm.toStringAsFixed(1)} km',
                          onTap: () => _editGoal(
                            context,
                            title: 'Daily running goal',
                            value: goals.runKm,
                            min: 1,
                            max: 42,
                            divisions: 82,
                            format: (v) => '${v.toStringAsFixed(1)} km',
                            onSave: (v) =>
                                store.updateGoals(goals.copyWith(runKm: v)),
                          ),
                        ),
                        _SettingTile(
                          icon: Icons.local_fire_department_rounded,
                          color: AppPalette.orange,
                          title: 'Calories',
                          value: '${goals.calories.toStringAsFixed(0)} kcal',
                          onTap: () => _editGoal(
                            context,
                            title: 'Daily calorie goal',
                            value: goals.calories,
                            min: 100,
                            max: 2000,
                            divisions: 38,
                            format: (v) => '${v.toStringAsFixed(0)} kcal',
                            onSave: (v) =>
                                store.updateGoals(goals.copyWith(calories: v)),
                          ),
                        ),
                        _SettingTile(
                          icon: Icons.bedtime_rounded,
                          color: AppPalette.purple,
                          title: 'Sleep',
                          value: '${goals.sleepHours.toStringAsFixed(1)} h',
                          onTap: () => _editGoal(
                            context,
                            title: 'Nightly sleep goal',
                            value: goals.sleepHours,
                            min: 5,
                            max: 11,
                            divisions: 12,
                            format: (v) => '${v.toStringAsFixed(1)} hours',
                            onSave: (v) => store
                                .updateGoals(goals.copyWith(sleepHours: v)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'Account'),
                  SurfaceCard(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      children: [
                        _SettingTile(
                          icon: Icons.history_rounded,
                          color: AppPalette.primary,
                          title: 'Workout history',
                          value: '${activities.length}',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ActivityHistoryPage(),
                            ),
                          ),
                        ),
                        _SettingTile(
                          icon: Icons.monitor_weight_outlined,
                          color: AppPalette.cyan,
                          title: 'Body weight',
                          value: '${store.weightKg.toStringAsFixed(0)} kg',
                          onTap: () => _editGoal(
                            context,
                            title: 'Body weight',
                            subtitle: 'Used to estimate calories burned',
                            value: store.weightKg.clamp(30, 200).toDouble(),
                            min: 30,
                            max: 200,
                            divisions: 170,
                            format: (v) => '${v.toStringAsFixed(0)} kg',
                            onSave: (v) => store.updateProfile(weightKg: v),
                          ),
                        ),
                        _SettingTile(
                          icon: Icons.assignment_outlined,
                          color: AppPalette.purple,
                          title: 'Health assessment',
                          value: CloudSync.instance.profile?.assessment?.goal ==
                                  null
                              ? null
                              : 'Retake',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AssessmentPage(
                                initial: CloudSync.instance.profile?.assessment,
                                onFinished: () => Navigator.of(context).pop(),
                              ),
                            ),
                          ),
                        ),
                        _SettingTile(
                          icon: Icons.delete_sweep_outlined,
                          color: AppPalette.red,
                          title: 'Clear all data',
                          onTap: () => _confirmClear(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'Signed in'),
                  SurfaceCard(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const IconBadge(
                            icon: Icons.mail_outline_rounded,
                            color: AppPalette.blue,
                            size: 40,
                          ),
                          title: Text(
                            CloudSync.instance.profile?.email ??
                                'Local account',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            CloudSync.instance.profile == null
                                ? 'Data stays on this device'
                                : 'Synced with Firebase',
                          ),
                        ),
                        if (CloudSync.instance.profile != null)
                          _SettingTile(
                            icon: Icons.logout_rounded,
                            color: AppPalette.red,
                            title: 'Sign out',
                            onTap: () => _confirmSignOut(context),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Center(
                    child: Text(
                      'AthloRun · v1.0.0',
                      style: TextStyle(color: AppPalette.muted, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text(
          'Your data is saved to your account. You can sign back in anytime.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (ok == true) await AuthService.instance.signOut();
  }

  Future<void> _confirmClear(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all data?'),
        content: const Text(
          'This permanently removes your step history, workouts, sleep logs '
          'and goals from this device and your account.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppPalette.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await MetricsStore.instance.clearAll();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All data cleared')),
        );
      }
    }
  }
}

Future<void> _editGoal(
  BuildContext context, {
  required String title,
  String? subtitle,
  required double value,
  required double min,
  required double max,
  required int divisions,
  required String Function(double) format,
  required ValueChanged<double> onSave,
}) async {
  var current = value.clamp(min, max).toDouble();
  final result = await showModalBottomSheet<double>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setSheetState) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(color: AppPalette.inkSoft)),
              ],
              const SizedBox(height: 24),
              Text(
                format(current),
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: AppPalette.primary,
                  letterSpacing: -1,
                ),
              ),
              Slider(
                value: current,
                min: min,
                max: max,
                divisions: divisions,
                onChanged: (v) => setSheetState(() => current = v),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context, current),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  if (result != null) onSave(result);
}

class _ProfileHeader extends StatelessWidget {
  final MetricsStore store;

  const _ProfileHeader({required this.store});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppPalette.hero,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.6),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 44,
                  backgroundColor: Colors.white,
                  child: Text(
                    _initials(store.name),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: AppPalette.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      store.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Edit name',
                    onPressed: () => _editName(context),
                    icon: const Icon(Icons.edit_rounded,
                        color: Colors.white, size: 20),
                  ),
                ],
              ),
              Text(
                '${store.streak} day streak · ${store.activities.length} workouts',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.85)),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    _HeaderStat(
                      value: Fmt.steps(store.lifetimeSteps),
                      label: 'Total steps',
                    ),
                    _HeaderStat(
                      value: store.lifetimeKm.toStringAsFixed(1),
                      label: 'Total km',
                    ),
                    _HeaderStat(
                      value: store.activities
                          .fold<double>(0, (s, a) => s + a.calories)
                          .toStringAsFixed(0),
                      label: 'Workout kcal',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    final letters = parts.take(2).map((p) => p[0].toUpperCase()).join();
    return letters.isEmpty ? 'A' : letters;
  }

  Future<void> _editName(BuildContext context) async {
    final controller = TextEditingController(text: store.name);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Your name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: 'Enter your name'),
          onSubmitted: (v) => Navigator.pop(context, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name != null) await store.updateProfile(name: name);
  }
}

class _HeaderStat extends StatelessWidget {
  final String value;
  final String label;

  const _HeaderStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String? value;
  final VoidCallback onTap;

  const _SettingTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.onTap,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: IconBadge(icon: icon, color: color, size: 40),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            Text(
              value!,
              style: const TextStyle(
                color: AppPalette.inkSoft,
                fontWeight: FontWeight.w600,
              ),
            ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right_rounded, color: AppPalette.muted),
        ],
      ),
    );
  }
}
