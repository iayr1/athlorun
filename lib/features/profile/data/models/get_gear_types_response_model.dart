// To parse this JSON data, do
//
//     final getGearTypesResponseModel = getGearTypesResponseModelFromJson(jsonString);

import 'dart:convert';

GetGearTypesResponseModel getGearTypesResponseModelFromJson(String str) => GetGearTypesResponseModel.fromJson(json.decode(str));

String getGearTypesResponseModelToJson(GetGearTypesResponseModel data) => json.encode(data.toJson());

class GetGearTypesResponseModel {
    final int? status;
    final String? statusText;
    final String? message;
    final List<Datum>? data;

    GetGearTypesResponseModel({
        this.status,
        this.statusText,
        this.message,
        this.data,
    });

    factory GetGearTypesResponseModel.fromJson(Map<String, dynamic> json) => GetGearTypesResponseModel(
        status: json["status"],
        statusText: json["statusText"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "statusText": statusText,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    final String? id;
    final String? name;
    final String? icon;
    final bool? isActive;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;

    Datum({
        this.id,
        this.name,
        this.icon,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
