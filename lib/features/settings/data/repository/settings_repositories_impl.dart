import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/settings/data/datasources/remote/settings_page_client.dart';
import 'package:athlorun/features/settings/data/model/delete_user_response_model.dart';
import 'package:athlorun/features/settings/data/model/get_notification_preference_response_model.dart';
import 'package:athlorun/features/settings/data/model/update_notification_preferences_request_model.dart';
import 'package:athlorun/features/settings/data/model/update_notification_preferences_response_model.dart';
import '../../domain/repository/settings_repository.dart';

class SettingsRepositoriesImpl implements SettingsRepository {
  final SettingsClient _remoteClient;
  const SettingsRepositoriesImpl(this._remoteClient);

  @override
  Future<Either<Failure, DeleteUserResponseModel>> deleteUser(String id) async {
    try {
      final response = await _remoteClient.deleteUser(id);
      return right(response);
    } catch (_) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, GetNotificationPreferencesResponseModel>>
      getNotificationPreferences(String id) async {
    try {
      final response = await _remoteClient.getNotificationPreferences(id);
      return right(response);
    } catch (e) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UpdateNotificationPreferencesResponseModel>>
      updateNotificationPreferences(
          String id, UpdateNotificationPreferencesRequestModel body) async {
    try {
      final response =
          await _remoteClient.updateNotificationPreferences(id, body);
      return right(response);
    } catch (e) {
      return left(ServerFailure());
    }
  }
}
