import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseServices {
  late FirebaseMessaging _firebaseMessaging;

  FirebaseServices._init() {
    _firebaseMessaging = _createFirebaseMessaging();
  }

  factory FirebaseServices() {
    return FirebaseServices._init();
  }

  FirebaseMessaging _createFirebaseMessaging() {
    return FirebaseMessaging.instance;
  }

  Future<NotificationSettings> requestPermission() async {
    final NotificationSettings notificationSettings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      badge: true,
      sound: true,
      alert: true,
    );
    FirebaseMessaging.onMessage.listen(_onMessageHandler);

    return notificationSettings;
  }

  /*
  >>> Get Token
*/
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
/*
  <<< Get Token
*/

/*
  >>> On Token Refresh
*/
  Future<void> onTokenRefresh(void Function(String) onData) async {
    _firebaseMessaging.onTokenRefresh.listen(onData);
  }
/*
  <<< On Token Refresh
*/

  Future<void> _onMessageHandler(RemoteMessage message) async {
    if (Platform.isAndroid) {
      final FlutterLocalNotificationsPlugin notificationsPlugin =
          FlutterLocalNotificationsPlugin();

      await _showLocalNotification(notificationsPlugin, message);
    }
  }

  Future<void> _showLocalNotification(
      FlutterLocalNotificationsPlugin notificationsPlugin,
      RemoteMessage message) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("ic_launcher");

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await notificationsPlugin.initialize(initializationSettings);

    notificationsPlugin.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'fcm',
          'General',
          onlyAlertOnce: true,
          importance: Importance.high,
          channelShowBadge: true,
          subText: message.notification?.body,
          icon: "ic_launcher",
          // sound:
          //     const RawResourceAndroidNotificationSound('mixkit_correct_tone'),
          largeIcon: const DrawableResourceAndroidBitmap("ic_launcher"),
        ),
      ),
    );
  }
}
