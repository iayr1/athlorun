// To parse this JSON data, do
//
//     final createGearResponseModel = createGearResponseModelFromJson(jsonString);

import 'dart:convert';

CreateGearRequestModel CreateGearRequestModelFromJson(String str) => CreateGearRequestModel.fromJson(json.decode(str));

String CreateGearRequestModelToJson(CreateGearRequestModel data) => json.encode(data.toJson());

class CreateGearRequestModel {
    final int? status;
    final String? statusText;
    final String? message;
    final Data? data;

    CreateGearRequestModel({
        this.status,
        this.statusText,
        this.message,
        this.data,
    });

    factory CreateGearRequestModel.fromJson(Map<String, dynamic> json) => CreateGearRequestModel(
        status: json["status"],
        statusText: json["statusText"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "statusText": statusText,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    final String? brand;
    final String? model;
    final String? weight;
    final Sport? type;
    final Sport? sport;
    final String? photo;
    final String? id;
    final bool? isActive;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;

    Data({
        this.brand,
        this.model,
        this.weight,
        this.type,
        this.sport,
        this.photo,
        this.id,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        brand: json["brand"],
        model: json["model"],
        weight: json["weight"],
        type: json["type"] == null ? null : Sport.fromJson(json["type"]),
        sport: json["sport"] == null ? null : Sport.fromJson(json["sport"]),
        photo: json["photo"],
        id: json["id"],
        isActive: json["isActive"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
    );

    Map<String, dynamic> toJson() => {
        "brand": brand,
        "model": model,
        "weight": weight,
        "type": type?.toJson(),
        "sport": sport?.toJson(),
        "photo": photo,
        "id": id,
        "isActive": isActive,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedAt": deletedAt,
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
