import 'package:athlorun/core/firebase/data/datasources/remote/firestore_backend.dart';
import 'package:athlorun/core/global_store/data/models/user_data_response_model.dart';

class GlobalStoreClient {
  GlobalStoreClient(this._backend);

  final FirestoreBackend _backend;

  Future<UserDataResponseModel> getUserData(String id) async {
    final json = await _backend.getDocument(
      collection: 'users',
      docId: id,
      fallback: {'statusCode': 200, 'data': {}},
    );
    return UserDataResponseModel.fromJson(json);
  }
}
