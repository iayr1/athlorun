import 'dart:io';

import 'package:athlorun/core/firebase/data/datasources/remote/firestore_backend.dart';
import 'package:athlorun/features/track/data/models/activities_request_model.dart';
import 'package:athlorun/features/track/data/models/choose_sport_response_model.dart';

class TrackClient {
  TrackClient(this._backend);

  final FirestoreBackend _backend;

  Future<SportsResponseModel> chooseSports() async {
    final sports = await _backend.getCollection(collection: 'sports');
    return SportsResponseModel.fromJson({
      'statusCode': 200,
      'message': 'Fetched',
      'data': sports,
    });
  }

  Future<ActivitiesRequestModel> submitActivity(
    String id,
    String polyline,
    String sportId,
    String completedAt,
    String distanceInKM,
    String durationInSeconds,
    String stepsCount,
    String name,
    String description,
    String mapType,
    String gearId,
    String hideStatistics,
    String exertion,
    File mediaFile,
  ) async {
    final data = {
      'polyline': polyline,
      'sportId': sportId,
      'completedAt': completedAt,
      'distanceInKM': distanceInKM,
      'durationInSeconds': durationInSeconds,
      'stepsCount': stepsCount,
      'name': name,
      'description': description,
      'mapType': mapType,
      'gearId': gearId,
      'hideStatistics': hideStatistics,
      'exertion': exertion,
      'mediaFilePath': mediaFile.path,
      'userId': id,
    };
    await _backend.upsertDocument(collection: 'activities', docId: '${id}_$completedAt', data: data);
    return ActivitiesRequestModel.fromJson(data);
  }
}
