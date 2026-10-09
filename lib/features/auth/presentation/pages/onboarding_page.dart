import 'package:flutter/material.dart';

import '../../../../config/themes/app_theme.dart';
import '../../../../core/widgets/kit.dart';

class _Slide {
  final String title;
  final String body;
  final String image;
  final Color background;

  const _Slide(this.title, this.body, this.image, this.background);
}

const _slides = [
  _Slide(
    'Personalize Your Fitness with Smart AI.',
    'Achieve your wellness goals with insights tailored to your unique needs.',
    'assets/onboarding/welcome_2.png',
    Colors.white,
  ),
  _Slide(
    'Your Intelligent Fitness Companion.',
    'Track your runs, steps & calories and get special recommendations.',
    'assets/onboarding/welcome_3.png',
    Colors.white,
  ),
  _Slide(
    'Emphatic AI Wellness Coach For All.',
    'Experience compassionate and personalized guidance with our AI coach.',
    'assets/onboarding/welcome_4.png',
    Colors.white,
  ),
  _Slide(
    'Intuitive Nutrition & Med Tracker.',
    'Easily track your medication & nutrition alongside your training.',
    'assets/onboarding/welcome_5.png',
    Colors.white,
  ),
  _Slide(
    'Helpful Resources & Community.',
    'Join a community of athletes dedicated to a healthy, active life.',
    'assets/onboarding/welcome_6.png',
    Colors.white,
  ),
];

/// Onboarding carousel (Welcome Screens 2–6 from the kit).
class OnboardingPage extends StatefulWidget {
  final VoidCallback onDone;

  const OnboardingPage({super.key, required this.onDone});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page == _slides.length - 1) {
      widget.onDone();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _slides.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, i) => _SlideView(slide: _slides[i]),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  SizedBox(
                    width: 144,
                    child: KitProgressBar(value: (_page + 1) / _slides.length),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: widget.onDone,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        'Skip',
                        style: AppText.textMdSemiBold.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // The kit illustrations include the navigation button artwork at
          // right 24 / bottom 24 (375pt artboard), so the live button sits
          // exactly on top of it at the same scale.
          LayoutBuilder(
            builder: (context, constraints) {
              final k = constraints.maxWidth / 375;
              return Stack(
                children: [
                  Positioned(
                    right: 24 * k,
                    bottom: 24 * k,
                    child: Material(
                      color: AppPalette.gray80,
                      borderRadius: BorderRadius.circular(20 * k),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: _next,
                        child: SizedBox(
                          width: 80 * k,
                          height: 80 * k,
                          child: Center(
                            child: _page == _slides.length - 1
                                ? const Icon(Icons.arrow_forward_rounded,
                                    color: Colors.white, size: 28)
                                : const KitPlusIcon(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SlideView extends StatelessWidget {
  final _Slide slide;

  const _SlideView({required this.slide});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: slide.background,
      child: Stack(
        children: [
          // Illustration exported from the kit, anchored to the bottom.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              slide.image,
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 72, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(slide.title, style: AppText.headingSm),
                  const SizedBox(height: 16),
                  Text(slide.body, style: AppText.paragraphMd),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
