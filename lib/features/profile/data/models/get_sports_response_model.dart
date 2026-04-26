// To parse this JSON data, do
//
//     final getSportsResponseModel = getSportsResponseModelFromJson(jsonString);

import 'dart:convert';

GetSportsResponseModel getSportsResponseModelFromJson(String str) => GetSportsResponseModel.fromJson(json.decode(str));

String getSportsResponseModelToJson(GetSportsResponseModel data) => json.encode(data.toJson());

class GetSportsResponseModel {
    final int? status;
    final String? statusText;
    final String? message;
    final List<Sport>? data;

    GetSportsResponseModel({
        this.status,
        this.statusText,
        this.message,
        this.data,
    });

    factory GetSportsResponseModel.fromJson(Map<String, dynamic> json) => GetSportsResponseModel(
        status: json["status"],
        statusText: json["statusText"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Sport>.from(json["data"]!.map((x) => Sport.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "statusText": statusText,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Sport {
    final String? id;
    final String? name;
    final String? icon;
    final bool? isActive;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;

    Sport({
        this.id,
        this.name,
        this.icon,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
    });

    factory Sport.fromJson(Map<String, dynamic> json) => Sport(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
        isActive: json["isActive"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "icon": icon,
        "isActive": isActive,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedAt": deletedAt,
    };
}
