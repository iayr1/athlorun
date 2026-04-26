import 'package:firebase_messaging_platform_interface/src/notification_settings.dart';
import 'package:athlorun/core/firebase/data/datasources/local/firebase_local_data_source.dart';
import 'package:athlorun/core/firebase/firebase_services.dart';

class FirebaseLocalDataSourceImpl implements FirebaseLocalDataSource {
  final FirebaseServices _services;
  const FirebaseLocalDataSourceImpl(this._services);
  @override
  Future<String?> getFcmToken() {
    return _services.getToken();
  }

  @override
  Future<void> onTokenRefresh(void Function(String token) onData) async {
    _services.onTokenRefresh(onData);
  }

  @override
  Future<NotificationSettings> requestPermission() {
    return _services.requestPermission();
  }
}
