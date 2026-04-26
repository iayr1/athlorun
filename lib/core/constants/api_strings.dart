class ApiStrings {
  //testing base url
  static const baseURL = "https://dev.athlorun.connectonmap.com";
  //prod base url
  // static const baseURL = "https://athlorun.connectonmap.com";
  //local base url
  // static const baseURL = "http://192.168.1.21:8000";

  static const sentOtp = "$baseURL/v1/auth/send-otp";
  static const verifyOtp = "$baseURL/v1/auth/verify-otp";
  static const users = "$baseURL/v1/users/{id}";
  static const uploadSelfie = "$baseURL/v1/users/{id}/upload-profile-photo";
  static const notifications = "$baseURL/v1/notifications/get-by-user";
  static const markNotificationsAsSeen = "$baseURL/v1/notifications/{id}";
  static const enableNotification =
      "$baseURL/v1/users/{id}/notifications/enable";
  static const notificationPreferences =
      "$baseURL/v1/users/{id}/notifications/preferences";
  static const targets = "$baseURL/v1/targets";

  //HOME SCREEN API
  static const postStepData = "$baseURL/v1/users/{id}/steps";

  //GEAR API
  static const getGearTypes = "$baseURL/v1/gear-types";
  static const gear = "$baseURL/v1/users/{id}/gears";
  static const deleteGear = "$baseURL/v1/users/{id}/gears/{gearId}";
  static const updateGear = "$baseURL/v1/users/{id}/gears/{gearId}";
  static const getSports = "$baseURL/v1/sports";

  //SCHEDULE API
  static const schedule =
      "$baseURL/v1/users/{id}/schedules"; //create and get url
  static const deleteschedule = "$baseURL/v1/users/{id}/schedules/{scheduleId}";
  static const updateschedule = "$baseURL/v1/users/{id}/schedules/{scheduleId}";
  static const isCompleteUpdateSchedule =
      "$baseURL/v1/users/{id}/schedules/{scheduleId}";

  //CHALLENGES API
  static const getUserChallenges = "$baseURL/v1/challenges";
  static const getUserParticipatedChallenges =
      "$baseURL/v1/users/{id}/challenges";
  static const participateUserInTheChallenge =
      "$baseURL/v1/users/{id}/challenges/{challengeId}";
  static const getParticipateUserInTheChallenge =
      "$baseURL/v1/users/{id}/challenges/{challengeId}";
  static const leaveParticipatedChallenge =
      "$baseURL/v1/users/{id}/challenges/{challengeId}";

  //WALLET API
  static const getUserWallet =
      "$baseURL/v1/users/{user_id}/wallets/{wallet_id}";

  //EVENTS API
  static const getEvents = "$baseURL/v1/events?status=active";

  //CHOOSE SPORTS API
  static const chooseSports = "$baseURL/v1/sports";
  static const submitActivity = "$baseURL/v1/users/{id}/activities";

  static const bookedEventTicket =
      "$baseURL/v1/users/{user_id}/events/{eventId}/slots/{slotId}";
}
