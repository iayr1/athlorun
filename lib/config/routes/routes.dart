import 'package:flutter/material.dart';

class AppRoutes {
  static const String splashScreen = '/splash';
  static const String signIn = '/sign-in';

  static const String home = '/home';
  static const String profile = '/profile';
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
  static const String partcipatedChallengeDetailScreen =
      '/participated-challenge-detail';

  // Social
  static const String friendsScreen = '/friends';
  static const String friendsProfileScreen = '/friends-profile';

  // Home / settings
  static const String notification = '/notification';
  static const String pushNotification = '/push-notification';
  static const String search = '/search';
  static const String searchScreen = search;
  static const String settingsPage = '/settings';

  // Profile
  static const String allGear = '/all-gear';
  static const String addNewGear = '/add-new-gear';
  static const String chooseActivity = '/choose-activity';
  static const String activityDetailsPage = '/activity-details';
  static const String profileUpdateScreen = '/profile-update';
  static const String scheduleScreen = '/schedule';
  static const String statisticsScreen = '/statistics';
  static const String mapActivityScreen = '/map-activity';
  static const String navigateScreen = '/navigate';

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
    profile: (_) => const _UiRoutePlaceholder(title: 'Profile'),
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
    partcipatedChallengeDetailScreen: (_) =>
        const _UiRoutePlaceholder(title: 'Participated Challenge Detail'),
    friendsScreen: (_) => const _UiRoutePlaceholder(title: 'Friends'),
    friendsProfileScreen: (_) =>
        const _UiRoutePlaceholder(title: 'Friend Profile'),
    notification: (_) => const _UiRoutePlaceholder(title: 'Notification'),
    pushNotification: (_) => const _UiRoutePlaceholder(title: 'Push Notification'),
    search: (_) => const _UiRoutePlaceholder(title: 'Search'),
    settingsPage: (_) => const _UiRoutePlaceholder(title: 'Settings'),
    allGear: (_) => const _UiRoutePlaceholder(title: 'All Gear'),
    addNewGear: (_) => const _UiRoutePlaceholder(title: 'Add New Gear'),
    chooseActivity: (_) => const _UiRoutePlaceholder(title: 'Choose Activity'),
    activityDetailsPage: (_) =>
        const _UiRoutePlaceholder(title: 'Activity Details'),
    profileUpdateScreen: (_) =>
        const _UiRoutePlaceholder(title: 'Profile Update'),
    scheduleScreen: (_) => const _UiRoutePlaceholder(title: 'Schedule'),
    statisticsScreen: (_) => const _UiRoutePlaceholder(title: 'Statistics'),
    mapActivityScreen: (_) => const _UiRoutePlaceholder(title: 'Map Activity'),
    navigateScreen: (_) => const _UiRoutePlaceholder(title: 'Navigate'),
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
