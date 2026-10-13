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
    on State<T>, TickerProviderStateMixin<T> {
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

/// One plus-glyph stroke placed by its (virtual, sharp) corner, in
/// 375×812 frame coordinates.
///
/// At [angle] 0 the arms point left and down ("┐", the logo's first
/// stroke); positive angles turn it clockwise.
class _Stroke {
  final Offset corner;
  final double angle;
  final double arm;
  final double width;

  const _Stroke(this.corner, this.angle,
      {required this.arm, required this.width});

  /// The four quarter-turn orientations used by the quote pattern.
  static const double down = 0; // ┐
  static const double up = math.pi; // └
  static const double upLeft = math.pi / 2; // ┘
  static const double downRight = -math.pi / 2; // ┌

  void paint(Canvas canvas, Paint paint, {double scale = 1, double turn = 0}) {
    canvas.save();
    canvas.translate(corner.dx * scale, corner.dy * scale);
    canvas.rotate(angle + turn);
    paint.strokeWidth = width * scale;
    final a = arm * scale;
    canvas.drawPath(kitPlusStrokePath(a).shift(Offset(-a, 0)), paint);
    canvas.restore();
  }
}

class _StrokesPainter extends CustomPainter {
  final List<_Stroke> strokes;
  final Color color;
  final double Function(int index) turn;

  _StrokesPainter(this.strokes, this.color, {double Function(int)? turn})
      : turn = turn ?? ((_) => 0);

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 375;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < strokes.length; i++) {
      strokes[i].paint(canvas, paint, scale: scale, turn: turn(i));
    }
  }

  @override
  bool shouldRepaint(covariant _StrokesPainter old) => true;
}

// ---------------------------------------------------------------------------
// Loading Interactive
// ---------------------------------------------------------------------------

/// "Loading Interactive": title, progress bar and four large glyph strokes
/// that wobble when the phone is shaken (or the screen tapped).
class LoadingInteractivePage extends StatefulWidget {
  const LoadingInteractivePage({super.key});

  @override
  State<LoadingInteractivePage> createState() => _LoadingInteractivePageState();
}

class _LoadingInteractivePageState extends State<LoadingInteractivePage>
    with TickerProviderStateMixin, _IndeterminateProgress {
  static const _shakeThreshold = 15.0; // m/s², gravity removed
  static const _shakeCooldown = Duration(milliseconds: 600);

  static double _deg(double d) => d * math.pi / 180;

  static final _strokes = [
    _Stroke(const Offset(81, 157), _deg(-135), arm: 205, width: 60),
    _Stroke(const Offset(272, 347), _deg(105), arm: 205, width: 60),
    _Stroke(const Offset(215, 450), _deg(-10), arm: 205, width: 60),
    _Stroke(const Offset(166, 622), _deg(-79), arm: 205, width: 60),
  ];

  late final AnimationController _wobble = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  StreamSubscription<UserAccelerometerEvent>? _accel;
  DateTime _lastShake = DateTime.fromMillisecondsSinceEpoch(0);

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
    _wobble.forward(from: 0);
  }

  /// Damped swing, alternating direction per stroke.
  double _turn(int i) {
    final t = _wobble.value;
    final swing = math.sin(t * math.pi * 4) * (1 - t) * 0.35;
    return i.isEven ? swing : -swing;
  }

  @override
  void dispose() {
    _accel?.cancel();
    _wobble.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.blue60,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _interact,
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _wobble,
                builder: (_, __) => CustomPaint(
                  painter: _StrokesPainter(
                    _strokes,
                    Colors.white.withValues(alpha: 0.12),
                    turn: _turn,
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Loading...',
                      style: AppText.headingXs.copyWith(
                        height: 30 / 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AnimatedBuilder(
                      animation: eased,
                      builder: (_, __) => _LoadingBar(value: eased.value),
                    ),
                    const SizedBox(height: 48),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.smartphone_outlined,
                          size: 24,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'SHAKE SCREEN TO INTERACT!',
                          style: AppText.labelXs.copyWith(
                            fontSize: 12,
                            height: 15 / 12,
                            letterSpacing: 1.2,
                            color: Colors.white,
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
      ),
    );
  }
}

/// "Progress Bar Atom" on blue: translucent track, white fill with a halo.
class _LoadingBar extends StatelessWidget {
  final double value;

  const _LoadingBar({required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          FractionallySizedBox(
            widthFactor: value.clamp(0, 1).toDouble(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.35),
                    spreadRadius: 3,
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

// ---------------------------------------------------------------------------
// Loading Quote
// ---------------------------------------------------------------------------

class _Quote {
  final String text;
  final String author;

  const _Quote(this.text, this.author);
}

/// "Loading Quote": a quote on light blue, framed by small glyph strokes
/// clustered in the top-right and bottom-left corners.
class LoadingQuotePage extends StatefulWidget {
  const LoadingQuotePage({super.key});

  @override
  State<LoadingQuotePage> createState() => _LoadingQuotePageState();
}

class _LoadingQuotePageState extends State<LoadingQuotePage> {
  static const _quotes = [
    _Quote('Health is the complete harmony of the body and soul.', 'Aristotle'),
    _Quote('Run when you can, walk if you have to, crawl if you must.',
        'Dean Karnazes'),
    _Quote('Take care of your body. It’s the only place you have to live.',
        'Jim Rohn'),
  ];

  static _Stroke _s(double x, double y, double angle) =>
      _Stroke(Offset(x, y), angle, arm: 56, width: 12);

  static Path _line(double x1, double y1, double x2, double y2) => Path()
    ..moveTo(x1, y1)
    ..lineTo(x2, y2);

  // Pieces of the kit's plus pattern, in 375×812 frame coordinates.
  static final _strokes = [
    // Top-right cluster.
    _s(168, 79, _Stroke.upLeft),
    _s(281, 80, _Stroke.upLeft),
    _s(279, 76, _Stroke.downRight),
    _s(338, 190, _Stroke.down),
    _s(338, 195, _Stroke.up),
    // Bottom-left cluster.
    _s(36, 617, _Stroke.down),
    _s(36, 622, _Stroke.up),
    _s(93, 734, _Stroke.upLeft),
    _s(93, 730, _Stroke.downRight),
    _s(205, 730, _Stroke.downRight),
  ];

  // Arms of glyphs that sit mostly off-screen.
  static final _edges = [
    _line(107, 0, 107, 13),
    _line(217, 0, 217, 13),
    _line(338, 76, 375, 76),
    _line(338, 313, 375, 313),
    _line(0, 499, 36, 499),
    _line(36, 800, 36, 812),
    _line(150, 800, 150, 812),
    _line(264, 800, 264, 812),
  ];

  late final _Quote _quote = _quotes[math.Random().nextInt(_quotes.length)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.blue20,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _QuotePatternPainter(
                _strokes,
                _edges,
                AppPalette.blue60.withValues(alpha: 0.2),
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
                    color: AppPalette.blue60,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    '"${_quote.text}"',
                    textAlign: TextAlign.center,
                    style: AppText.headingSm,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    '— ${_quote.author.toUpperCase()}',
                    textAlign: TextAlign.center,
                    style: AppText.labelXs.copyWith(
                      fontSize: 14,
                      height: 18 / 14,
                      letterSpacing: 1.4,
                      color: AppPalette.blue60,
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

class _QuotePatternPainter extends CustomPainter {
  final List<_Stroke> strokes;
  final List<Path> edges;
  final Color color;

  _QuotePatternPainter(this.strokes, this.edges, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    _StrokesPainter(strokes, color).paint(canvas, size);
    final scale = size.width / 375;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12 * scale;
    for (final e in edges) {
      canvas.drawPath(
        e.transform(Matrix4.diagonal3Values(scale, scale, 1).storage),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _QuotePatternPainter old) => old.color != color;
}

// ---------------------------------------------------------------------------
// Loading Number
// ---------------------------------------------------------------------------

/// "Loading Number": the plus glyph blown up to fill a dark screen with the
/// percentage counting up where its strokes cross.
class LoadingNumberPage extends StatefulWidget {
  const LoadingNumberPage({super.key});

  @override
  State<LoadingNumberPage> createState() => _LoadingNumberPageState();
}

class _LoadingNumberPageState extends State<LoadingNumberPage>
    with TickerProviderStateMixin, _IndeterminateProgress {
  @override
  Widget build(BuildContext context) {
    final style = AppText.headingSm.copyWith(
      fontSize: 36,
      height: 44 / 36,
      color: Colors.white,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    return Scaffold(
      backgroundColor: AppPalette.gray80,
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _BigGlyphPainter(Colors.white.withValues(alpha: 0.08)),
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: eased,
              builder: (_, __) => Text.rich(
                TextSpan(
                  text: (eased.value * 100).toStringAsFixed(1),
                  children: const [
                    TextSpan(
                      text: '%',
                      style: TextStyle(color: AppPalette.blue60),
                    ),
                  ],
                ),
                style: style,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The plus glyph centred on screen, 810px wide on the 375px frame so its
/// arms run the full height.
class _BigGlyphPainter extends CustomPainter {
  final Color color;

  _BigGlyphPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final glyph = 810 * size.width / 375;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = glyph / 8;
    canvas.drawPath(
      kitPlusPath(glyph).shift(
        Offset((size.width - glyph) / 2, (size.height - glyph) / 2),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _BigGlyphPainter old) => old.color != color;
}
