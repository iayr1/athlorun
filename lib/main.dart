import 'package:athlorun/config/themes/app_theme.dart';
import 'package:athlorun/core/services/metrics_store.dart';
import 'package:athlorun/core/services/step_tracker.dart';
import 'package:athlorun/features/challenges/presentation/pages/daily_challenges_screen.dart';
import 'package:athlorun/features/home/presentation/pages/health_page.dart';
import 'package:athlorun/features/home/presentation/pages/home_dashboard_page.dart';
import 'package:athlorun/features/profile/presentation/pages/athlete_profile_page.dart';
import 'package:athlorun/features/track/presentation/pages/track_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  await MetricsStore.instance.load();
  runApp(const AthloRunApp());
}

class AthloRunApp extends StatelessWidget {
  const AthloRunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AthloRun',
      theme: AppTheme.light,
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  /// Starts step counting on launch. Disabled in widget tests.
  final bool startSensors;

  const AppShell({super.key, this.startSensors = true});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const _tabCount = 5;

  int _index = 0;

  /// Tabs are built lazily on first visit and then kept alive, so an active
  /// GPS workout keeps recording while the user browses other tabs.
  final Set<int> _visited = {0};

  @override
  void initState() {
    super.initState();
    if (widget.startSensors) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        StepTracker.instance.start();
      });
    }
  }

  void _select(int index) {
    if (index == _index) return;
    HapticFeedback.selectionClick();
    setState(() {
      _index = index;
      _visited.add(index);
    });
  }

  Widget _buildTab(int index) {
    if (!_visited.contains(index)) return const SizedBox.shrink();
    return switch (index) {
      0 => HomeDashboardPage(onNavigate: _select),
      1 => const DailyChallengesScreen(),
      2 => const TrackPage(),
      3 => const SensorDataScreen(),
      _ => const AthleteProfilePage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _index == 0 || _index == 4
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: [for (var i = 0; i < _tabCount; i++) _buildTab(i)],
        ),
        bottomNavigationBar: DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: _select,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.emoji_events_outlined),
                selectedIcon: Icon(Icons.emoji_events_rounded),
                label: 'Challenges',
              ),
              NavigationDestination(
                icon: _TrackIcon(selected: false),
                selectedIcon: _TrackIcon(selected: true),
                label: 'Track',
              ),
              NavigationDestination(
                icon: Icon(Icons.monitor_heart_outlined),
                selectedIcon: Icon(Icons.monitor_heart_rounded),
                label: 'Sensors',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Highlighted centre tab for starting a workout.
class _TrackIcon extends StatelessWidget {
  final bool selected;

  const _TrackIcon({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 34,
      decoration: BoxDecoration(
        gradient: AppPalette.hero,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppPalette.primary.withValues(alpha: selected ? 0.45 : 0.25),
            blurRadius: selected ? 12 : 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(Icons.directions_run_rounded, color: Colors.white),
    );
  }
}
