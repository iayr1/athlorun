// To parse this JSON data, do
//
//     final sportsResponseModel = sportsResponseModelFromJson(jsonString);

import 'dart:convert';

SportsResponseModel sportsResponseModelFromJson(String str) => SportsResponseModel.fromJson(json.decode(str));

String sportsResponseModelToJson(SportsResponseModel data) => json.encode(data.toJson());

class SportsResponseModel {
  int status;
  String statusText;
  String message;
  List<SportsList> data;

  SportsResponseModel({
    required this.status,
    required this.statusText,
    required this.message,
    required this.data,
  });

  factory SportsResponseModel.fromJson(Map<String, dynamic> json) => SportsResponseModel(
    status: json["status"],
    statusText: json["statusText"],
    message: json["message"],
    data: List<SportsList>.from(json["data"].map((x) => SportsList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusText": statusText,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class SportsList {
  String id;
  String name;
  String icon;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  SportsList({
    required this.id,
    required this.name,
    required this.icon,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory SportsList.fromJson(Map<String, dynamic> json) => SportsList(
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
