import 'package:dio/dio.dart';
import 'package:athlorun/core/constants/api_strings.dart';
import 'package:athlorun/core/firebase/data/models/enable_notification_request_model.dart';
import 'package:athlorun/core/firebase/data/models/enable_notification_response_model.dart';

import 'package:retrofit/retrofit.dart';
part 'firebase_client.g.dart';

@RestApi()
abstract class FirebaseClient {
  factory FirebaseClient(Dio dio) = _FirebaseClient;

  @POST(ApiStrings.enableNotification)
  Future<EnableNotificationResponseModel> enableNotification(
    @Path("id") String id,
    @Body() EnableNotificationRequestModel body,
  );
}
