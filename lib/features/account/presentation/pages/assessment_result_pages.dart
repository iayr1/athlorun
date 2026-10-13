import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../config/themes/app_theme.dart';
import '../../../../core/services/biometric_service.dart';
import '../../../../core/services/health_score.dart';
import '../../../../core/widgets/kit.dart';

/// Dark "Compiling Assessment data… Please wait!" screen.
class CompilingAssessmentView extends StatelessWidget {
  const CompilingAssessmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.gray80,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const KitStrokeScatter(
            color: Color(0x14FFFFFF),
            strokes: [
              KitStroke(Offset(255, 215), 180, 220),
              KitStroke(Offset(105, 610), 0, 220),
            ],
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _PulsingPlus(),
                const SizedBox(height: 40),
                Text(
                  'Compiling Assessment data...\nPlease wait!',
                  textAlign: TextAlign.center,
                  style: AppText.paragraphSm.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PulsingPlus extends StatefulWidget {
  const _PulsingPlus();

  @override
  State<_PulsingPlus> createState() => _PulsingPlusState();
}

class _PulsingPlusState extends State<_PulsingPlus>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 0.9, end: 1.05)
          .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut)),
      child: const KitPlusIcon(size: 96),
    );
  }
}

/// "You're All Set Up. Your health score is N." on blue (good) or red.
class HealthScorePage extends StatefulWidget {
  final HealthScore score;
  final VoidCallback onContinue;

  const HealthScorePage({
    super.key,
    required this.score,
    required this.onContinue,
  });

  @override
  State<HealthScorePage> createState() => _HealthScorePageState();
}

class _HealthScorePageState extends State<HealthScorePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _count = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..forward().whenComplete(HapticFeedback.mediumImpact);

  @override
  void dispose() {
    _count.dispose();
    super.dispose();
  }

  void _showDetails() {
    final s = widget.score;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.75,
        ),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          children: [
            if (s.anomalies.isNotEmpty) ...[
              Text('Anomalies', style: AppText.textXlExtraBold),
              const SizedBox(height: 8),
              for (final a in s.anomalies)
                _DetailRow(
                  icon: Icons.warning_amber_rounded,
                  color: AppPalette.red50,
                  text: a,
                ),
              const SizedBox(height: 16),
            ],
            Text('Suggestions', style: AppText.textXlExtraBold),
            const SizedBox(height: 8),
            for (final t in s.suggestions)
              _DetailRow(
                icon: Icons.lightbulb_outline_rounded,
                color: AppPalette.blue60,
                text: t,
              ),
            const SizedBox(height: 16),
            const Text(
              'Your score is based on the answers in your health assessment. '
              'It isn’t a medical diagnosis.',
              style: AppText.paragraphSm,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.score;
    final color = s.isGood ? AppPalette.blue60 : AppPalette.red50;
    final white70 = Colors.white.withValues(alpha: 0.8);
    return Scaffold(
      backgroundColor: color,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const KitStrokeScatter(
            color: Color(0x1FFFFFFF),
            strokes: [
              KitStroke(Offset(60, 30), -60, 70),
              KitStroke(Offset(330, 10), 30, 80),
              KitStroke(Offset(-10, 470), 100, 80),
              KitStroke(Offset(370, 560), -150, 90),
              KitStroke(Offset(90, 780), 20, 90),
              KitStroke(Offset(300, 760), -20, 70),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Column(
                children: [
                  const Spacer(),
                  _ScoreCard(
                    color: color,
                    child: AnimatedBuilder(
                      animation: _count,
                      builder: (_, __) => Text(
                        '${(s.score * Curves.easeOutCubic.transform(_count.value)).round()}',
                        style: AppText.headingSm.copyWith(
                          fontSize: 136,
                          height: 1,
                          letterSpacing: -4,
                          color: color,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'You’re All Set Up.\nYour health score is ${s.score}'
                    '${s.isGood ? '.' : '!'}',
                    textAlign: TextAlign.center,
                    style: AppText.headingXs.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _showDetails,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.lightbulb_outline_rounded,
                              size: 14, color: white70),
                          const SizedBox(width: 4),
                          Text(
                            '${s.suggestions.length} Suggestions',
                            style: AppText.labelXs.copyWith(
                              color: white70,
                              letterSpacing: 0,
                              fontSize: 12,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text('·',
                                style:
                                    AppText.labelXs.copyWith(color: white70)),
                          ),
                          Icon(Icons.warning_amber_rounded,
                              size: 14, color: white70),
                          const SizedBox(width: 4),
                          Text(
                            '${s.anomalies.length} Anomalies',
                            style: AppText.labelXs.copyWith(
                              color: white70,
                              letterSpacing: 0,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.chevron_right_rounded,
                              size: 16, color: white70),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: widget.onContinue,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 1.5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Let’s Get Healthy',
                          style:
                              AppText.textMdBold.copyWith(color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// White card with a "+" tab on top and two translucent layers beneath.
class _ScoreCard extends StatelessWidget {
  final Color color;
  final Widget child;

  const _ScoreCard({required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 36,
            left: 28,
            right: 28,
            bottom: -20,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),
          Positioned(
            top: 36,
            left: 14,
            right: 14,
            bottom: -10,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),
          Positioned(
            top: 36,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
              ),
              child: child,
            ),
          ),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.all(6),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: KitPlusIcon(size: 32, color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _DetailRow({
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: AppText.textSmSemiBold)),
        ],
      ),
    );
  }
}

/// Asks for the fingerprint before showing the app.
class BiometricLockPage extends StatefulWidget {
  final VoidCallback onUnlocked;
  final VoidCallback onSignOut;

  const BiometricLockPage({
    super.key,
    required this.onUnlocked,
    required this.onSignOut,
  });

  @override
  State<BiometricLockPage> createState() => _BiometricLockPageState();
}

class _BiometricLockPageState extends State<BiometricLockPage> {
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _unlock());
  }

  Future<void> _unlock() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final ok =
          await BiometricService.instance.authenticate('Unlock athlorun');
      if (ok) {
        widget.onUnlocked();
        return;
      }
    } on PlatformException catch (e) {
      _error = e.message ?? 'Fingerprint unlock failed.';
    }
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.gray10,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const KitLogoMark(size: 64),
              const SizedBox(height: 24),
              Text('athlorun is locked', style: AppText.headingXs),
              const SizedBox(height: 8),
              const Text(
                'Use your fingerprint to continue.',
                style: AppText.paragraphMd,
              ),
              const SizedBox(height: 40),
              IconButton(
                iconSize: 96,
                tooltip: 'Unlock',
                onPressed: _busy ? null : _unlock,
                icon: const Icon(
                  Icons.fingerprint_rounded,
                  color: AppPalette.blue60,
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                KitAlert(message: _error!),
              ],
              const Spacer(),
              KitButton(
                label: 'Unlock',
                loading: _busy,
                onPressed: _unlock,
                trailing: const Icon(Icons.lock_open_rounded),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: widget.onSignOut,
                child: Text(
                  'Sign out',
                  style:
                      AppText.textSmSemiBold.copyWith(color: AppPalette.gray60),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
