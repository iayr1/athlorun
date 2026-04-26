import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/settings/data/model/update_notification_preferences_request_model.dart';
import 'package:athlorun/features/settings/data/model/update_notification_preferences_response_model.dart';
import 'package:athlorun/features/settings/domain/repository/settings_repository.dart';

class UpdateNotificationPreferencesUsecase {
  final SettingsRepository _repository;
  const UpdateNotificationPreferencesUsecase(this._repository);
  Future<Either<Failure, UpdateNotificationPreferencesResponseModel>> call(
      String id, UpdateNotificationPreferencesRequestModel body) async {
    return _repository.updateNotificationPreferences(id, body);
  }
}
