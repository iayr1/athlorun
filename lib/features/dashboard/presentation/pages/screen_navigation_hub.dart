import 'package:athlorun/config/routes/routes.dart';
import 'package:flutter/material.dart';

class ScreenNavigationHub extends StatelessWidget {
  const ScreenNavigationHub({super.key});

  static const List<Map<String, String>> _routes = [
    {'name': 'Home', 'route': AppRoutes.home},
    {'name': 'Track', 'route': AppRoutes.track},
    {'name': 'Pedometer', 'route': AppRoutes.pedometer},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Navigation Hub'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final item = _routes[index];
          return ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, item['route']!),
            child: Text(item['name']!),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemCount: _routes.length,
      ),
    );
  }
}
