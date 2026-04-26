import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:athlorun/features/track/data/models/choose_sport_response_model.dart';
import '../../../../core/status/failures.dart';
import '../../data/models/activities_request_model.dart';
import '../../data/models/activities_response_model.dart';

abstract class TrackRepository {
  Future<Either<Failure, SportsResponseModel>> chooseSports();
  Future<Either<Failure, ActivitiesRequestModel>> submitActivity(
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
  );
}
