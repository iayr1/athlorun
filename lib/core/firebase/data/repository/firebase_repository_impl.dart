import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:athlorun/core/firebase/data/datasources/local/firebase_local_data_source.dart';
import 'package:athlorun/core/firebase/data/datasources/remote/firebase_client.dart';
import 'package:athlorun/core/firebase/data/models/enable_notification_request_model.dart';
import 'package:athlorun/core/firebase/data/models/enable_notification_response_model.dart';
import 'package:athlorun/core/firebase/domain/repository/firebase_repository.dart';
import 'package:athlorun/core/status/failures.dart';

class FirebaseRepositoryImpl extends FirebaseRepository {
  final FirebaseClient _client;
  final FirebaseLocalDataSource _localDataSource;
  FirebaseRepositoryImpl(this._client, this._localDataSource);
  @override
  Future<Either<Failure, EnableNotificationResponseModel>> enableNotification(
      String id, EnableNotificationRequestModel body) async {
    try {
      final response = await _client.enableNotification(id, body);
      return right(response);
    } catch (_) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String?>> getFcmToken() async {
    try {
      final response = await _localDataSource.getFcmToken();
      return right(response);
    } catch (_) {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, void>> onTokenRefresh(
      void Function(String token) onData) async {
    try {
      final response = await _localDataSource.onTokenRefresh(onData);
      return right(response);
    } catch (_) {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, NotificationSettings>> requestPermission() async {
    try {
      final response = await _localDataSource.requestPermission();
      return right(response);
    } catch (_) {
      return left(GeneralFailure());
    }
  }
}
