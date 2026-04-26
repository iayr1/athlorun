import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:athlorun/core/firebase/data/models/enable_notification_request_model.dart';
import 'package:athlorun/core/firebase/data/models/enable_notification_response_model.dart';
import 'package:athlorun/core/status/failures.dart';

abstract class FirebaseRepository {
  Future<Either<Failure, NotificationSettings>> requestPermission();

  Future<Either<Failure, EnableNotificationResponseModel>> enableNotification(
      String id, EnableNotificationRequestModel body);

  Future<Either<Failure, String?>> getFcmToken();

  Future<Either<Failure, void>> onTokenRefresh(void Function(String) onData);
}
