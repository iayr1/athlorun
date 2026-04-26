import 'package:athlorun/core/firebase/data/datasources/remote/firestore_backend.dart';
import 'package:athlorun/features/home/data/models/request/step_request_model.dart';
import 'package:athlorun/features/home/data/models/response/step_response_model.dart';
import 'package:athlorun/features/home/data/models/response/wallet_response_model.dart';

class HomeRemoteClient {
  HomeRemoteClient(this._backend);

  final FirestoreBackend _backend;

  Future<dynamic> getNotifications(String type, String status) async {
    final docs = await _backend.getCollection(
      collection: 'notifications',
      field: 'type',
      isEqualTo: type,
    );
    return {
      'status': 200,
      'data': docs.where((e) => e['status'] == status).toList(),
    };
  }

  Future<dynamic> markNotificationsAsSeen(String id) async {
    await _backend.upsertDocument(
      collection: 'notifications',
      docId: id,
      data: {'status': 'seen'},
    );
    return {'status': 200, 'message': 'Updated'};
  }

  Future<StepResponseModel> updateStepCount(String id, StepRequestModel body) async {
    final data = body.toJson();
    data['userId'] = id;
    await _backend.upsertDocument(collection: 'steps', docId: id, data: data);
    return StepResponseModel.fromJson({
      'status': 200,
      'statusText': 'OK',
      'message': 'Steps updated',
      'data': data,
    });
  }

  Future<WalletResponseModel> getWallet(String userId, String walletId) async {
    final json = await _backend.getDocument(
      collection: 'wallets',
      docId: '${userId}_$walletId',
      fallback: {'status': 200, 'data': {}},
    );
    return WalletResponseModel.fromJson(json);
  }
}
