import 'package:dio/dio.dart';
import 'package:athlorun/core/constants/api_strings.dart';
import 'package:athlorun/features/settings/data/model/get_notification_preference_response_model.dart';
import 'package:athlorun/features/settings/data/model/update_notification_preferences_request_model.dart';
import 'package:athlorun/features/settings/data/model/update_notification_preferences_response_model.dart';
import 'package:athlorun/features/settings/data/model/delete_user_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'settings_page_client.g.dart';

@RestApi()
abstract class SettingsClient {
  factory SettingsClient(Dio dio) = _SettingsClient;

  @DELETE(ApiStrings.users)
  Future<DeleteUserResponseModel> deleteUser(
    @Path("id") String id,
  );

  @GET(ApiStrings.notificationPreferences)
  Future<GetNotificationPreferencesResponseModel> getNotificationPreferences(
    @Path("id") String id,
  );

  @PATCH(ApiStrings.notificationPreferences)
  Future<UpdateNotificationPreferencesResponseModel>
      updateNotificationPreferences(
    @Path("id") String id,
    @Body() UpdateNotificationPreferencesRequestModel body,
  );
}
