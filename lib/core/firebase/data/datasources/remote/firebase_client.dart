import 'package:athlorun/core/firebase/data/datasources/remote/firestore_backend.dart';
import 'package:athlorun/core/firebase/data/models/enable_notification_request_model.dart';
import 'package:athlorun/core/firebase/data/models/enable_notification_response_model.dart';

class FirebaseClient {
  FirebaseClient(this._backend);

  final FirestoreBackend _backend;

  Future<EnableNotificationResponseModel> enableNotification(
    String id,
    EnableNotificationRequestModel body,
  ) async {
    final data = body.toJson();
    await _backend.upsertDocument(collection: 'notification_tokens', docId: id, data: data);
    return EnableNotificationResponseModel.fromJson({'statusCode': 200, 'message': 'Notification enabled', 'data': data});
  }
}
