import 'package:flutter/material.dart';

class AppRoutes {
  static const String home = '/home';
  static const String track = '/track';
  static const String pedometer = '/pedometer';
  static const String scoreListScreen = '/score-list';
  static const String congratulationScreen = '/congratulation';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(
          child: Text('UI-only build: route not configured.'),
        ),
      ),
      settings: settings,
    );
  }

  static final Map<String, WidgetBuilder> routes = {
    home: (_) => const _UiRoutePlaceholder(title: 'Home'),
    track: (_) => const _UiRoutePlaceholder(title: 'Track'),
    pedometer: (_) => const _UiRoutePlaceholder(title: 'Pedometer'),
    scoreListScreen: (_) => const _UiRoutePlaceholder(title: 'Score List'),
    congratulationScreen: (_) => const _UiRoutePlaceholder(title: 'Congratulations'),
  };
}

class _UiRoutePlaceholder extends StatelessWidget {
  final String title;

  const _UiRoutePlaceholder({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('$title screen (UI only)'),
      ),
    );
  }
}
