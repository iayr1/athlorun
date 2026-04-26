import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:athlorun/core/firebase/domain/repository/firebase_repository.dart';
import 'package:athlorun/core/status/failures.dart';

class RequestNotificationPermissionUsecase {
  final FirebaseRepository _repository;
  const RequestNotificationPermissionUsecase(this._repository);
  Future<Either<Failure, NotificationSettings>> call() async {
    return _repository.requestPermission();
  }
}
