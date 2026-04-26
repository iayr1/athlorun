import 'package:firebase_messaging/firebase_messaging.dart';

abstract class FirebaseLocalDataSource {
  Future<String?> getFcmToken();

  Future<void> onTokenRefresh(void Function(String) onData);

  Future<NotificationSettings> requestPermission();
}
