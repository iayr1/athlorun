import 'package:dartz/dartz.dart';
import 'package:athlorun/core/firebase/domain/repository/firebase_repository.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/core/firebase/data/models/enable_notification_request_model.dart';
import 'package:athlorun/core/firebase/data/models/enable_notification_response_model.dart';

class EnableNotificationUsecase {
  final FirebaseRepository _repository;
  const EnableNotificationUsecase(this._repository);
  Future<Either<Failure, EnableNotificationResponseModel>> call(
      String id, EnableNotificationRequestModel body) async {
    return _repository.enableNotification(id, body);
  }
}
