import 'package:athlorun/core/firebase/data/datasources/remote/firestore_backend.dart';
import 'package:athlorun/features/challenges/data/models/response/get_challenge_response_model.dart';
import 'package:athlorun/features/challenges/data/models/response/get_participated_challenges_response_model.dart';
import 'package:athlorun/features/challenges/data/models/response/get_user_participated_challenges_response_model.dart';
import 'package:athlorun/features/challenges/data/models/response/leave_participated_challenges_response_model.dart';
import 'package:athlorun/features/challenges/data/models/response/post_user_participated_challenges_response_model.dart';

class ChallengesClient {
  ChallengesClient(this._backend);

  final FirestoreBackend _backend;

  Future<GetChallengeResponseModel> getChallenges(String userId) async {
    final docs = await _backend.getCollection(collection: 'challenges');
    return GetChallengeResponseModel.fromJson({'statusCode': 200, 'message': 'Fetched', 'data': docs});
  }

  Future<GetUserParticipatedChallengesResponseModel> getUserParticipatedChallenges(String userId, String? status) async {
    final docs = await _backend.getCollection(collection: 'participated_challenges', field: 'userId', isEqualTo: userId);
    final filtered = status == null ? docs : docs.where((e) => e['status'] == status).toList();
    return GetUserParticipatedChallengesResponseModel.fromJson({'statusCode': 200, 'message': 'Fetched', 'data': filtered});
  }

  Future<PostUserParticipatedChallengesResponseModel> participatedChallenges(String userId, String challengeId) async {
    final data = {'userId': userId, 'challengeId': challengeId, 'status': 'active'};
    await _backend.upsertDocument(collection: 'participated_challenges', docId: '${userId}_$challengeId', data: data);
    return PostUserParticipatedChallengesResponseModel.fromJson({'statusCode': 200, 'message': 'Joined', 'data': data});
  }

  Future<GetParticipatedChallengesResponseModel> getParticipatedChallenges(String userId, String challengeId) async {
    final data = await _backend.getDocument(collection: 'participated_challenges', docId: '${userId}_$challengeId', fallback: {'userId': userId, 'challengeId': challengeId});
    return GetParticipatedChallengesResponseModel.fromJson({'statusCode': 200, 'message': 'Fetched', 'data': data});
  }

  Future<LeaveParticipatedChallengesResponseModel> leaveParticipatedChallenges(String userId, String challengeId) async {
    await _backend.deleteDocument(collection: 'participated_challenges', docId: '${userId}_$challengeId');
    return LeaveParticipatedChallengesResponseModel.fromJson({'statusCode': 200, 'message': 'Left challenge'});
  }
}
