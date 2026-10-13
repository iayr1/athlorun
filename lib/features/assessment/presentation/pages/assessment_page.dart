import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../config/themes/app_theme.dart';
import '../../../../core/services/cloud_sync.dart';
import '../../../../core/services/metrics_store.dart';
import '../../../../core/widgets/kit.dart';
import '../widgets/ai_analysis_steps.dart';
import '../widgets/medication_picker.dart';

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

/// Screens of the flow, in order.
enum _Step {
  goal,
  gender,
  weight,
  age,
  bloodType,
  fitness,
  bodyIntro,
  bodyScan,
  sleep,
  mood,
  eating,
  medications,
  symptoms,
  notes,
  voice,
}

class _AssessmentPageState extends State<AssessmentPage> {
  static final _steps = _Step.values.length;

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

  _Step get _current => _Step.values[_step];

  bool get _canContinue => switch (_current) {
        _Step.goal => _a.goal != null,
        _Step.gender => _a.gender != null,
        _Step.eating => _a.eatingHabit != null,
        _ => true,
      };

  void _goTo(_Step step) => setState(() => _step = step.index);

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
    if (_current == _Step.bodyScan) {
      return Scaffold(
        backgroundColor: AppPalette.gray10,
        body: BodyScanStep(
          onBack: _back,
          onSkip: _next,
          onComplete: () {
            _a = _a.copyWith(bodyScanCompleted: true);
            _next();
          },
        ),
      );
    }
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
    return switch (_current) {
      _Step.goal => _QuestionScaffold(
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
      _Step.gender => _QuestionScaffold(
          title: 'What is your Gender?',
          subtitle: 'Please select your gender for better personalized '
              'health experience.',
          child: _GenderPicker(
            value: _a.gender,
            onChanged: (v) => setState(() => _a = _a.copyWith(gender: v)),
            onSkip: () {
              setState(() => _a = _a.copyWith(gender: 'Prefer not to say'));
              _next();
            },
          ),
        ),
      _Step.weight => _QuestionScaffold(
          title: 'What is your weight?',
          child: _WeightPicker(
            kg: _a.weightKg ?? 70,
            useLbs: _useLbs,
            onUnitChanged: (v) => setState(() => _useLbs = v),
            onChanged: (kg) => setState(() => _a = _a.copyWith(weightKg: kg)),
          ),
        ),
      _Step.age => _QuestionScaffold(
          title: 'What is your age?',
          child: _AgeWheel(
            age: _a.age ?? 25,
            onChanged: (v) => setState(() => _a = _a.copyWith(age: v)),
          ),
        ),
      _Step.bloodType => _QuestionScaffold(
          title: 'What’s your official blood type?',
          child: _BloodTypePicker(
            value: _a.bloodType ?? 'A+',
            onChanged: (v) => setState(() => _a = _a.copyWith(bloodType: v)),
          ),
        ),
      _Step.fitness => _QuestionScaffold(
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
      _Step.sleep => _QuestionScaffold(
          title: 'What is your current sleep level?',
          child: _SleepSlider(
            value: _a.sleepLevel ?? 3,
            onChanged: (v) => setState(() => _a = _a.copyWith(sleepLevel: v)),
          ),
        ),
      _Step.mood => _QuestionScaffold(
          title: 'What is your current emotion right now?',
          child: _MoodPicker(
            value: _a.mood ?? 'Neutral',
            onChanged: (v) => setState(() => _a = _a.copyWith(mood: v)),
          ),
        ),
      _Step.eating => _QuestionScaffold(
          title: 'What is your usual eating habits?',
          child: _EatingGrid(
            value: _a.eatingHabit,
            onChanged: (v) => setState(() => _a = _a.copyWith(eatingHabit: v)),
          ),
        ),
      _Step.bodyIntro => const _QuestionScaffold(
          title: 'AI Body Analysis',
          subtitle: 'Now we’ll scan your body for better assessment. '
              'Please ensure the following:',
          child: BodyAnalysisIntro(),
        ),
      // Rendered full-screen in build().
      _Step.bodyScan => const SizedBox.shrink(),
      _Step.medications => _QuestionScaffold(
          title: 'What medications do you take?',
          child: MedicationPicker(
            selected: _a.medications,
            onChanged: (v) => setState(() => _a = _a.copyWith(medications: v)),
          ),
        ),
      _Step.symptoms => _QuestionScaffold(
          title: 'Do you have any symptoms/allergy?',
          child: SymptomInput(
            tags: _a.symptoms,
            onChanged: (v) => setState(() => _a = _a.copyWith(symptoms: v)),
          ),
        ),
      _Step.notes => _QuestionScaffold(
          title: 'Textual AI Health Analysis',
          subtitle: 'Write any ongoing health conditions you have right now. '
              'We’ll highlight the symptoms we spot.',
          child: HealthNotesInput(
            initial: _a.healthNotes,
            onChanged: (v) => _a = _a.copyWith(healthNotes: v),
            onUseVoice: () => _goTo(_Step.voice),
          ),
        ),
      _Step.voice => _QuestionScaffold(
          title: 'Voice AI Analysis',
          subtitle: 'Please say the following words below. Don’t worry, '
              'we don’t record or store your voice.',
          child: VoiceAnalysis(
            completed: _a.voiceSampleCompleted,
            onCompleted: () => setState(
              () => _a = _a.copyWith(voiceSampleCompleted: true),
            ),
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

/// Gender carousel: coloured cards, the centred one is selected.
class _GenderPicker extends StatefulWidget {
  final String? value;
  final ValueChanged<String> onChanged;
  final VoidCallback onSkip;

  const _GenderPicker({
    required this.value,
    required this.onChanged,
    required this.onSkip,
  });

  @override
  State<_GenderPicker> createState() => _GenderPickerState();
}

class _GenderPickerState extends State<_GenderPicker> {
  static const _options = [
    (Icons.female_rounded, 'I Am Female', AppPalette.red50),
    (Icons.male_rounded, 'I Am Male', AppPalette.blue60),
    (Icons.transgender_rounded, 'I Am Non-binary', AppPalette.purple60),
  ];

  // Centre the current answer, or "Male" (the middle card) when unanswered.
  late final PageController _pages = PageController(
    viewportFraction: 0.62,
    initialPage: switch (_options.indexWhere((o) => o.$2 == widget.value)) {
      -1 => 1,
      final i => i,
    },
  );

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _select(int i) {
    HapticFeedback.selectionClick();
    widget.onChanged(_options[i].$2);
    _pages.animateToPage(
      i,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: OverflowBox(
            // Bleed the carousel to the screen edges like the kit.
            maxWidth: MediaQuery.sizeOf(context).width,
            child: PageView.builder(
              controller: _pages,
              itemCount: _options.length,
              onPageChanged: (i) {
                HapticFeedback.selectionClick();
                widget.onChanged(_options[i].$2);
              },
              itemBuilder: (context, i) {
                final (icon, label, color) = _options[i];
                final selected = widget.value == label;
                return AnimatedBuilder(
                  animation: _pages,
                  builder: (context, child) {
                    final page =
                        _pages.hasClients && _pages.position.haveDimensions
                            ? _pages.page!
                            : _pages.initialPage.toDouble();
                    final t = (1 - (page - i).abs()).clamp(0.0, 1.0);
                    return Transform.scale(
                        scale: 0.86 + 0.14 * t, child: child);
                  },
                  child: _GenderCard(
                    icon: icon,
                    label: label,
                    color: color,
                    selected: selected,
                    onTap: () => _select(i),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: Material(
            color: AppPalette.blue10,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: widget.onSkip,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Prefer to skip this',
                    style: AppText.textSmExtraBold
                        .copyWith(color: AppPalette.blue60),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: AppPalette.blue60,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GenderCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _GenderCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: selected ? AppPalette.focusRing(color) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    label,
                    style:
                        AppText.textSmExtraBold.copyWith(color: Colors.white),
                  ),
                ),
                Icon(
                  selected
                      ? Icons.check_box_rounded
                      : Icons.check_box_outline_blank_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ],
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    icon,
                    size: 150,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                  const Align(
                    alignment: Alignment(0.8, -0.7),
                    child: Icon(Icons.auto_awesome_rounded,
                        color: Colors.white, size: 28),
                  ),
                  const Align(
                    alignment: Alignment(-0.8, 0.7),
                    child: Icon(Icons.auto_awesome_rounded,
                        color: Colors.white, size: 20),
                  ),
                ],
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
                    color: item == value ? AppPalette.gray80 : Colors.white,
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
          items: const ['lbs', 'kg'],
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
      height: 400,
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
            itemExtent: 92,
            diameterRatio: 3,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (i) {
              HapticFeedback.selectionClick();
              onChanged(i + 10);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: 91,
              builder: (context, i) {
                final distance = (i + 10 - age).abs();
                return Center(
                  child: Text(
                    '${i + 10}',
                    style: AppText.headingSm.copyWith(
                      fontSize: switch (distance) { 0 => 72, 1 => 52, _ => 36 },
                      height: 1,
                      color: switch (distance) {
                        0 => Colors.white,
                        1 => AppPalette.gray60,
                        _ => AppPalette.gray30,
                      },
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

/// Sleep level on a diagonal slider with the level shown large.
class _SleepSlider extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _SleepSlider({required this.value, required this.onChanged});

  static const _labels = [
    ('Insomniac', '<3hr daily'),
    ('Poor', '~3-4hr daily'),
    ('Moderate', '~5-6hr daily'),
    ('Good', '~7-8hr daily'),
    ('Excellent', '8hr+ daily'),
  ];

  @override
  Widget build(BuildContext context) {
    final (name, hours) = _labels[value - 1];
    return SizedBox(
      height: 340,
      child: LayoutBuilder(
        builder: (context, c) {
          final size = Size(c.maxWidth, 340);
          // Track runs from bottom-left to top-right.
          final start = Offset(24, size.height - 40);
          final end = Offset(size.width * 0.72, 40);

          void update(Offset p) {
            final d = end - start;
            final t = ((p - start).dx * d.dx + (p - start).dy * d.dy) /
                d.distanceSquared;
            final v = (t.clamp(0.0, 1.0) * 4).round() + 1;
            if (v != value) {
              HapticFeedback.selectionClick();
              onChanged(v);
            }
          }

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (d) => update(d.localPosition),
            onPanUpdate: (d) => update(d.localPosition),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _DiagonalSliderPainter(
                      start: start,
                      end: end,
                      value: (value - 1) / 4,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.bedtime_outlined,
                            size: 16,
                            color: AppPalette.gray80,
                          ),
                          const SizedBox(width: 4),
                          Text(name, style: AppText.textSmExtraBold),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(hours, style: AppText.paragraphSm),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: Text(
                      '$value',
                      key: ValueKey(value),
                      style: AppText.headingSm.copyWith(
                        fontSize: 140,
                        height: 1,
                      ),
                    ),
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

class _DiagonalSliderPainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final double value;

  _DiagonalSliderPainter({
    required this.start,
    required this.end,
    required this.value,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final thumb = Offset.lerp(start, end, value)!;
    final rest = Paint()
      ..color = AppPalette.gray20
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    final fill = Paint()
      ..color = AppPalette.blue60
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(thumb, end, rest);
    canvas.drawLine(start, thumb, fill);

    // Level markers: small rotated squares.
    for (var i = 0; i <= 4; i++) {
      final t = i / 4;
      if ((t - value).abs() < 0.01) continue;
      final p = Offset.lerp(start, end, t)!;
      canvas.save();
      canvas.translate(p.dx, p.dy);
      canvas.rotate(math.pi / 4);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: 14, height: 14),
          const Radius.circular(3),
        ),
        Paint()..color = t < value ? AppPalette.blue60 : AppPalette.gray20,
      );
      canvas.restore();
    }

    // Thumb.
    canvas.save();
    canvas.translate(thumb.dx, thumb.dy);
    canvas.rotate(math.pi / 4);
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: 52, height: 52),
      const Radius.circular(10),
    );
    canvas.drawRRect(
      rect.inflate(6),
      Paint()..color = AppPalette.blue60.withValues(alpha: 0.2),
    );
    canvas.drawRRect(rect, Paint()..color = AppPalette.blue60);
    canvas.restore();
    canvas.drawCircle(
      thumb,
      7,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  @override
  bool shouldRepaint(covariant _DiagonalSliderPainter old) =>
      old.value != value || old.start != start || old.end != end;
}

/// Mood carousel of square "robot" faces with pointers above and below.
class _MoodPicker extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _MoodPicker({required this.value, required this.onChanged});

  static const moods = ['Sad', 'Down', 'Neutral', 'Happy', 'Overjoyed'];

  @override
  State<_MoodPicker> createState() => _MoodPickerState();
}

class _MoodPickerState extends State<_MoodPicker> {
  late final PageController _pages = PageController(
    viewportFraction: 0.42,
    initialPage: _index,
  );

  int get _index => _MoodPicker.moods.indexOf(widget.value).clamp(0, 4).toInt();

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final index = _index;
    return Column(
      children: [
        const Icon(Icons.arrow_drop_down_rounded,
            size: 36, color: AppPalette.gray80),
        SizedBox(
          height: 170,
          child: OverflowBox(
            maxWidth: MediaQuery.sizeOf(context).width,
            child: PageView.builder(
              controller: _pages,
              itemCount: _MoodPicker.moods.length,
              onPageChanged: (i) {
                HapticFeedback.selectionClick();
                widget.onChanged(_MoodPicker.moods[i]);
              },
              itemBuilder: (context, i) {
                final selected = i == index;
                return GestureDetector(
                  onTap: () => _pages.animateToPage(
                    i,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                  ),
                  child: AnimatedScale(
                    scale: selected ? 1 : 0.72,
                    duration: const Duration(milliseconds: 200),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: selected ? AppPalette.blue60 : AppPalette.gray30,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: selected
                            ? [
                                ...AppPalette.focusRing(AppPalette.blue60),
                                BoxShadow(
                                  color:
                                      AppPalette.blue60.withValues(alpha: 0.4),
                                  blurRadius: 32,
                                ),
                              ]
                            : null,
                      ),
                      child: CustomPaint(painter: _RobotFacePainter(i)),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const Icon(Icons.arrow_drop_up_rounded,
            size: 36, color: AppPalette.gray80),
        const SizedBox(height: 24),
        Text(
          'I’m feeling ${widget.value.toLowerCase()}.',
          style: AppText.textXlExtraBold.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

/// Square eyes and a mouth that goes from frown (0) to big smile (4).
class _RobotFacePainter extends CustomPainter {
  final int mood;

  _RobotFacePainter(this.mood);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()..color = Colors.white;
    final eye = w * 0.14;
    for (final x in [0.3, 0.7]) {
      final eyeH = mood == 4 ? eye * 0.45 : eye;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(w * x, h * 0.38),
            width: eye,
            height: eyeH,
          ),
          Radius.circular(eye * 0.2),
        ),
        paint,
      );
    }
    final mouth = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.07
      ..strokeCap = StrokeCap.round;
    final y = h * 0.68;
    final left = Offset(w * 0.3, y);
    final right = Offset(w * 0.7, y);
    // Curve depth: negative frowns, positive smiles.
    final depth = (mood - 2) * h * 0.08;
    final path = Path()
      ..moveTo(left.dx, left.dy - depth / 2)
      ..quadraticBezierTo(w / 2, y + depth, right.dx, right.dy - depth / 2);
    canvas.drawPath(path, mouth);
  }

  @override
  bool shouldRepaint(covariant _RobotFacePainter old) => old.mood != mood;
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
