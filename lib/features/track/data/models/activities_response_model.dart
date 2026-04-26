// To parse this JSON data, do
//
//     final activitiesResponseModel = activitiesResponseModelFromJson(jsonString);

import 'dart:convert';

ActivitiesResponseModel activitiesResponseModelFromJson(String str) => ActivitiesResponseModel.fromJson(json.decode(str));

String activitiesResponseModelToJson(ActivitiesResponseModel data) => json.encode(data.toJson());

class ActivitiesResponseModel {
  int status;
  String statusText;
  String message;
  Data data;

  ActivitiesResponseModel({
    required this.status,
    required this.statusText,
    required this.message,
    required this.data,
  });

  factory ActivitiesResponseModel.fromJson(Map<String, dynamic> json) => ActivitiesResponseModel(
    status: json["status"],
    statusText: json["statusText"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusText": statusText,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  String polyline;
  DateTime completedAt;
  double distanceInKm;
  int durationInSeconds;
  int stepsCount;
  String statistics;
  String name;
  String description;
  String mapType;
  String hideStatistics;
  String exertion;
  Sport sport;
  Gear gear;
  List<String> media;
  String id;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  Data({
    required this.polyline,
    required this.completedAt,
    required this.distanceInKm,
    required this.durationInSeconds,
    required this.stepsCount,
    required this.statistics,
    required this.name,
    required this.description,
    required this.mapType,
    required this.hideStatistics,
    required this.exertion,
    required this.sport,
    required this.gear,
    required this.media,
    required this.id,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    polyline: json["polyline"],
    completedAt: DateTime.parse(json["completedAt"]),
    distanceInKm: json["distanceInKM"]?.toDouble(),
    durationInSeconds: json["durationInSeconds"],
    stepsCount: json["stepsCount"],
    statistics: json["statistics"],
    name: json["name"],
    description: json["description"],
    mapType: json["mapType"],
    hideStatistics: json["hideStatistics"],
    exertion: json["exertion"],
    sport: Sport.fromJson(json["sport"]),
    gear: Gear.fromJson(json["gear"]),
    media: List<String>.from(json["media"].map((x) => x)),
    id: json["id"],
    isActive: json["isActive"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    deletedAt: json["deletedAt"],
  );

  Map<String, dynamic> toJson() => {
    "polyline": polyline,
    "completedAt": completedAt.toIso8601String(),
    "distanceInKM": distanceInKm,
    "durationInSeconds": durationInSeconds,
    "stepsCount": stepsCount,
    "statistics": statistics,
    "name": name,
    "description": description,
    "mapType": mapType,
    "hideStatistics": hideStatistics,
    "exertion": exertion,
    "sport": sport.toJson(),
    "gear": gear.toJson(),
    "media": List<dynamic>.from(media.map((x) => x)),
    "id": id,
    "isActive": isActive,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "deletedAt": deletedAt,
  };
}

class Gear {
  String id;
  String brand;
  String model;
  String weight;
  String photo;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  Gear({
    required this.id,
    required this.brand,
    required this.model,
    required this.weight,
    required this.photo,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Gear.fromJson(Map<String, dynamic> json) => Gear(
    id: json["id"],
    brand: json["brand"],
    model: json["model"],
    weight: json["weight"],
    photo: json["photo"],
    isActive: json["isActive"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    deletedAt: json["deletedAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "brand": brand,
    "model": model,
    "weight": weight,
    "photo": photo,
    "isActive": isActive,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "deletedAt": deletedAt,
  };
}

class Sport {
  String id;
  String name;
  String icon;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  Sport({
    required this.id,
    required this.name,
    required this.icon,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Sport.fromJson(Map<String, dynamic> json) => Sport(
    id: json["id"],
    name: json["name"],
    icon: json["icon"],
    isActive: json["isActive"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    deletedAt: json["deletedAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon": icon,
    "isActive": isActive,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "deletedAt": deletedAt,
  };
}
