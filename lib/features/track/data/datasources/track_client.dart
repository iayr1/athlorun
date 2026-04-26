import 'dart:io';

import 'package:dio/dio.dart';
import 'package:athlorun/features/track/data/models/choose_sport_response_model.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/constants/api_strings.dart';
import '../models/activities_request_model.dart';

part 'track_client.g.dart';

@RestApi()
abstract class TrackClient {
  factory TrackClient(Dio dio) = _TrackClient;

  @GET(ApiStrings.chooseSports)
  Future<SportsResponseModel> chooseSports();

  @POST(ApiStrings.submitActivity)
  @MultiPart()
  Future<ActivitiesRequestModel> submitActivity(
    @Path("id") String id,
    @Part(name: "polyline") String polyline,
    @Part(name: "sportId") String sportId,
    @Part(name: "completedAt") String completedAt, // in ISO format
    @Part(name: "distanceInKM") String distanceInKM,
    @Part(name: "durationInSeconds") String durationInSeconds,
    @Part(name: "stepsCount") String stepsCount,
    @Part(name: "name") String name,
    @Part(name: "description") String description,
    @Part(name: "mapType") String mapType,
    @Part(name: "gearId") String gearId,
    @Part(name: "hideStatistics") String hideStatistics,
    @Part(name: "exertion") String exertion,
    @Part(name: "mediaFiles") File mediaFile,
  );
}
