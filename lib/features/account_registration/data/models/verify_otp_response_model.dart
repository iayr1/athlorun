// To parse this JSON data, do
//
//     final verifyOtpResponseModel = verifyOtpResponseModelFromJson(jsonString);

import 'dart:convert';

VerifyOtpResponseModel verifyOtpResponseModelFromJson(String str) => VerifyOtpResponseModel.fromJson(json.decode(str));

String verifyOtpResponseModelToJson(VerifyOtpResponseModel data) => json.encode(data.toJson());

class VerifyOtpResponseModel {
    final int? status;
    final String? statusText;
    final String? message;
    final Data? data;

    VerifyOtpResponseModel({
        this.status,
        this.statusText,
        this.message,
        this.data,
    });

    factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) => VerifyOtpResponseModel(
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
    final String? phoneNumber;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final String? accessToken;
    final String? refreshToken;

    Data({
        this.id,
        this.phoneNumber,
        this.createdAt,
        this.updatedAt,
        this.accessToken,
        this.refreshToken,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        phoneNumber: json["phoneNumber"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "phoneNumber": phoneNumber,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "accessToken": accessToken,
        "refreshToken": refreshToken,
    };
}
