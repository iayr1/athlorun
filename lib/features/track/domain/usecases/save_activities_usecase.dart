import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import '../../data/models/activities_request_model.dart';
import '../repositories/track_repositories.dart';

class SaveActivitiesUsecase {
  final TrackRepository _repository;
  const SaveActivitiesUsecase(this._repository);
  Future<Either<Failure, ActivitiesRequestModel>> call(
    String id,
    String polyline,
    String sportId,
    String completedAt,
    String distanceInKm,
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
    return _repository.submitActivity(
        id,
        polyline,
        sportId,
        completedAt,
        distanceInKm,
        durationInSeconds,
        stepsCount,
        name,
        description,
        mapType,
        gearId,
        hideStatistics,
        exertion,
        mediaFile);
  }
}
