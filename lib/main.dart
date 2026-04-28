import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:athlorun/features/home/presentation/pages/health_page.dart';
import 'package:athlorun/features/track/presentation/pages/track_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(const AthloRunUiOnlyApp());
}

class AthloRunUiOnlyApp extends StatelessWidget {
  const AthloRunUiOnlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AthloRun UI',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
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
      items: ['Dashboard', 'Leaderboard', 'Events', 'Podcast'],
    ),
    UiSectionPage(
      title: 'Challenges',
      items: ['Challenge List', 'Challenge Details', 'Completed Challenges'],
    ),
    TrackPage(),
    SensorDataScreen(),
    UiSectionPage(
      title: 'Profile',
      items: ['Profile', 'Settings', 'Friends', 'Statistics'],
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
              icon: Icon(Icons.emoji_events_outlined), label: 'Challenges'),
          NavigationDestination(icon: Icon(Icons.map_outlined), label: 'Track'),
          NavigationDestination(
              icon: Icon(Icons.directions_walk_outlined), label: 'Pedometer'),
          NavigationDestination(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class UiSectionPage extends StatelessWidget {
  final String title;
  final List<String> items;

  const UiSectionPage({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$title (UI Only)')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final screenName = items[index];
          return ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            title: Text(screenName),
            subtitle: const Text('UI-only preview screen'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UiPlaceholderScreen(title: screenName),
                ),
              );
            },
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemCount: items.length,
      ),
    );
  }
}

class UiPlaceholderScreen extends StatelessWidget {
  final String title;

  const UiPlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title\n(UI connected, no backend logic)',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
