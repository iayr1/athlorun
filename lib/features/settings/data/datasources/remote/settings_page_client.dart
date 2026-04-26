import 'package:athlorun/core/firebase/data/datasources/remote/firestore_backend.dart';
import 'package:athlorun/features/settings/data/model/delete_user_response_model.dart';
import 'package:athlorun/features/settings/data/model/get_notification_preference_response_model.dart';
import 'package:athlorun/features/settings/data/model/update_notification_preferences_request_model.dart';
import 'package:athlorun/features/settings/data/model/update_notification_preferences_response_model.dart';

class SettingsClient {
  SettingsClient(this._backend);

  final FirestoreBackend _backend;

  Future<DeleteUserResponseModel> deleteUser(String id) async {
    await _backend.deleteDocument(collection: 'users', docId: id);
    return DeleteUserResponseModel(statusCode: 200, message: 'User deleted');
  }

  Future<GetNotificationPreferencesResponseModel> getNotificationPreferences(String id) async {
    final json = await _backend.getDocument(
      collection: 'notification_preferences',
      docId: id,
      fallback: {'statusCode': 200, 'data': {}},
    );
    return GetNotificationPreferencesResponseModel.fromJson(json);
  }

  Future<UpdateNotificationPreferencesResponseModel> updateNotificationPreferences(
    String id,
    UpdateNotificationPreferencesRequestModel body,
  ) async {
    final data = body.toJson();
    await _backend.upsertDocument(collection: 'notification_preferences', docId: id, data: data);
    return UpdateNotificationPreferencesResponseModel.fromJson({
      'statusCode': 200,
      'message': 'Notification preferences updated',
      'data': data,
    });
  }
}
