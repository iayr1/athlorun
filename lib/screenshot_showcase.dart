import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config/themes/app_theme.dart';
import 'core/services/metrics_store.dart';
import 'features/activity/presentation/pages/activity_history_page.dart';
import 'features/auth/presentation/pages/onboarding_page.dart';
import 'features/auth/presentation/pages/sign_in_page.dart';
import 'features/auth/presentation/pages/welcome_page.dart';
import 'features/challenges/presentation/pages/daily_challenges_screen.dart';
import 'features/home/presentation/pages/badge_screen.dart';
import 'features/home/presentation/pages/health_page.dart';
import 'features/home/presentation/pages/home_dashboard_page.dart';
import 'features/leaderboard/presentation/pages/leaderboard_page.dart';
import 'features/profile/presentation/pages/athlete_profile_page.dart';
import 'features/track/presentation/pages/track_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  final store = MetricsStore.instance;
  await store.load();
  await store.clearAll();

  // Populate realistic, high-quality showcase data for Play Store
  store.addSteps(8420);
  await store.updateProfile(
    name: 'Alex Morgan',
    weightKg: 74,
  );
  await store.updateGoals(
    const Goals(
      steps: 10000,
      runKm: 7.5,
      calories: 650,
      sleepHours: 8.0,
    ),
  );

  // Add sample workouts with route coordinates
  final now = DateTime.now();
  await store.addActivity(
    TrackedActivity(
      id: 'showcase-1',
      kind: ActivityKind.run,
      startedAt: now.subtract(const Duration(hours: 4)),
      duration: const Duration(minutes: 36, seconds: 15),
      distanceKm: 7.24,
      calories: 512,
      route: const [
        [28.6139, 77.2090],
        [28.6150, 77.2110],
        [28.6180, 77.2150],
        [28.6210, 77.2120],
        [28.6190, 77.2080],
      ],
    ),
  );

  await store.addActivity(
    TrackedActivity(
      id: 'showcase-2',
      kind: ActivityKind.run,
      startedAt: now.subtract(const Duration(days: 1, hours: 2)),
      duration: const Duration(minutes: 58, seconds: 40),
      distanceKm: 11.50,
      calories: 780,
      route: const [
        [28.6200, 77.2100],
        [28.6250, 77.2180],
        [28.6300, 77.2250],
      ],
    ),
  );

  await store.addActivity(
    TrackedActivity(
      id: 'showcase-3',
      kind: ActivityKind.walk,
      startedAt: now.subtract(const Duration(days: 2)),
      duration: const Duration(minutes: 42, seconds: 10),
      distanceKm: 3.80,
      calories: 195,
      route: const [
        [28.6100, 77.2050],
        [28.6120, 77.2080],
      ],
    ),
  );

  store.setSleep(7.8);

  runApp(const AthloRunShowcaseApp());
}

class AthloRunShowcaseApp extends StatefulWidget {
  const AthloRunShowcaseApp({super.key});

  @override
  State<AthloRunShowcaseApp> createState() => _AthloRunShowcaseAppState();
}

class _AthloRunShowcaseAppState extends State<AthloRunShowcaseApp> {
  int _screenIndex = 0;

  static const List<String> screenNames = [
    '01_home_dashboard',
    '02_track_gps_run',
    '03_daily_challenges',
    '04_health_sensors',
    '05_athlete_profile',
    '06_activity_history',
    '07_badges_achievements',
    '08_leaderboard',
    '09_welcome',
    '10_onboarding',
    '11_sign_in',
  ];

  Widget _buildScreen(int index) {
    return switch (index) {
      0 => _wrapWithNavBar(0, HomeDashboardPage(onNavigate: _onNav)),
      1 => _wrapWithNavBar(2, const TrackPage()),
      2 => _wrapWithNavBar(1, const DailyChallengesScreen()),
      3 => _wrapWithNavBar(3, const SensorDataScreen()),
      4 => _wrapWithNavBar(4, const AthleteProfilePage()),
      5 => const ActivityHistoryPage(),
      6 => const BadgesScreen(),
      7 => const LeaderboardPage(),
      8 => WelcomePage(onGetStarted: () => _setScreen(9), onSignIn: () => _setScreen(11)),
      9 => OnboardingPage(onDone: () => _setScreen(11)),
      10 => const SignInPage(),
      _ => _wrapWithNavBar(0, HomeDashboardPage(onNavigate: _onNav)),
    };
  }

  void _onNav(int tab) {
    if (tab == 0) _setScreen(0);
    if (tab == 1) _setScreen(2);
    if (tab == 2) _setScreen(1);
    if (tab == 3) _setScreen(3);
    if (tab == 4) _setScreen(4);
  }

  void _setScreen(int idx) {
    setState(() {
      _screenIndex = idx.clamp(0, screenNames.length - 1);
    });
    // ignore: avoid_print
    print('SCREEN_SWITCHED:${screenNames[_screenIndex]}:$_screenIndex');
  }

  Widget _wrapWithNavBar(int navIndex, Widget child) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _KitNavBar(
        index: navIndex,
        onSelect: (i) {
          if (i == 0) _setScreen(0);
          if (i == 1) _setScreen(2);
          if (i == 2) _setScreen(1);
          if (i == 3) _setScreen(3);
          if (i == 4) _setScreen(4);
        },
      ),
    );
  }

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKey);
  }

  bool _handleKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.keyN) {
        _setScreen((_screenIndex + 1) % screenNames.length);
        return true;
      } else if (event.logicalKey == LogicalKeyboardKey.keyP) {
        _setScreen((_screenIndex - 1 + screenNames.length) % screenNames.length);
        return true;
      }
    }
    return false;
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKey);
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AthloRun Showcase',
      theme: AppTheme.light,
      home: Scaffold(
        body: _buildScreen(_screenIndex),
      ),
    );
  }
}

class _KitNavBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onSelect;

  const _KitNavBar({required this.index, required this.onSelect});

  static const _tabs = [
    (Icons.home_outlined, Icons.home_rounded, 'Home'),
    (Icons.emoji_events_outlined, Icons.emoji_events_rounded, 'Challenges'),
    (Icons.add, Icons.add, 'Track'),
    (Icons.monitor_heart_outlined, Icons.monitor_heart_rounded, 'Sensors'),
    (Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF090E1D).withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 8,
        bottom: MediaQuery.paddingOf(context).bottom + 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var i = 0; i < _tabs.length; i++)
            _buildTab(context, i, _tabs[i]),
        ],
      ),
    );
  }

  Widget _buildTab(
    BuildContext context,
    int i,
    (IconData, IconData, String) tab,
  ) {
    final selected = i == index;
    if (i == 2) {
      return GestureDetector(
        onTap: () => onSelect(2),
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppPalette.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppPalette.primary.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      );
    }
    return InkWell(
      onTap: () => onSelect(i),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? tab.$2 : tab.$1,
              color: selected ? AppPalette.primary : AppPalette.muted,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              tab.$3,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: selected ? AppPalette.primary : AppPalette.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
