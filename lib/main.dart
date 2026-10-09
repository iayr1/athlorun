import 'package:athlorun/config/themes/app_theme.dart';
import 'package:athlorun/core/services/metrics_store.dart';
import 'package:athlorun/core/services/step_tracker.dart';
import 'package:athlorun/core/widgets/kit.dart';
import 'package:athlorun/features/auth/presentation/auth_gate.dart';
import 'package:athlorun/features/challenges/presentation/pages/daily_challenges_screen.dart';
import 'package:athlorun/features/home/presentation/pages/health_page.dart';
import 'package:athlorun/features/home/presentation/pages/home_dashboard_page.dart';
import 'package:athlorun/features/profile/presentation/pages/athlete_profile_page.dart';
import 'package:athlorun/features/track/presentation/pages/track_page.dart';
import 'package:athlorun/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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
      home: AuthGate(appBuilder: (_) => const AppShell()),
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
        bottomNavigationBar: _KitNavBar(index: _index, onSelect: _select),
      ),
    );
  }
}

/// Bottom bar from the kit: icon tabs with a raised blue centre action.
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
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: [
              for (var i = 0; i < _tabs.length; i++)
                Expanded(
                  child: i == 2
                      ? Center(
                          child: Semantics(
                            button: true,
                            selected: index == 2,
                            label: 'Track',
                            child: GestureDetector(
                              onTap: () => onSelect(2),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: AppPalette.blue60,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: index == 2
                                      ? AppPalette.focusRing(AppPalette.blue60)
                                      : [
                                          BoxShadow(
                                            color: AppPalette.blue60
                                                .withValues(alpha: 0.35),
                                            blurRadius: 14,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                ),
                                child: const Center(child: KitPlusIcon()),
                              ),
                            ),
                          ),
                        )
                      : _NavItem(
                          icon: index == i ? _tabs[i].$2 : _tabs[i].$1,
                          label: _tabs[i].$3,
                          selected: index == i,
                          onTap: () => onSelect(i),
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppPalette.blue60 : AppPalette.gray40;
    return Semantics(
      button: true,
      selected: selected,
      child: InkResponse(
        onTap: onTap,
        radius: 32,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppText.family,
                fontSize: 11,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
