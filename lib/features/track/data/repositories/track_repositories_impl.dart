import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/track/data/models/activities_request_model.dart';
import 'package:athlorun/features/track/data/models/activities_response_model.dart';
import 'package:athlorun/features/track/data/models/choose_sport_response_model.dart';
import '../../../../core/exceptions/custom_exceptions.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/repositories/track_repositories.dart';
import '../datasources/track_client.dart';

class TrackRepositoryImpl implements TrackRepository {
  final TrackClient _client;
  const TrackRepositoryImpl(this._client);

  @override
  Future<Either<Failure, SportsResponseModel>> chooseSports() async {
    try {
      final response = await _client.chooseSports();
      return right(response);
    } on SocketException catch (_) {
      return left(ConnectionFailure());
    } on TimeoutException catch (_) {
      return left(TimeoutFailure());
    } on ServerException catch (_) {
      return left(ServerFailure());
    } catch (e) {
      Utils.debugLog(e.toString());
      return left(GeneralFailure());
    }
  }

  @override
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
      File mediaFile) async {
    try {
      final response = await _client.submitActivity(
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
      return right(response);
    } on SocketException catch (_) {
      return left(ConnectionFailure());
    } on TimeoutException catch (_) {
      return left(TimeoutFailure());
    } on ServerException catch (_) {
      return left(ServerFailure());
    } catch (e) {
      Utils.debugLog(e.toString());
      return left(GeneralFailure());
    }
  }
}
