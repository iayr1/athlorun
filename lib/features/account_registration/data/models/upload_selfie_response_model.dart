// To parse this JSON data, do
//
//     final selfieResponseModel = selfieResponseModelFromJson(jsonString);

import 'dart:convert';

SelfieResponseModel selfieResponseModelFromJson(String str) => SelfieResponseModel.fromJson(json.decode(str));

String selfieResponseModelToJson(SelfieResponseModel data) => json.encode(data.toJson());

class SelfieResponseModel {
    final int? status;
    final String? statusText;
    final String? message;
    final Data? data;

    SelfieResponseModel({
        this.status,
        this.statusText,
        this.message,
        this.data,
    });

    factory SelfieResponseModel.fromJson(Map<String, dynamic> json) => SelfieResponseModel(
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
    final String? id;
    final String? profilePhoto;

    Data({
        this.id,
        this.profilePhoto,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        profilePhoto: json["profilePhoto"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "profilePhoto": profilePhoto,
    };
}
