import 'package:athlorun/features/home/presentation/pages/health_page.dart';
import 'package:athlorun/features/track/presentation/pages/track_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  runApp(const AthloRunUiOnlyApp());
}

class AthloRunUiOnlyApp extends StatelessWidget {
  const AthloRunUiOnlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF357EFB);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AthloRun',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        scaffoldBackgroundColor: const Color(0xFFF6F8FE),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  final List<Widget> _pages = const [
    UiSectionPage(
      title: 'Home',
      subtitle: 'Track progress, stay active, and hit your daily goals',
      items: [
        UiMenuItem('Dashboard', Icons.dashboard_customize_outlined),
        UiMenuItem('Leaderboard', Icons.leaderboard_outlined),
        UiMenuItem('Events', Icons.event_outlined),
        UiMenuItem('Podcast', Icons.podcasts_outlined),
      ],
    ),
    UiSectionPage(
      title: 'Challenges',
      subtitle: 'Join community runs and unlock achievement badges',
      items: [
        UiMenuItem('Challenge List', Icons.flag_outlined),
        UiMenuItem('Challenge Details', Icons.insights_outlined),
        UiMenuItem('Completed Challenges', Icons.verified_outlined),
      ],
    ),
    TrackPage(),
    SensorDataScreen(),
    UiSectionPage(
      title: 'Profile',
      subtitle: 'Manage your profile, settings, and running history',
      items: [
        UiMenuItem('Profile', Icons.person_outline),
        UiMenuItem('Settings', Icons.settings_outlined),
        UiMenuItem('Friends', Icons.group_outlined),
        UiMenuItem('Statistics', Icons.query_stats_outlined),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            label: 'Challenges',
          ),
          NavigationDestination(icon: Icon(Icons.map_outlined), label: 'Track'),
          NavigationDestination(
            icon: Icon(Icons.directions_walk_outlined),
            label: 'Pedometer',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class UiMenuItem {
  final String title;
  final IconData icon;

  const UiMenuItem(this.title, this.icon);
}

class UiSectionPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<UiMenuItem> items;

  const UiSectionPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF387DFB), Color(0xFF4E95FF), Color(0xFFF6F8FE)],
          stops: [0.0, 0.3, 0.55],
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              title,
              style: textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.88),
              ),
            ),
            const SizedBox(height: 18),
            const _TodaySummaryCard(),
            const SizedBox(height: 20),
            Text(
              'Quick Access',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 12),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFEBF3FF),
                      foregroundColor: const Color(0xFF2E74F0),
                      child: Icon(item.icon),
                    ),
                    title: Text(item.title),
                    subtitle: const Text('Ready to explore'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UiPlaceholderScreen(title: item.title),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TodaySummaryCard extends StatelessWidget {
  const _TodaySummaryCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _MetricTile(label: 'Steps', value: '8,420'),
                _MetricTile(label: 'Distance', value: '6.4 km'),
                _MetricTile(label: 'Calories', value: '438'),
              ],
            ),
            SizedBox(height: 12),
            LinearProgressIndicator(value: 0.72, minHeight: 8),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('72% of your daily target completed'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;

  const _MetricTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        Text(label),
      ],
    );
  }
}

class UiPlaceholderScreen extends StatelessWidget {
  final String title;

  const UiPlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        foregroundColor: const Color(0xFF111827),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 36,
                backgroundColor: Color(0xFFE7F0FF),
                child: Icon(Icons.rocket_launch_outlined, size: 34),
              ),
              const SizedBox(height: 16),
              Text(
                '$title is ready',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'UI is connected and polished. You can now wire backend logic here.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
