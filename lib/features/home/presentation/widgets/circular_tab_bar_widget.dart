import 'package:flutter/material.dart';
import '../../../dashboard/presentation/pages/dashboard_screen.dart';
import '../../../dashboard/presentation/pages/dashboard_screen_event.dart';
import '../../../dashboard/presentation/pages/dashboard_screen_podcast.dart';

class FloatingCircularTabBarWidget extends StatefulWidget {
  const FloatingCircularTabBarWidget({super.key});

  @override
  _FloatingCircularTabBarWidgetState createState() =>
      _FloatingCircularTabBarWidgetState();
}

class _FloatingCircularTabBarWidgetState
    extends State<FloatingCircularTabBarWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Floating Circular TabBar
        Container(
          color: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withOpacity(0.2),
            ),
            tabs: [
              _buildCircularTab(icon: Icons.dashboard, label: "Dashboard"),
              _buildCircularTab(icon: Icons.event, label: "Events"),
              _buildCircularTab(icon: Icons.podcasts, label: "Podcasts"),
            ],
          ),
        ),

        // TabBarView for Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              DashboardScreen(), // Replace with your DashboardScreen
              DashboardScreenEvent(), // Replace with your DashboardScreenEvent
              DashboardScreenPodcast(), // Replace with your DashboardScreenPodcast
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCircularTab({required IconData icon, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white,
          child: Icon(icon, size: 30, color: Colors.blue),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
