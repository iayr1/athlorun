import 'package:flutter/material.dart';
import 'package:athlorun/config/routes/routes.dart';

class ScreenNavigationHub extends StatelessWidget {
  const ScreenNavigationHub({super.key});

  static const List<Map<String, String>> _routes = [
    {'name': 'Splash', 'route': AppRoutes.splashScreen},
    {'name': 'Onboarding', 'route': AppRoutes.onboarding},
    {'name': 'Sign In', 'route': AppRoutes.signIn},
    {'name': 'Setup Name/Email', 'route': AppRoutes.setupNameEmailScreen},
    {'name': 'Setup Target', 'route': AppRoutes.setupTargetScreen},
    {'name': 'Setup Age', 'route': AppRoutes.setupAgeScreen},
    {'name': 'Setup Level', 'route': AppRoutes.setupLevelScreen},
    {'name': 'Setup Gender', 'route': AppRoutes.setupGenderScreen},
    {'name': 'Setup Activity', 'route': AppRoutes.setupActivityScreen},
    {'name': 'Setup Height', 'route': AppRoutes.setupHeightScreen},
    {'name': 'Setup Weight', 'route': AppRoutes.setupWeightScreen},
    {'name': 'Setup Photo', 'route': AppRoutes.setupProfilePhotoScreen},
    {'name': 'Dashboard', 'route': AppRoutes.dashboardScreen},
    {'name': 'Home', 'route': AppRoutes.home},
    {'name': 'Leaderboard', 'route': AppRoutes.leaderboard},
    {'name': 'Track', 'route': AppRoutes.track},
    {'name': 'Challenges', 'route': AppRoutes.challenges},
    {'name': 'Profile', 'route': AppRoutes.profile},
    {'name': 'Events', 'route': AppRoutes.event},
    {'name': 'Settings', 'route': AppRoutes.settingsPage},
    {'name': 'Notifications', 'route': AppRoutes.notification},
    {'name': 'Push Notifications', 'route': AppRoutes.pushNotification},
    {'name': 'Search', 'route': AppRoutes.search},
    {'name': 'Daily Mission', 'route': AppRoutes.dailymission},
    {'name': 'Reward Claimed', 'route': AppRoutes.rewardclaim},
    {'name': 'Badge', 'route': AppRoutes.badgeScreen},
    {'name': 'All Gear', 'route': AppRoutes.allGear},
    {'name': 'Statistics', 'route': AppRoutes.statisticsScreen},
    {'name': 'Friends', 'route': AppRoutes.friendsScreen},
    {'name': 'Choose Activity', 'route': AppRoutes.chooseActivity},
    {'name': 'Activity Details', 'route': AppRoutes.activityDetailsPage},
    {'name': 'Sports Event', 'route': AppRoutes.sportsEventPage},
    {'name': 'Podcast Home', 'route': AppRoutes.podcastHomeScreen},
    {'name': 'Dashboard Event', 'route': AppRoutes.dashboardScreenEvent},
    {'name': 'Dashboard Podcast', 'route': AppRoutes.dashboardScreenPodcast},
    {'name': 'Coins Credit', 'route': AppRoutes.coinsCreditScreen},
    {'name': 'Coins Redeem', 'route': AppRoutes.coinsRedeemScreen},
    {'name': 'Map Activity', 'route': AppRoutes.mapActivityScreen},
    {'name': 'Ticket Success', 'route': AppRoutes.ticketSuccessScreen},
    {'name': 'Ticket Failure', 'route': AppRoutes.ticketFailureScreen},
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
