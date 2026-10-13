import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../../../config/themes/app_theme.dart';
import '../../../../core/widgets/kit.dart';

/// The kit's three loading screens ("Splash & Loading" page). They are laid
/// out on a 375×812 frame; positions here are scaled from that frame.
enum LoadingVariant { interactive, quote, number }

/// Shows one of the kit's loading screens.
class LoadingPage extends StatelessWidget {
  final LoadingVariant variant;

  const LoadingPage({super.key, required this.variant});

  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      LoadingVariant.interactive => const LoadingInteractivePage(),
      LoadingVariant.quote => const LoadingQuotePage(),
      LoadingVariant.number => const LoadingNumberPage(),
    };
  }
}

/// Progress for a load of unknown length: eases towards 99.9% and holds
/// there until the caller replaces the screen.
mixin _IndeterminateProgress<T extends StatefulWidget>
    on State<T>, SingleTickerProviderStateMixin<T> {
  late final AnimationController progress = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  )..forward();

  late final Animation<double> eased = CurvedAnimation(
    parent: progress,
    curve: Curves.easeOutCubic,
  ).drive(Tween(begin: 0, end: 0.999));

  @override
  void dispose() {
    progress.dispose();
    super.dispose();
  }
}

// ---------------------------------------------------------------------------
// Loading Interactive
// ---------------------------------------------------------------------------

/// "Loading Interactive": title, progress bar and four large plus-glyph
/// strokes that spin a quarter turn when the phone is shaken (or tapped).
class LoadingInteractivePage extends StatefulWidget {
  const LoadingInteractivePage({super.key});

  @override
  State<LoadingInteractivePage> createState() => _LoadingInteractivePageState();
}

class _LoadingInteractivePageState extends State<LoadingInteractivePage>
    with SingleTickerProviderStateMixin, _IndeterminateProgress {
  static const _shakeThreshold = 15.0; // m/s², gravity removed
  static const _shakeCooldown = Duration(milliseconds: 600);

  StreamSubscription<UserAccelerometerEvent>? _accel;
  DateTime _lastShake = DateTime.fromMillisecondsSinceEpoch(0);
  int _turns = 0;

  @override
  void initState() {
    super.initState();
    try {
      _accel = userAccelerometerEventStream().listen(
        _onAccel,
        onError: (_) {}, // No sensor (web, desktop): tapping still works.
        cancelOnError: true,
      );
    } catch (_) {}
  }

  void _onAccel(UserAccelerometerEvent e) {
    final g = math.sqrt(e.x * e.x + e.y * e.y + e.z * e.z);
    if (g < _shakeThreshold) return;
    final now = DateTime.now();
    if (now.difference(_lastShake) < _shakeCooldown) return;
    _lastShake = now;
    _interact();
  }

  void _interact() {
    HapticFeedback.lightImpact();
    setState(() => _turns++);
  }

  @override
  void dispose() {
    _accel?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _interact,
        child: LayoutBuilder(
          builder: (context, c) {
            final sx = c.maxWidth / 375;
            final sy = c.maxHeight / 812;
            // Frame positions from the kit; each stroke bleeds off an edge.
            Widget stroke(double x, double y, double size, int quarter,
                {bool clockwise = true}) {
              final s = size * sx;
              return Positioned(
                left: x * sx,
                top: y * sy,
                width: s,
                height: s,
                child: AnimatedRotation(
                  turns: (quarter + (clockwise ? _turns : -_turns)) / 4,
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.elasticOut,
                  child: const _GlyphStroke(color: AppPalette.blue10),
                ),
              );
            }

            return Stack(
              children: [
                stroke(-140, 0, 323, 1),
                stroke(75, -73, 300, 2, clockwise: false),
                stroke(0, 520, 290, 2, clockwise: false),
                stroke(94, 636, 281, 3),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Loading',
                          style: AppText.headingXs.copyWith(height: 30 / 24),
                        ),
                        const SizedBox(height: 24),
                        AnimatedBuilder(
                          animation: eased,
                          builder: (_, __) =>
                              _LoadingBar(value: eased.value),
                        ),
                        const SizedBox(height: 48),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.smartphone_rounded,
                              size: 24,
                              color: AppPalette.gray40,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Shake screen to interact',
                              style: AppText.textSmSemiBold.copyWith(
                                fontSize: 12,
                                height: 15 / 12,
                                color: AppPalette.gray40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// "Progress Bar Atom": 10px rounded track with a blue fill.
class _LoadingBar extends StatelessWidget {
  final double value;

  const _LoadingBar({required this.value});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: SizedBox(
        height: 10,
        child: Stack(
          children: [
            const Positioned.fill(
              child: ColoredBox(color: AppPalette.gray10),
            ),
            FractionallySizedBox(
              widthFactor: value.clamp(0, 1).toDouble(),
              child: Container(
                decoration: BoxDecoration(
                  color: AppPalette.blue60,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single plus-glyph stroke filling its box (the "Vector Stroke" layers).
class _GlyphStroke extends StatelessWidget {
  final Color color;

  const _GlyphStroke({required this.color});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _GlyphStrokePainter(color));
}

class _GlyphStrokePainter extends CustomPainter {
  final Color color;

  _GlyphStrokePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    // Arm is 18 units, stroke 4.5: the stroked shape spans 22.5 units.
    final arm = size.shortestSide * 18 / 22.5;
    final stroke = arm / 4;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    canvas.drawPath(
      kitPlusStrokePath(arm).shift(Offset(stroke / 2, stroke / 2)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _GlyphStrokePainter old) => old.color != color;
}

// ---------------------------------------------------------------------------
// Loading Quote
// ---------------------------------------------------------------------------

class _Quote {
  final String text;
  final String author;

  const _Quote(this.text, this.author);
}

/// "Loading Quote": a quote over a tilted pattern of plus glyphs.
class LoadingQuotePage extends StatefulWidget {
  const LoadingQuotePage({super.key});

  @override
  State<LoadingQuotePage> createState() => _LoadingQuotePageState();
}

class _LoadingQuotePageState extends State<LoadingQuotePage>
    with SingleTickerProviderStateMixin {
  static const _quotes = [
    _Quote(
      'Health is the complete harmony of the body and soul',
      'Naval Ravikant',
    ),
    _Quote('Run when you can, walk if you have to, crawl if you must',
        'Dean Karnazes'),
    _Quote('Take care of your body. It’s the only place you have to live',
        'Jim Rohn'),
  ];

  late final _Quote _quote = _quotes[math.Random().nextInt(_quotes.length)];

  // Slow drift of the background pattern.
  late final AnimationController _drift = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 20),
  )..repeat();

  @override
  void dispose() {
    _drift.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.blue60,
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _drift,
              builder: (_, __) => CustomPaint(
                painter: _PlusPatternPainter(
                  color: Colors.white.withValues(alpha: 0.08),
                  phase: _drift.value,
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.format_quote_rounded,
                    size: 48,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    _quote.text,
                    textAlign: TextAlign.center,
                    style: AppText.headingSm.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    _quote.author,
                    textAlign: TextAlign.center,
                    style: AppText.textSmSemiBold.copyWith(
                      height: 18 / 14,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
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

/// Grid of plus glyphs rotated across the screen, drifting by [phase].
class _PlusPatternPainter extends CustomPainter {
  static const _spacing = 96.0;
  static const _glyph = 32.0;
  static const _angle = -math.pi / 9;

  final Color color;
  final double phase;

  _PlusPatternPainter({required this.color, required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _glyph / 8;
    final glyph = kitPlusPath(_glyph);
    final reach = size.longestSide;
    final shift = phase * _spacing;

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(_angle);
    for (var y = -reach; y < reach; y += _spacing) {
      // Offset alternate rows by half a cell, like the kit's pattern.
      final row = ((y + reach) / _spacing).round();
      final dx = row.isEven ? 0.0 : _spacing / 2;
      for (var x = -reach; x < reach; x += _spacing) {
        canvas.drawPath(glyph.shift(Offset(x + dx + shift, y)), paint);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PlusPatternPainter old) =>
      old.phase != phase || old.color != color;
}

// ---------------------------------------------------------------------------
// Loading Number
// ---------------------------------------------------------------------------

/// "Loading Number": the logo mark blown up to fill the screen with the
/// percentage counting up in the middle of the glyph.
class LoadingNumberPage extends StatefulWidget {
  const LoadingNumberPage({super.key});

  @override
  State<LoadingNumberPage> createState() => _LoadingNumberPageState();
}

class _LoadingNumberPageState extends State<LoadingNumberPage>
    with SingleTickerProviderStateMixin, _IndeterminateProgress {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.blue60,
      body: LayoutBuilder(
        builder: (context, c) {
          // 1080px mark on the 375px frame, centred on the screen.
          final mark = 1080 * c.maxWidth / 375;
          return Stack(
            alignment: Alignment.center,
            children: [
              OverflowBox(
                maxWidth: mark,
                maxHeight: mark,
                child: KitLogoMark(size: mark),
              ),
              // Blue cut-out so the strokes crossing the centre don't
              // run through the number.
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppPalette.blue60,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: AnimatedBuilder(
                    animation: eased,
                    builder: (_, __) => Text(
                      '${(eased.value * 100).toStringAsFixed(1)}%',
                      style: AppText.headingSm.copyWith(
                        fontSize: 36,
                        height: 44 / 36,
                        color: Colors.white,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
