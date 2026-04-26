// To parse this JSON data, do
//
//     final targetsResponseModel = targetsResponseModelFromJson(jsonString);

import 'dart:convert';

ProfileTargetsResponseModel targetsResponseModelFromJson(String str) =>
    ProfileTargetsResponseModel.fromJson(json.decode(str));

String targetsResponseModelToJson(ProfileTargetsResponseModel data) =>
    json.encode(data.toJson());

class ProfileTargetsResponseModel {
  final int? status;
  final String? statusText;
  final String? message;
  final List<Datum>? data;

  ProfileTargetsResponseModel({
    this.status,
    this.statusText,
    this.message,
    this.data,
  });

  factory ProfileTargetsResponseModel.fromJson(Map<String, dynamic> json) =>
      ProfileTargetsResponseModel(
        status: json["status"],
        statusText: json["statusText"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusText": statusText,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  final String? id;
  final String? name;
  final String? banner;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  Datum({
    this.id,
    this.name,
    this.banner,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        banner: json["banner"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "banner": banner,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedAt": deletedAt,
      };
}
