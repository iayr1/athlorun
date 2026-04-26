import 'dart:convert';
import 'dart:io';

ActivitiesRequestModel activitiesRequestModelFromJson(String str) =>
    ActivitiesRequestModel.fromJson(json.decode(str));

String activitiesRequestModelToJson(ActivitiesRequestModel data) =>
    json.encode(data.toJson());

class ActivitiesRequestModel {
  String polyline;
  String sportId;
  String completedAt;
  String distanceInKm;
  String durationInSeconds;
  String stepsCount;
  String name;
  String description;
  String mapType;
  String gearId;
  String hideStatistics;
  String exertion;
  File mediaFile;

  ActivitiesRequestModel({
    required this.polyline,
    required this.sportId,
    required this.completedAt,
    required this.distanceInKm,
    required this.durationInSeconds,
    required this.stepsCount,
    required this.name,
    required this.description,
    required this.mapType,
    required this.gearId,
    required this.hideStatistics,
    required this.exertion,
    required this.mediaFile,
  });

  factory ActivitiesRequestModel.fromJson(Map<String, dynamic> json) => ActivitiesRequestModel(
    polyline: json["polyline"],
    sportId: json["sportId"],
    completedAt: json["completedAt"],
    distanceInKm: json["distanceInKM"]?.toDouble(),
    durationInSeconds: json["durationInSeconds"],
    stepsCount: json["stepsCount"],
    name: json["name"],
    description: json["description"],
    mapType: json["mapType"],
    gearId: json["gearId"],
    hideStatistics: json["hideStatistics"],
    exertion: json["exertion"],
    mediaFile: File(''),
  );

  Map<String, dynamic> toJson() => {
    "polyline": polyline,
    "sportId": sportId,
    "completedAt": completedAt,
    "distanceInKM": distanceInKm,
    "durationInSeconds": durationInSeconds,
    "stepsCount": stepsCount,
    "name": name,
    "description": description,
    "mapType": mapType,
    "gearId": gearId,
    "hideStatistics": hideStatistics,
    "exertion": exertion,
  };
}
