import 'package:flutter/material.dart';
import 'package:athlorun/core/global_store/data/models/user_data_response_model.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/features/account_registration/presentation/pages/getuserinfo/setup_activity_screen.dart';
import 'package:athlorun/features/account_registration/presentation/pages/getuserinfo/setup_age_screen.dart';
import 'package:athlorun/features/account_registration/presentation/pages/getuserinfo/setup_gender_screen.dart';
import 'package:athlorun/features/account_registration/presentation/pages/getuserinfo/setup_height_screen.dart';
import 'package:athlorun/features/account_registration/presentation/pages/getuserinfo/setup_weight_screen.dart';
import 'package:athlorun/features/account_registration/presentation/pages/login/enter_otp_screen.dart';
import 'package:athlorun/features/account_registration/presentation/pages/getuserinfo/setup_level_screen.dart';
import 'package:athlorun/features/account_registration/presentation/pages/getuserinfo/setup_profile_photo_screen.dart';
import 'package:athlorun/features/account_registration/presentation/pages/getuserinfo/setup_name_email_screen.dart';
import 'package:athlorun/features/account_registration/presentation/pages/getuserinfo/setup_reminder_screen.dart';
import 'package:athlorun/features/account_registration/presentation/pages/getuserinfo/setup_target_screen.dart';
import 'package:athlorun/features/account_registration/presentation/pages/login/sign_in_screen.dart';
import 'package:athlorun/features/challenges/data/models/response/get_challenge_response_model.dart';
import 'package:athlorun/features/challenges/data/models/response/get_user_participated_challenges_response_model.dart';
import 'package:athlorun/features/challenges/presentation/pages/challenge_detailed_screen.dart';
import 'package:athlorun/features/challenges/presentation/pages/challenge_poster_screen.dart';
import 'package:athlorun/features/challenges/presentation/pages/completed_challenge_screen.dart';
import 'package:athlorun/features/challenges/presentation/pages/congratulation_screen.dart';
import 'package:athlorun/features/challenges/presentation/pages/participated_challenge_detailed_screen.dart';
import 'package:athlorun/features/challenges/presentation/pages/score_list_screen.dart';
import 'package:athlorun/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:athlorun/features/dashboard/presentation/pages/dashboard_screen_podcast.dart';
import 'package:athlorun/features/events/data/models/request/ticket_booking_request_model.dart';
import 'package:athlorun/features/events/data/models/response/get_events_response_model.dart';
import 'package:athlorun/features/events/presentation/pages/event_page.dart';
import 'package:athlorun/features/events/presentation/pages/event_details_page.dart';
import 'package:athlorun/features/events/presentation/pages/review_booking_page.dart';
import 'package:athlorun/features/events/presentation/pages/sports_event_page.dart';
import 'package:athlorun/features/events/presentation/pages/ticket_failure_screen.dart';
import 'package:athlorun/features/events/presentation/pages/ticket_succes_screen.dart';
import 'package:athlorun/features/home/presentation/pages/badge_screen.dart';
import 'package:athlorun/features/home/presentation/pages/call_logs_page.dart';
import 'package:athlorun/features/home/presentation/pages/coins_credit_screen.dart';
import 'package:athlorun/features/home/presentation/pages/coins_redeem_screen.dart';
import 'package:athlorun/features/home/presentation/pages/friends_profile_screen.dart';
import 'package:athlorun/features/home/presentation/pages/gallery_screen.dart';
import 'package:athlorun/features/home/presentation/pages/notification_screen.dart';
import 'package:athlorun/features/home/presentation/pages/reward_claimed_screen.dart';
import 'package:athlorun/features/home/presentation/pages/search_screen.dart';
import 'package:athlorun/features/home/presentation/pages/daily_mission_screen.dart';
import 'package:athlorun/features/home/presentation/pages/sms_page.dart';
import 'package:athlorun/features/podcast/podcast_screen.dart';
import 'package:athlorun/features/profile/data/models/get_gear_response_model.dart';
import 'package:athlorun/features/profile/presentation/pages/activity_details_page.dart';
import 'package:athlorun/features/profile/presentation/pages/add_new_gear.dart';
import 'package:athlorun/features/profile/presentation/pages/all_gear_page.dart';
import 'package:athlorun/features/profile/presentation/pages/choose_activity_page.dart';
import 'package:athlorun/features/profile/presentation/pages/friends_list_screen.dart';
import 'package:athlorun/features/profile/presentation/pages/profile_update_page.dart';
import 'package:athlorun/features/profile/presentation/pages/schedule_screen.dart';
import 'package:athlorun/features/profile/presentation/pages/statistics_screen.dart';
import 'package:athlorun/features/settings/presentation/pages/notification_setting_screen.dart';
import 'package:athlorun/features/settings/presentation/pages/setting_page.dart';
import 'package:athlorun/features/splash/presentation/pages/login_error_screen.dart';
import 'package:athlorun/features/track/presentation/pages/activity_screen.dart';
import '../../features/account_registration/presentation/pages/onboarding/onboarding_screen.dart';
import '../../features/challenges/presentation/pages/challenges_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_screen_event.dart';
import '../../features/home/presentation/pages/contacts_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/leaderboard/presentation/pages/leaderboard_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/track/presentation/pages/track_page.dart';

class AppRoutes {
  static const String splashScreen = '/splashScreen';
  static const String onboarding = '/onboarding';
  static const String setupNameEmailScreen = '/setupNameEmailScreen';
  static const String signIn = '/signin';
  static const String enterOtp = '/enterOtp';
  static const String setupTargetScreen = '/setupTargetscreen';
  static const String setupAgeScreen = '/setupAgeScreen';
  static const String setupLevelScreen = '/setupLevelScreen';
  static const String setupActivityScreen = '/setupActivityScreen';
  static const String setupProfilePhotoScreen = '/setupProfilePhotoScreen';
  static const String setupReminderScreen = '/setupReminderScreen';
  static const String dashboardScreen = '/dashboardscreen';
  static const String home = '/home';
  static const String leaderboard = '/leaderboard';
  static const String track = '/track';
  static const String challenges = '/challenges';
  static const String profile = '/profile';
  static const String setupGenderScreen = '/setupGenderScreen';
  static const String search = '/search';
  static const String notification = '/notification';
  static const String event = '/event';
  static const String dailymission = '/dailymission';
  static const String rewardclaim = '/rewardclaim';
  static const String activity = '/activity';
  static const String challengePosterScreen = '/challengeposter';
  static const String addNewGear = '/addnewgear';
  static const String allGear = '/allgear';
  static const String smsPage = 'smspage';
  static const String callLogs = '/calllogs';
  static const String contactPage = '/contactpage';
  static const String galleryPage = '/gallerypage';
  static const String badgeScreen = '/badgescreen';
  static const String scheduleScreen = '/schedulescreen';
  static const String settingsPage = '/settingpage';
  static const String statisticsScreen = '/statisticsscreen';
  static const String friendsScreen = '/friendsscreen';
  static const String scoreListScreen = '/scoreListScreen';
  static const String loginErrorScreen = '/loginerrrorscreen';
  static const String chooseActivity = '/chooseactivity';
  static const String activityDetailsPage = '/activitydetailspage';
  static const String pushNotification = '/pushnotification';
  static const String analysisTab = '/analysistab';
  static const String searchScreen = '/searchscreen';
  static const String friendsProfileScreen = '/friendsprofile';
  static const String sportsEventPage = '/sportseventpage';
  static const String podcastHomeScreen = '/podcastscreen';
  static const String dashboardScreenEvent = '/dashevent';
  static const String dashboardScreenPodcast = '/dashpodcast';
  static const String navigateScreen = '/navigate';
  static const String profileUpdateScreen = '/profileUpdate';
  static const String challengeDetailScreen = '/challengeDetailScreen';
  static const String partcipatedChallengeDetailScreen =
      '/participatedChallengeDetailScreen';
  static const String completedChallengeScreen = '/completedChallengeScreen';
  static const String coinsCreditScreen = '/coinsCreditScreen';
  static const String coinsRedeemScreen = '/coinsRedeemScreen';
  static const String congratulationScreen = '/congratulationScreen';
  static const String setupHeightScreen = '/heightScreen';
  static const String setupWeightScreen = '/weightScreen';
  static const String mapActivityScreen = '/activityScreen2';
  static const String matchDetailsPage = '/MatchDetailsPage';
  static const String reviewBookingPage = '/reviewBookingPage';
  static const String ticketSuccessScreen = '/ticketSuccessScreen';
  static const String ticketFailureScreen = '/ticketFailureScreen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    Utils.debugLog('Navigating to: ${settings.name}');

    return MaterialPageRoute(
      builder: (context) {
        final arguments = settings.arguments; // Retrieve the arguments passed

        switch (settings.name) {
          case AppRoutes.challengeDetailScreen:
            return ChallengeDetailsScreenWrapper(
              challengeDetails: arguments as GetChallengeResponseDataModel,
            );
          case AppRoutes.matchDetailsPage:
            return EventDetailsPageWrapper(
              getEventsResponseModelData:
                  arguments as GetEventsResponseModelData,
            );
          case AppRoutes.partcipatedChallengeDetailScreen:
            return ParticipatedChallengeDetailedScreenWrapper(
              challengeId: arguments as String,
            );
          case AppRoutes.completedChallengeScreen:
            return CompletedChallengeScreen(
                challengeData: arguments as ChallengeChallenge);
          case AppRoutes.challengePosterScreen:
            return ChallengePosterScreenWrapper(
                challengeList: arguments as GetChallengeResponseDataModel);
          case AppRoutes.congratulationScreen:
            return CongratulationScreen(challengeName: arguments as String);
          case AppRoutes.addNewGear:
            return AddNewGearWrapper(
                geardata: arguments as GetGearResponseModelData?);
          case AppRoutes.profileUpdateScreen:
            return ProfileUpdatePageWrapper(userData: arguments as UserData);
          case AppRoutes.reviewBookingPage:
            final args = settings.arguments as Map<String, dynamic>;
            return ReviewBookingPageWrapper(
              slot: args['slot'],
              ticketQuantity: args['ticketQuantity'] as int,
              totalAmount: args['totalAmount'] as double,
              ticketHolder: args['ticketHolderList'] as List<TicketHolder>,
              getEventsResponseModelData: args['getEventsResponseModelData']
                  as GetEventsResponseModelData,
            );
          default:
            return routes[settings.name] ??
                const Scaffold(
                  body: Center(child: Text('No Route Found')),
                );
        }
      },
      settings: settings,
    );
  }

  static Map<String, Widget> routes = {
    splashScreen: const SplashScreenWrapper(),
    onboarding: const OnboardingScreenWrapper(),
    setupNameEmailScreen: const SetupNameEmailScreenWrapper(),
    signIn: const SignInScreenWrapper(),
    enterOtp: const EnterOTPScreenWrapper(),
    setupTargetScreen: const SetupTargetScreenWrapper(),
    setupAgeScreen: const SetupAgeScreenWrapper(),
    setupLevelScreen: const SetupLevelScreenWrapper(),
    setupActivityScreen: const SetupActivityScreenWrapper(),
    setupProfilePhotoScreen: const SetupProfilePhotoScreenWrapper(),
    // setupReminderScreen: const SetupReminderScreenWrapper(),
    dashboardScreen: const DashboardScreen(),
    home: HomePageWrapper(),
    leaderboard: const LeaderboardPage(),
    track: TrackPage(),
    challenges: const ChallengesPageWrapper(),
    profile: ProfilePageWrapper(),
    setupGenderScreen: const SetupGenderScreenWrapper(),
    search: const SearchScreen(),
    notification: const NotificationScreen(),
    event: const EventPageWrapper(),
    dailymission: const DailyMissionScreenWrapper(),
    rewardclaim: const RewardClaimedScreen(),
    allGear: const AllGearPageWrapper(),
    smsPage: const SmsListScreen(),
    callLogs: const CallLogsPage(),
    contactPage: const ContactsPage(),
    galleryPage: const GalleryScreen(),
    badgeScreen: const BadgesScreen(),
    scheduleScreen: const ScheduleScreenWrapper(),
    settingsPage: const SettingScreenWrapper(),
    statisticsScreen: const StatisticScreen(),
    friendsScreen: const FriendsScreen(),
    scoreListScreen: ScoreListScreen(),
    loginErrorScreen: LoginErrorScreen(
      errorMessage: '⚠︎ Error in Login',
    ),
    chooseActivity: ChooseActivityPage(),
    activityDetailsPage: ActivityDetailsPage(),
    pushNotification: NotificationSettingScreenWrapper(),
    analysisTab: AnalysisTab(),
    searchScreen: SearchScreen(),
    friendsProfileScreen: FriendsProfileScreen(),
    sportsEventPage: SportsEventPage(),
    podcastHomeScreen: PodcastHomeScreen(),
    dashboardScreenEvent: DashboardScreenEvent(),
    dashboardScreenPodcast: DashboardScreenPodcast(),
    coinsCreditScreen: CoinsCreditScreen(),
    coinsRedeemScreen: CoinRedeemScreen(),
    setupHeightScreen: SetupHeightScreenWrapper(),
    setupWeightScreen: SetupWeightScreenWrapper(),
    mapActivityScreen: ActivityScreenWrapper(),
    ticketSuccessScreen: TicketSuccessScreen(),
    ticketFailureScreen: TicketFailureScreen()
  };
}

// class AppRoutes {
//   static const String splashScreen = '/splashScreen';
//   static const String onboarding = '/onboarding';
//   static const String setupNameEmailScreen = '/setupNameEmailScreen';
//   static const String signIn = '/signin';
//   static const String enterOtp = '/enterOtp';
//   static const String setupTargetScreen = '/setupTargetscreen';
//   static const String setupAgeScreen = '/setupAgeScreen';
//   static const String setupLevelScreen = '/setupLevelScreen';
//   static const String setupActivityScreen = '/setupActivityScreen';
//   static const String setupProfilePhotoScreen = '/setupProfilePhotoScreen';
//   static const String setupReminderScreen = '/setupReminderScreen';
//   static const String dashboardScreen = '/dashboardscreen';
//   static const String home = '/home';
//   static const String leaderboard = '/leaderboard';
//   static const String track = '/track';
//   static const String challenges = '/challenges';
//   static const String profile = '/profile';
//   static const String setupGenderScreen = '/setupGenderScreen';
//   static const String search = '/search';
//   static const String notification = '/notification';
//   static const String event = '/event';
//   static const String dailymission = '/dailymission';
//   static const String rewardclaim = '/rewardclaim';
//   static const String activity = '/activity';
//   static const String challengePosterScreen = '/challengeposter';
//   static const String addNewGear = '/addnewgear';
//   static const String allGear = '/allgear';
//   static const String smsPage = 'smspage';
//   static const String callLogs = '/calllogs';
//   static const String contactPage = '/contactpage';
//   static const String galleryPage = '/gallerypage';
//   static const String badgeScreen = '/badgescreen';
//   static const String scheduleScreen = '/schedulescreen';
//   static const String settingsPage = '/settingpage';
//   static const String statisticsScreen = '/statisticsscreen';
//   static const String friendsScreen = '/friendsscreen';
//   static const String scoreListScreen = '/scoreListScreen';
//   static const String loginErrorScreen = '/loginerrrorscreen';
//   static const String chooseActivity = '/chooseactivity';
//   static const String activityDetailsPage = '/activitydetailspage';
//   static const String pushNotification = '/pushnotification';
//   static const String analysisTab = '/analysistab';
//   static const String searchScreen = '/searchscreen';
//   static const String friendsProfileScreen = '/friendsprofile';
//   static const String sportsEventPage = '/sportseventpage';
//   static const String podcastHomeScreen = '/podcastscreen';
//   static const String dashboardScreenEvent = '/dashevent';
//   static const String dashboardScreenPodcast = '/dashpodcast';
//   static const String navigateScreen = '/navigate';

//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     return MaterialPageRoute(
//       builder: (context) {
//         return routes[settings.name] ??
//             const Scaffold(
//               body: Center(child: Text('No Route Found')),
//             );
//       },
//       settings: settings,
//     );
//   }

//   static Map<String, Widget> routes = {
//     splashScreen: const SplashScreenWrapper(),
//     onboarding: const OnboardingScreenWrapper(),
//     setupNameEmailScreen: const SetupNameEmailScreenWrapper(),
//     signIn: const SignInScreenWrapper(),
//     enterOtp: const EnterOTPScreenWrapper(),
//     setupTargetScreen: const SetupTargetScreenWrapper(),
//     setupAgeScreen: const SetupAgeScreenWrapper(),
//     setupLevelScreen: const SetupLevelScreenWrapper(),
//     setupActivityScreen: const SetupActivityScreenWrapper(),
//     setupProfilePhotoScreen: const SetupProfilePhotoScreenWrapper(),
//     setupReminderScreen: const SetupReminderScreenWrapper(),
//     dashboardScreen: const DashboardScreen(),
//     home: const HomePageWrapper(),
//     leaderboard: const LeaderboardPage(),
//     track: TrackPage(),
//     challenges: const ChallengesPage(),
//     profile: const ProfilePageWrapper(),
//     setupGenderScreen: const SetupGenderScreenWrapper(),
//     search: const SearchScreen(),
//     notification: const NotificationScreen(),
//     event:  EventPage(),
//     dailymission: const DailyMissionScreen(),
//     rewardclaim: const RewardClaimedScreen(),
//     challengePosterScreen: const ChallengePosterScreen(),
//     addNewGear:  {
//         final arguments = settings.arguments;  // Retrieve the arguments passed

//       AddNewGearWrapper(data: arguments as List<GetGearResponseModelData>?)
//     },
//     allGear: const AllGearPageWrapper(),
//     smsPage: const SmsListScreen(),
//     callLogs: const CallLogsPage(),
//     contactPage: const ContactsPage(),
//     galleryPage: const GalleryScreen(),
//     badgeScreen: const BadgesScreen(),
//     scheduleScreen: const ScheduleScreenWrapper(),
//     settingsPage: const SettingScreenWrapper(),
//     statisticsScreen: const StatisticScreen(),
//     friendsScreen: const FriendsScreen(),
//     scoreListScreen: ScoreListScreen(),
//     loginErrorScreen: LoginErrorScreen(
//       errorMessage: '⚠︎ Error in Login',
//     ),
//     chooseActivity: ChooseActivityPage(),
//     activityDetailsPage: ActivityDetailsPage(),
//     pushNotification: NotificationSettingScreenWrapper(),
//     analysisTab: AnalysisTab(),
//     searchScreen: SearchScreen(),
//     friendsProfileScreen: FriendsProfileScreen(),
//     sportsEventPage: SportsEventPage(),
//     podcastHomeScreen: PodcastHomeScreen(),
//     dashboardScreenEvent: DashboardScreenEvent(),
//     dashboardScreenPodcast: DashboardScreenPodcast(),
//     navigateScreen: NavigateScreen(),
//   };
// }
