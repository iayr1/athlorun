import 'package:flutter/material.dart';

class AppRoutes {
  static const String home = '/home';
  static const String track = '/track';
  static const String pedometer = '/pedometer';
  static const String scoreListScreen = '/score-list';
  static const String congratulationScreen = '/congratulation';

  // Dashboard
  static const String dashboardScreen = '/dashboard';
  static const String dashboardScreenEvent = '/dashboard-event';
  static const String dashboardScreenPodcast = '/dashboard-podcast';

  // Coins / rewards
  static const String coinsCreditScreen = '/coins-credit';
  static const String coinsRedeemScreen = '/coins-redeem';
  static const String rewardclaim = '/reward-claim';
  static const String dailyMission = '/daily-mission';
  static const String dailymission = dailyMission;

  // Challenges
  static const String challengePosterScreen = '/challenge-poster';

  // Social
  static const String friendsScreen = '/friends';
  static const String friendsProfileScreen = '/friends-profile';

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
    congratulationScreen: (_) =>
        const _UiRoutePlaceholder(title: 'Congratulations'),
    dashboardScreen: (_) => const _UiRoutePlaceholder(title: 'Dashboard'),
    dashboardScreenEvent: (_) =>
        const _UiRoutePlaceholder(title: 'Dashboard Event'),
    dashboardScreenPodcast: (_) =>
        const _UiRoutePlaceholder(title: 'Dashboard Podcast'),
    coinsCreditScreen: (_) => const _UiRoutePlaceholder(title: 'Coins Credit'),
    coinsRedeemScreen: (_) => const _UiRoutePlaceholder(title: 'Coins Redeem'),
    rewardclaim: (_) => const _UiRoutePlaceholder(title: 'Reward Claim'),
    dailyMission: (_) => const _UiRoutePlaceholder(title: 'Daily Mission'),
    challengePosterScreen: (_) =>
        const _UiRoutePlaceholder(title: 'Challenge Poster'),
    friendsScreen: (_) => const _UiRoutePlaceholder(title: 'Friends'),
    friendsProfileScreen: (_) =>
        const _UiRoutePlaceholder(title: 'Friend Profile'),
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
