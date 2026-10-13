import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/themes/app_theme.dart';
import '../../../../core/widgets/kit.dart';

// ---------------------------------------------------------------------------
// AI Body Analysis
// ---------------------------------------------------------------------------

/// "AI Body Analysis" intro: illustration and the scan checklist.
class BodyAnalysisIntro extends StatelessWidget {
  const BodyAnalysisIntro({super.key});

  static const _checks = ['720p Camera', 'Stay Still', 'Good Lighting'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _Illustration(
          background: AppPalette.gray20,
          children: [
            _Floating(Alignment(-0.45, 0.1), Icons.person_rounded, 120,
                AppPalette.red50),
            _Floating(Alignment(0.4, -0.1), Icons.document_scanner_rounded, 96,
                AppPalette.gray80),
            _Floating(Alignment(0.8, -0.7), Icons.auto_awesome_rounded, 28,
                AppPalette.amber),
            _Floating(Alignment(-0.8, -0.6), Icons.auto_awesome_rounded, 20,
                AppPalette.amber),
          ],
        ),
        const SizedBox(height: 32),
        for (final c in _checks)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(child: Text(c, style: AppText.textMdBold)),
                const Icon(Icons.check_box_rounded, color: AppPalette.red50),
              ],
            ),
          ),
      ],
    );
  }
}

/// Full-screen body scan: take a photo, then a scanning animation runs over
/// it. The photo stays on the device; only completion is recorded.
class BodyScanStep extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSkip;
  final VoidCallback onComplete;

  const BodyScanStep({
    super.key,
    required this.onBack,
    required this.onSkip,
    required this.onComplete,
  });

  @override
  State<BodyScanStep> createState() => _BodyScanStepState();
}

enum _ScanState { idle, scanning, done }

class _BodyScanStepState extends State<BodyScanStep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _line = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  XFile? _photo;
  _ScanState _state = _ScanState.idle;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _line.dispose();
    super.dispose();
  }

  Future<void> _capture(ImageSource source) async {
    try {
      final photo = await ImagePicker().pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.front,
        maxWidth: 1080,
      );
      if (photo == null || !mounted) return;
      setState(() {
        _photo = photo;
        _state = _ScanState.scanning;
      });
      _timer?.cancel();
      _timer = Timer(const Duration(seconds: 3), () {
        if (!mounted) return;
        HapticFeedback.mediumImpact();
        setState(() => _state = _ScanState.done);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Couldn’t open the camera: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final photo = _photo;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (photo != null && !kIsWeb)
          Image.file(File(photo.path), fit: BoxFit.cover)
        else if (photo != null)
          Image.network(photo.path, fit: BoxFit.cover)
        else
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, AppPalette.gray20],
              ),
            ),
            child: Center(
              child: Icon(
                Icons.accessibility_new_rounded,
                size: 280,
                color: AppPalette.gray30,
              ),
            ),
          ),
        // Scan frame with a sweeping line.
        Center(
          child: FractionallySizedBox(
            widthFactor: 0.65,
            heightFactor: 0.42,
            child: LayoutBuilder(
              builder: (context, c) => Stack(
                children: [
                  const Positioned.fill(
                    child: CustomPaint(painter: _FrameCornersPainter()),
                  ),
                  if (_state != _ScanState.done)
                    AnimatedBuilder(
                      animation: _line,
                      builder: (_, __) => Positioned(
                        left: -12,
                        right: -12,
                        top: _line.value * (c.maxHeight - 3),
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: [
                              BoxShadow(
                                color: AppPalette.blue60.withValues(alpha: 0.4),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              children: [
                Row(
                  children: [
                    KitIconButton(
                      icon: Icons.chevron_left_rounded,
                      onPressed: widget.onBack,
                      tooltip: 'Back',
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: widget.onSkip,
                      behavior: HitTestBehavior.opaque,
                      child: Text('Skip', style: AppText.textMdSemiBold),
                    ),
                  ],
                ),
                const Spacer(),
                _StatusChip(state: _state, hasPhoto: photo != null),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _ScanButton(
                      icon: Icons.photo_library_outlined,
                      tooltip: 'Choose from gallery',
                      onTap: () => _capture(ImageSource.gallery),
                    ),
                    const SizedBox(width: 24),
                    _ScanButton(
                      icon: _state == _ScanState.done
                          ? Icons.arrow_forward_rounded
                          : Icons.add_rounded,
                      tooltip: _state == _ScanState.done
                          ? 'Continue'
                          : 'Scan with camera',
                      primary: true,
                      onTap: _state == _ScanState.done
                          ? widget.onComplete
                          : () => _capture(ImageSource.camera),
                    ),
                    const SizedBox(width: 24),
                    _ScanButton(
                      icon: Icons.refresh_rounded,
                      tooltip: 'Retake',
                      onTap: photo == null
                          ? null
                          : () => _capture(ImageSource.camera),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final _ScanState state;
  final bool hasPhoto;

  const _StatusChip({required this.state, required this.hasPhoto});

  @override
  Widget build(BuildContext context) {
    final (icon, label) = switch (state) {
      _ScanState.idle => (Icons.center_focus_weak_rounded, 'TAP + TO SCAN'),
      _ScanState.scanning => (Icons.document_scanner_outlined, 'SCANNING...'),
      _ScanState.done => (Icons.check_circle_rounded, 'SCAN COMPLETE'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: AppPalette.softShadow(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color:
                state == _ScanState.done ? AppPalette.green : AppPalette.gray60,
          ),
          const SizedBox(width: 6),
          Text(label, style: AppText.labelXs),
        ],
      ),
    );
  }
}

class _ScanButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final bool primary;

  const _ScanButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = primary ? 72.0 : 48.0;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: primary ? AppPalette.blue60 : Colors.white,
        borderRadius: BorderRadius.circular(primary ? 20 : 14),
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(
              icon,
              size: primary ? 32 : 22,
              color: primary
                  ? Colors.white
                  : (onTap == null ? AppPalette.gray30 : AppPalette.gray80),
            ),
          ),
        ),
      ),
    );
  }
}

class _FrameCornersPainter extends CustomPainter {
  const _FrameCornersPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const len = 36.0;
    const r = 16.0;
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final w = size.width;
    final h = size.height;
    final corners = [
      Path()
        ..moveTo(0, len)
        ..lineTo(0, r)
        ..arcToPoint(const Offset(r, 0), radius: const Radius.circular(r))
        ..lineTo(len, 0),
      Path()
        ..moveTo(w - len, 0)
        ..lineTo(w - r, 0)
        ..arcToPoint(Offset(w, r), radius: const Radius.circular(r))
        ..lineTo(w, len),
      Path()
        ..moveTo(w, h - len)
        ..lineTo(w, h - r)
        ..arcToPoint(Offset(w - r, h), radius: const Radius.circular(r))
        ..lineTo(w - len, h),
      Path()
        ..moveTo(len, h)
        ..lineTo(r, h)
        ..arcToPoint(Offset(0, h - r), radius: const Radius.circular(r))
        ..lineTo(0, h - len),
    ];
    for (final c in corners) {
      canvas.drawPath(c, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// Symptoms / allergy
// ---------------------------------------------------------------------------

/// "Do you have any symptoms/allergy?": germ illustration and a tag field.
class SymptomInput extends StatefulWidget {
  final List<String> tags;
  final ValueChanged<List<String>> onChanged;
  final int max;

  const SymptomInput({
    super.key,
    required this.tags,
    required this.onChanged,
    this.max = 10,
  });

  @override
  State<SymptomInput> createState() => _SymptomInputState();
}

class _SymptomInputState extends State<SymptomInput> {
  final _text = TextEditingController();
  final _focus = FocusNode();

  static const _suggestions = [
    'Headache',
    'Muscle Fatigue',
    'Asthma',
    'Pollen',
    'Peanuts',
    'Lactose',
    'Back Pain',
    'Joint Pain',
  ];

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _text.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _add(String raw) {
    final tag = raw.trim().replaceAll(',', '');
    if (tag.isEmpty || widget.tags.length >= widget.max) return;
    final exists = widget.tags.any((t) => t.toLowerCase() == tag.toLowerCase());
    if (!exists) widget.onChanged([...widget.tags, tag]);
    _text.clear();
  }

  void _remove(String tag) =>
      widget.onChanged(widget.tags.where((t) => t != tag).toList());

  @override
  Widget build(BuildContext context) {
    final full = widget.tags.length >= widget.max;
    final unused = _suggestions
        .where(
            (s) => !widget.tags.any((t) => t.toLowerCase() == s.toLowerCase()))
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Illustration(
          height: 180,
          background: AppPalette.gray20,
          children: [
            _Floating(Alignment(-0.75, 0.1), Icons.water_drop_rounded, 56,
                AppPalette.cyan),
            _Floating(Alignment(-0.15, -0.45), Icons.coronavirus_rounded, 56,
                AppPalette.blue60),
            _Floating(Alignment(0.6, -0.4), Icons.bug_report_rounded, 52,
                AppPalette.gray60),
            _Floating(Alignment(-0.35, 0.65), Icons.coronavirus_outlined, 44,
                AppPalette.gray80),
            _Floating(Alignment(0.3, 0.55), Icons.coronavirus_rounded, 36,
                AppPalette.gray60),
            _Floating(Alignment(0.85, 0.35), Icons.pest_control_rounded, 32,
                AppPalette.blue60),
          ],
        ),
        const SizedBox(height: 32),
        GestureDetector(
          onTap: _focus.requestFocus,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            constraints: const BoxConstraints(minHeight: 112),
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _focus.hasFocus ? AppPalette.blue60 : AppPalette.blue20,
                width: 2,
              ),
              boxShadow: _focus.hasFocus
                  ? AppPalette.focusRing(AppPalette.blue60)
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    for (final t in widget.tags)
                      _Tag(label: t, onRemove: () => _remove(t)),
                    if (!full)
                      IntrinsicWidth(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 120),
                          child: TextField(
                            controller: _text,
                            focusNode: _focus,
                            style: AppText.textSmSemiBold,
                            textInputAction: TextInputAction.done,
                            onChanged: (v) {
                              if (v.endsWith(',')) _add(v);
                            },
                            onSubmitted: (v) {
                              _add(v);
                              _focus.requestFocus();
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: widget.tags.isEmpty
                                  ? 'Type a symptom or allergy'
                                  : 'Add more',
                              hintStyle: AppText.paragraphSm
                                  .copyWith(color: AppPalette.gray40),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.sell_outlined,
                      size: 14,
                      color: AppPalette.gray40,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.tags.length}/${widget.max}',
                      style: AppText.labelXs.copyWith(letterSpacing: 0),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (unused.isNotEmpty && !full) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in unused)
                ActionChip(
                  label: Text(s),
                  avatar: const Icon(Icons.add_rounded, size: 16),
                  labelStyle: AppText.textSmSemiBold,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: AppPalette.gray20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onPressed: () => _add(s),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _Tag({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
      decoration: BoxDecoration(
        color: AppPalette.blue10,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppText.textSmSemiBold.copyWith(
              fontSize: 12,
              color: AppPalette.blue60,
            ),
          ),
          const SizedBox(width: 2),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              size: 14,
              color: AppPalette.blue60,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Textual AI Health Analysis
// ---------------------------------------------------------------------------

/// Highlights phrases that describe symptoms, like the kit's red marks.
class _SymptomHighlightController extends TextEditingController {
  _SymptomHighlightController({super.text});

  static final _pattern = RegExp(
    r"\b(i\s+don'?t\s+know\s+why|[\w\s]{0,12}\b(hurts?|hurting|pain(ful)?|"
    r"aches?|aching|sore|dizz(y|iness)|nause(a|ous)|fever|cough(ing)?|"
    r"tired|fatigue|swollen|swelling|bleeding|itch(y|ing)?|rash|"
    r"can'?t\s+sleep|insomnia|anxious|anxiety|short\s+of\s+breath))\b",
    caseSensitive: false,
  );

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final spans = <TextSpan>[];
    var last = 0;
    for (final m in _pattern.allMatches(text)) {
      if (m.start > last) {
        spans.add(TextSpan(text: text.substring(last, m.start)));
      }
      spans.add(TextSpan(
        text: m.group(0),
        style: const TextStyle(
          color: AppPalette.red50,
          backgroundColor: AppPalette.red10,
        ),
      ));
      last = m.end;
    }
    if (last < text.length) spans.add(TextSpan(text: text.substring(last)));
    return TextSpan(style: style, children: spans);
  }
}

/// "Textual AI Health Analysis": free text with undo/redo and a counter.
class HealthNotesInput extends StatefulWidget {
  final String? initial;
  final ValueChanged<String> onChanged;
  final VoidCallback onUseVoice;
  final int maxLength;

  const HealthNotesInput({
    super.key,
    required this.initial,
    required this.onChanged,
    required this.onUseVoice,
    this.maxLength = 250,
  });

  @override
  State<HealthNotesInput> createState() => _HealthNotesInputState();
}

class _HealthNotesInputState extends State<HealthNotesInput> {
  late final _controller = _SymptomHighlightController(text: widget.initial);
  final _history = UndoHistoryController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
    _controller.addListener(() => widget.onChanged(_controller.text));
  }

  @override
  void dispose() {
    _controller.dispose();
    _history.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _focus.hasFocus ? AppPalette.blue60 : AppPalette.blue20,
              width: 2,
            ),
            boxShadow: _focus.hasFocus
                ? AppPalette.focusRing(AppPalette.blue60)
                : null,
          ),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                focusNode: _focus,
                undoController: _history,
                minLines: 5,
                maxLines: 8,
                maxLength: widget.maxLength,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                style: AppText.paragraphMd.copyWith(color: AppPalette.gray80),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                  hintText: 'e.g. I haven’t been sleeping well lately and my '
                      'right knee hurts after runs.',
                  hintStyle:
                      AppText.paragraphMd.copyWith(color: AppPalette.gray40),
                ),
              ),
              ValueListenableBuilder<UndoHistoryValue>(
                valueListenable: _history,
                builder: (context, value, _) => Row(
                  children: [
                    _SquareIconButton(
                      icon: Icons.undo_rounded,
                      tooltip: 'Undo',
                      onTap: value.canUndo ? _history.undo : null,
                    ),
                    const SizedBox(width: 8),
                    _SquareIconButton(
                      icon: Icons.redo_rounded,
                      tooltip: 'Redo',
                      onTap: value.canRedo ? _history.redo : null,
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.notes_rounded,
                      size: 16,
                      color: AppPalette.gray40,
                    ),
                    const SizedBox(width: 4),
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _controller,
                      builder: (_, v, __) => Text(
                        '${v.text.length}/${widget.maxLength}',
                        style: AppText.labelXs.copyWith(letterSpacing: 0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Material(
          color: AppPalette.gray80,
          borderRadius: BorderRadius.circular(10),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onUseVoice,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Use Voice Instead',
                    style: AppText.textSmSemiBold.copyWith(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.mic_rounded, size: 16, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  const _SquareIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppPalette.gray10,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 36,
            height: 36,
            child: Icon(
              icon,
              size: 18,
              color: onTap == null ? AppPalette.gray30 : AppPalette.gray60,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Voice AI Analysis
// ---------------------------------------------------------------------------

/// "Voice AI Analysis": nested squares that pulse while the user reads the
/// sentence aloud, with the words highlighted at a natural reading pace.
///
/// Guides the reading only; no audio is recorded.
class VoiceAnalysis extends StatefulWidget {
  final bool completed;
  final VoidCallback onCompleted;

  const VoiceAnalysis({
    super.key,
    required this.completed,
    required this.onCompleted,
  });

  @override
  State<VoiceAnalysis> createState() => _VoiceAnalysisState();
}

class _VoiceAnalysisState extends State<VoiceAnalysis>
    with SingleTickerProviderStateMixin {
  static const _words = [
    'The',
    'lazy',
    'fox',
    'jumps',
    'over',
    'the',
    'wild',
    'dog.'
  ];

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  Timer? _timer;
  late int _read = widget.completed ? _words.length : 0;
  bool get _listening => _timer?.isActive ?? false;

  @override
  void dispose() {
    _timer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  void _toggle() {
    HapticFeedback.mediumImpact();
    if (_listening) {
      _stop();
      return;
    }
    setState(() => _read = 0);
    _pulse.repeat(reverse: true);
    _timer = Timer.periodic(const Duration(milliseconds: 450), (t) {
      if (!mounted) return;
      setState(() => _read++);
      if (_read >= _words.length) {
        _stop();
        widget.onCompleted();
      }
    });
    setState(() {});
  }

  void _stop() {
    _timer?.cancel();
    _pulse.animateTo(0, duration: const Duration(milliseconds: 300));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final done = _read >= _words.length;
    return Column(
      children: [
        Semantics(
          button: true,
          label: _listening ? 'Stop' : 'Start reading',
          child: GestureDetector(
            onTap: _toggle,
            child: AnimatedBuilder(
              animation: _pulse,
              builder: (_, __) => _VoiceSquares(level: _pulse.value),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          done
              ? 'Thanks! Tap the square to read it again.'
              : _listening
                  ? 'Listening… tap to stop'
                  : 'Tap the square, then read aloud',
          style: AppText.paragraphSm,
        ),
        const SizedBox(height: 28),
        Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 6,
          children: [
            for (var i = 0; i < _words.length; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 1),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: i < _read ? AppPalette.gray80 : Colors.transparent,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(i == 0 || i >= _read ? 6 : 0),
                    right: Radius.circular(i == _read - 1 ? 6 : 0),
                  ),
                ),
                child: Text(
                  _words[i],
                  style: AppText.headingXs.copyWith(
                    color: i < _read ? Colors.white : AppPalette.gray30,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _VoiceSquares extends StatelessWidget {
  final double level;

  const _VoiceSquares({required this.level});

  @override
  Widget build(BuildContext context) {
    const colors = [
      AppPalette.blue20,
      Color(0xFFA6C8FF),
      Color(0xFF78A9FF),
      Color(0xFF4589FF),
      AppPalette.blue60,
    ];
    const sizes = [220.0, 172.0, 128.0, 88.0, 48.0];
    return SizedBox(
      width: 240,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (var i = 0; i < sizes.length; i++)
            Container(
              // Outer rings breathe more than inner ones.
              width: sizes[i] + level * (sizes.length - i) * 4,
              height: sizes[i] + level * (sizes.length - i) * 4,
              decoration: BoxDecoration(
                color: colors[i],
                borderRadius: BorderRadius.circular(sizes[i] * 0.22),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared illustration
// ---------------------------------------------------------------------------

/// Soft blob with icons scattered on it, standing in for kit illustrations.
class _Illustration extends StatelessWidget {
  final double height;
  final Color background;
  final List<_Floating> children;

  const _Illustration({
    required this.background,
    required this.children,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          ),
          for (final f in children)
            Align(
              alignment: f.alignment,
              child: Icon(f.icon, size: f.size, color: f.color),
            ),
        ],
      ),
    );
  }
}

class _Floating {
  final Alignment alignment;
  final IconData icon;
  final double size;
  final Color color;

  const _Floating(this.alignment, this.icon, this.size, this.color);
}
