import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/settings/data/model/delete_user_response_model.dart';
import 'package:athlorun/features/settings/data/model/get_notification_preference_response_model.dart';
import 'package:athlorun/features/settings/data/model/update_notification_preferences_request_model.dart';
import 'package:athlorun/features/settings/data/model/update_notification_preferences_response_model.dart';

abstract class SettingsRepository {
  Future<Either<Failure, DeleteUserResponseModel>> deleteUser(String id);
  Future<Either<Failure, GetNotificationPreferencesResponseModel>>
      getNotificationPreferences(String id);

  Future<Either<Failure, UpdateNotificationPreferencesResponseModel>>
      updateNotificationPreferences(
    String id,
    UpdateNotificationPreferencesRequestModel body,
  );
}
