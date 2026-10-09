import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../config/themes/app_theme.dart';
import '../../../../core/services/cloud_sync.dart';
import '../../../../core/services/metrics_store.dart';
import '../../../../core/widgets/kit.dart';

/// "Comprehensive Health Assessment" flow from the kit.
///
/// Answers are saved to `users/{uid}.assessment` in Firestore and used to
/// personalise weight and daily goals.
class AssessmentPage extends StatefulWidget {
  final VoidCallback onFinished;
  final HealthAssessment? initial;

  /// Persists the answers; defaults to [CloudSync.saveAssessment].
  final Future<void> Function(HealthAssessment)? onSave;

  const AssessmentPage({
    super.key,
    required this.onFinished,
    this.initial,
    this.onSave,
  });

  @override
  State<AssessmentPage> createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  static const _steps = 9;

  late HealthAssessment _a = widget.initial ??
      HealthAssessment(
        weightKg: MetricsStore.instance.weightKg,
        age: 25,
        bloodType: 'A+',
        fitnessLevel: 3,
        sleepLevel: 3,
        mood: 'Neutral',
      );
  int _step = 0;
  bool _saving = false;
  bool _useLbs = false;

  bool get _canContinue => switch (_step) {
        0 => _a.goal != null,
        1 => _a.gender != null,
        8 => _a.eatingHabit != null,
        _ => true,
      };

  void _back() {
    if (_step == 0) {
      Navigator.of(context).maybePop();
    } else {
      setState(() => _step--);
    }
  }

  Future<void> _next() async {
    if (_step < _steps - 1) {
      setState(() => _step++);
      return;
    }
    setState(() => _saving = true);
    try {
      final save = widget.onSave ?? CloudSync.instance.saveAssessment;
      await save(_a);
      await _applyGoals();
      widget.onFinished();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save your answers: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// Tunes the daily targets to the reported fitness and sleep levels.
  Future<void> _applyGoals() async {
    final store = MetricsStore.instance;
    final level = _a.fitnessLevel ?? 3;
    await store.updateGoals(store.goals.copyWith(
      steps: 4000 + level * 2000,
      runKm: (1.0 + level * 1.0),
      calories: 300.0 + level * 100,
      sleepHours: 8,
    ));
    if (_a.weightKg != null) {
      await store.updateProfile(weightKg: _a.weightKg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.gray10,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  KitIconButton(
                    icon: Icons.chevron_left_rounded,
                    onPressed: _back,
                    tooltip: 'Back',
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: KitProgressBar(value: (_step + 1) / _steps),
                  ),
                  const SizedBox(width: 32),
                  GestureDetector(
                    onTap: _saving ? null : _next,
                    behavior: HitTestBehavior.opaque,
                    child: Text('Skip', style: AppText.textMdSemiBold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween(
                      begin: const Offset(0.06, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: KeyedSubtree(
                  key: ValueKey(_step),
                  child: _buildStep(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: KitButton(
                label: _step == _steps - 1 ? 'Finish' : 'Continue',
                loading: _saving,
                onPressed: _canContinue ? _next : null,
                trailing: const Icon(Icons.arrow_forward_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep() {
    return switch (_step) {
      0 => _QuestionScaffold(
          title: 'What is your health goal for the app?',
          child: _OptionList(
            options: const [
              (Icons.favorite_rounded, 'I wanna get healthy'),
              (Icons.monitor_weight_rounded, 'I wanna lose weight'),
              (Icons.directions_run_rounded, 'I wanna run faster & further'),
              (Icons.bolt_rounded, 'I wanna build stamina'),
              (Icons.phone_iphone_rounded, 'Just trying out the app'),
            ],
            selected: _a.goal,
            onSelect: (v) => setState(() => _a = _a.copyWith(goal: v)),
          ),
        ),
      1 => _QuestionScaffold(
          title: 'What is your Gender?',
          subtitle: 'Please select your gender for better personalized '
              'health experience.',
          child: Column(
            children: [
              SizedBox(
                height: 260,
                child: Row(
                  children: [
                    for (final (icon, label) in const [
                      (Icons.male_rounded, 'I Am Male'),
                      (Icons.female_rounded, 'I Am Female'),
                    ]) ...[
                      Expanded(
                        child: _GenderCard(
                          icon: icon,
                          label: label,
                          selected: _a.gender == label,
                          onTap: () => setState(
                            () => _a = _a.copyWith(gender: label),
                          ),
                        ),
                      ),
                      if (label == 'I Am Male') const SizedBox(width: 12),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () => setState(
                  () => _a = _a.copyWith(gender: 'Prefer not to say'),
                ),
                icon: const Icon(Icons.close_rounded, size: 18),
                label: const Text('Prefer to skip this'),
              ),
            ],
          ),
        ),
      2 => _QuestionScaffold(
          title: 'What is your weight?',
          child: _WeightPicker(
            kg: _a.weightKg ?? 70,
            useLbs: _useLbs,
            onUnitChanged: (v) => setState(() => _useLbs = v),
            onChanged: (kg) => setState(() => _a = _a.copyWith(weightKg: kg)),
          ),
        ),
      3 => _QuestionScaffold(
          title: 'What is your age?',
          child: _AgeWheel(
            age: _a.age ?? 25,
            onChanged: (v) => setState(() => _a = _a.copyWith(age: v)),
          ),
        ),
      4 => _QuestionScaffold(
          title: 'What’s your official blood type?',
          child: _BloodTypePicker(
            value: _a.bloodType ?? 'A+',
            onChanged: (v) => setState(() => _a = _a.copyWith(bloodType: v)),
          ),
        ),
      5 => _QuestionScaffold(
          title: 'What is your current fitness level?',
          child: _LevelPicker(
            value: _a.fitnessLevel ?? 3,
            icon: Icons.fitness_center_rounded,
            labels: const [
              'Sedentary (little or no exercise)',
              'Light (1–2× exercise/week)',
              'Moderate (2–3× exercise/week)',
              'Active (4–5× exercise/week)',
              'Athlete (daily training)',
            ],
            onChanged: (v) => setState(() => _a = _a.copyWith(fitnessLevel: v)),
          ),
        ),
      6 => _QuestionScaffold(
          title: 'What is your current sleep level?',
          child: _LevelPicker(
            value: _a.sleepLevel ?? 3,
            icon: Icons.bedtime_rounded,
            labels: const [
              'Insomniac (less than 3h daily)',
              'Poor (3–4h daily)',
              'Moderate (5–6h daily)',
              'Good (7–8h daily)',
              'Excellent (8h+ daily)',
            ],
            onChanged: (v) => setState(() => _a = _a.copyWith(sleepLevel: v)),
          ),
        ),
      7 => _QuestionScaffold(
          title: 'What is your current emotion right now?',
          child: _MoodPicker(
            value: _a.mood ?? 'Neutral',
            onChanged: (v) => setState(() => _a = _a.copyWith(mood: v)),
          ),
        ),
      _ => _QuestionScaffold(
          title: 'What is your usual eating habits?',
          child: _EatingGrid(
            value: _a.eatingHabit,
            onChanged: (v) => setState(() => _a = _a.copyWith(eatingHabit: v)),
          ),
        ),
    };
  }
}

class _QuestionScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const _QuestionScaffold({
    required this.title,
    required this.child,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
      children: [
        Text(title, style: AppText.headingSm),
        if (subtitle != null) ...[
          const SizedBox(height: 12),
          Text(subtitle!, style: AppText.paragraphMd),
        ],
        const SizedBox(height: 40),
        child,
      ],
    );
  }
}

class _OptionList extends StatelessWidget {
  final List<(IconData, String)> options;
  final String? selected;
  final ValueChanged<String> onSelect;

  const _OptionList({
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final (icon, label) in options) ...[
          KitOptionTile(
            icon: icon,
            label: label,
            selected: selected == label,
            onTap: () => onSelect(label),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _GenderCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _GenderCard({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fg = selected ? Colors.white : AppPalette.gray80;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppPalette.blue60 : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: selected
              ? AppPalette.focusRing(AppPalette.blue60)
              : AppPalette.softShadow(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: fg, size: 20),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    label,
                    style: AppText.textSmExtraBold.copyWith(color: fg),
                  ),
                ),
                Icon(
                  selected
                      ? Icons.check_box_rounded
                      : Icons.check_box_outline_blank_rounded,
                  color: fg,
                  size: 22,
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: Icon(
                  icon,
                  size: 120,
                  color: selected
                      ? Colors.white.withValues(alpha: 0.9)
                      : AppPalette.blue20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Segmented extends StatelessWidget {
  final List<String> items;
  final String value;
  final ValueChanged<String> onChanged;

  const _Segmented({
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          for (final item in items)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(item),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: item == value ? AppPalette.blue60 : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item,
                    style: AppText.textSmExtraBold.copyWith(
                      color: item == value ? Colors.white : AppPalette.gray60,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _WeightPicker extends StatelessWidget {
  final double kg;
  final bool useLbs;
  final ValueChanged<bool> onUnitChanged;
  final ValueChanged<double> onChanged;

  const _WeightPicker({
    required this.kg,
    required this.useLbs,
    required this.onUnitChanged,
    required this.onChanged,
  });

  static const _lbPerKg = 2.20462;

  @override
  Widget build(BuildContext context) {
    final value = useLbs ? kg * _lbPerKg : kg;
    final min = useLbs ? 66.0 : 30.0;
    final max = useLbs ? 440.0 : 200.0;
    return Column(
      children: [
        _Segmented(
          items: const ['kg', 'lbs'],
          value: useLbs ? 'lbs' : 'kg',
          onChanged: (v) => onUnitChanged(v == 'lbs'),
        ),
        const SizedBox(height: 48),
        Text.rich(
          TextSpan(
            text: value.round().toString(),
            style: AppText.headingSm.copyWith(fontSize: 64, height: 1),
            children: [
              TextSpan(
                text: ' ${useLbs ? 'lbs' : 'kg'}',
                style: AppText.textXlExtraBold.copyWith(
                  color: AppPalette.gray50,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _Ruler(
          value: value.clamp(min, max).toDouble(),
          min: min,
          max: max,
          onChanged: (v) => onChanged(useLbs ? v / _lbPerKg : v),
        ),
      ],
    );
  }
}

/// Horizontal tick ruler with a fixed centre indicator.
class _Ruler extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const _Ruler({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  State<_Ruler> createState() => _RulerState();
}

class _RulerState extends State<_Ruler> {
  static const _tick = 12.0;
  late final ScrollController _controller;
  int _last = -1;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController(
      initialScrollOffset: (widget.value - widget.min) * _tick,
    );
  }

  @override
  void didUpdateWidget(covariant _Ruler old) {
    super.didUpdateWidget(old);
    if (old.min != widget.min && _controller.hasClients) {
      _controller.jumpTo((widget.value - widget.min) * _tick);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = (widget.max - widget.min).round() + 1;
    return LayoutBuilder(
      builder: (context, constraints) {
        final half = constraints.maxWidth / 2;
        return SizedBox(
          height: 96,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              NotificationListener<ScrollNotification>(
                onNotification: (n) {
                  final v = (widget.min + _controller.offset / _tick)
                      .round()
                      .clamp(widget.min.toInt(), widget.max.toInt());
                  if (v != _last) {
                    _last = v;
                    HapticFeedback.selectionClick();
                    widget.onChanged(v.toDouble());
                  }
                  return false;
                },
                child: ListView.builder(
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: half - _tick / 2),
                  itemExtent: _tick,
                  itemCount: count,
                  physics: const _SnapPhysics(_tick),
                  itemBuilder: (context, i) {
                    final major = (widget.min.round() + i) % 10 == 0;
                    return Column(
                      children: [
                        const SizedBox(height: 16),
                        Container(
                          width: 2,
                          height: major ? 40 : 24,
                          color: major ? AppPalette.gray50 : AppPalette.gray30,
                        ),
                        if (major) ...[
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 14,
                            child: OverflowBox(
                              maxWidth: 40,
                              child: Text(
                                '${widget.min.round() + i}',
                                style: AppText.labelXs,
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
              IgnorePointer(
                child: Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: AppPalette.blue60,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(width: 4, height: 56, color: AppPalette.blue60),
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

class _SnapPhysics extends ScrollPhysics {
  final double step;

  const _SnapPhysics(this.step, {super.parent});

  @override
  _SnapPhysics applyTo(ScrollPhysics? ancestor) =>
      _SnapPhysics(step, parent: buildParent(ancestor));

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    final target = ((position.pixels + velocity * 0.2) / step).round() * step;
    final clamped = target
        .clamp(position.minScrollExtent, position.maxScrollExtent)
        .toDouble();
    if ((clamped - position.pixels).abs() < 0.5) return null;
    return ScrollSpringSimulation(
      spring,
      position.pixels,
      clamped,
      velocity,
      tolerance: toleranceFor(position),
    );
  }
}

class _AgeWheel extends StatelessWidget {
  final int age;
  final ValueChanged<int> onChanged;

  const _AgeWheel({required this.age, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 140,
            height: 120,
            decoration: BoxDecoration(
              color: AppPalette.blue60,
              borderRadius: BorderRadius.circular(24),
              boxShadow: AppPalette.focusRing(AppPalette.blue60),
            ),
          ),
          ListWheelScrollView.useDelegate(
            controller: FixedExtentScrollController(initialItem: age - 10),
            itemExtent: 120,
            diameterRatio: 3,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (i) {
              HapticFeedback.selectionClick();
              onChanged(i + 10);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: 91,
              builder: (context, i) {
                final selected = i + 10 == age;
                return Center(
                  child: Text(
                    '${i + 10}',
                    style: AppText.headingSm.copyWith(
                      fontSize: selected ? 72 : 44,
                      height: 1,
                      color: selected ? Colors.white : AppPalette.gray30,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BloodTypePicker extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _BloodTypePicker({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final group = value.replaceAll(RegExp(r'[+-]'), '');
    final positive = value.endsWith('+');
    return Column(
      children: [
        _Segmented(
          items: const ['A', 'B', 'AB', 'O'],
          value: group,
          onChanged: (g) => onChanged('$g${positive ? '+' : '-'}'),
        ),
        const SizedBox(height: 48),
        Text.rich(
          TextSpan(
            text: group,
            style: AppText.headingSm.copyWith(fontSize: 120, height: 1),
            children: [
              TextSpan(
                text: positive ? '+' : '−',
                style: AppText.headingSm.copyWith(
                  fontSize: 64,
                  color: AppPalette.red50,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),
        Row(
          children: [
            Expanded(
              child: KitButton(
                label: '+',
                background: positive ? AppPalette.blue60 : AppPalette.gray20,
                foreground: positive ? Colors.white : AppPalette.gray60,
                onPressed: () => onChanged('$group+'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: KitButton(
                label: '−',
                background: !positive ? AppPalette.blue60 : AppPalette.gray20,
                foreground: !positive ? Colors.white : AppPalette.gray60,
                onPressed: () => onChanged('$group-'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LevelPicker extends StatelessWidget {
  final int value;
  final IconData icon;
  final List<String> labels;
  final ValueChanged<int> onChanged;

  const _LevelPicker({
    required this.value,
    required this.icon,
    required this.labels,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppPalette.blue10,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 72, color: AppPalette.blue60),
              const SizedBox(width: 16),
              Text(
                '$value',
                style: AppText.headingSm.copyWith(fontSize: 120, height: 1),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppPalette.gray80,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              for (var i = 1; i <= 5; i++)
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      onChanged(i);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      height: 48,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: i <= value
                            ? (i == value ? Colors.white : AppPalette.gray60)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: i == value
                          ? const Icon(
                              Icons.keyboard_double_arrow_right_rounded,
                              color: AppPalette.gray80)
                          : null,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text.rich(
          TextSpan(
            text: 'Level $value ',
            style: AppText.textSmExtraBold,
            children: [
              TextSpan(
                text: labels[value - 1],
                style: AppText.paragraphSm,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _MoodPicker extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _MoodPicker({required this.value, required this.onChanged});

  static const _moods = [
    (Icons.sentiment_very_dissatisfied_rounded, 'Sad'),
    (Icons.sentiment_dissatisfied_rounded, 'Down'),
    (Icons.sentiment_neutral_rounded, 'Neutral'),
    (Icons.sentiment_satisfied_rounded, 'Happy'),
    (Icons.sentiment_very_satisfied_rounded, 'Overjoyed'),
  ];

  @override
  Widget build(BuildContext context) {
    final index = _moods.indexWhere((m) => m.$2 == value).clamp(0, 4);
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: PageController(
              viewportFraction: 0.45,
              initialPage: index,
            ),
            itemCount: _moods.length,
            onPageChanged: (i) {
              HapticFeedback.selectionClick();
              onChanged(_moods[i].$2);
            },
            itemBuilder: (context, i) {
              final selected = i == index;
              return AnimatedScale(
                scale: selected ? 1 : 0.7,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: selected ? AppPalette.blue60 : AppPalette.gray20,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: selected
                        ? AppPalette.focusRing(AppPalette.blue60)
                        : null,
                  ),
                  child: Icon(
                    _moods[i].$1,
                    size: 96,
                    color: selected ? Colors.white : AppPalette.gray40,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        const Icon(Icons.arrow_drop_up_rounded, color: AppPalette.gray80),
        const SizedBox(height: 8),
        Text(
          'I’m feeling ${value.toLowerCase()}.',
          style: AppText.textXlExtraBold.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _EatingGrid extends StatelessWidget {
  final String? value;
  final ValueChanged<String> onChanged;

  const _EatingGrid({required this.value, required this.onChanged});

  static const _options = [
    (Icons.restaurant_rounded, 'Balanced Diet'),
    (Icons.eco_rounded, 'Mostly Vegetarian'),
    (Icons.set_meal_rounded, 'Low Carb'),
    (Icons.grain_rounded, 'Gluten Free'),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.95,
      children: [
        for (final (icon, label) in _options)
          GestureDetector(
            onTap: () => onChanged(label),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: value == label ? AppPalette.red50 : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: value == label
                    ? AppPalette.focusRing(AppPalette.red50)
                    : AppPalette.softShadow(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    color: value == label ? Colors.white : AppPalette.gray80,
                  ),
                  const Spacer(),
                  Text(
                    label,
                    style: AppText.textSmSemiBold.copyWith(
                      color: value == label ? Colors.white : AppPalette.gray80,
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
