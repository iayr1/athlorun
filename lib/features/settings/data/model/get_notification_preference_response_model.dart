// To parse this JSON data, do
//
//     final getNotificationPreferencesResponseModel = getNotificationPreferencesResponseModelFromJson(jsonString);

import 'dart:convert';

GetNotificationPreferencesResponseModel getNotificationPreferencesResponseModelFromJson(String str) => GetNotificationPreferencesResponseModel.fromJson(json.decode(str));

String getNotificationPreferencesResponseModelToJson(GetNotificationPreferencesResponseModel data) => json.encode(data.toJson());

class GetNotificationPreferencesResponseModel {
    final int? status;
    final String? statusText;
    final String? message;
    final List<Datum>? data;

    GetNotificationPreferencesResponseModel({
        this.status,
        this.statusText,
        this.message,
        this.data,
    });

    factory GetNotificationPreferencesResponseModel.fromJson(Map<String, dynamic> json) => GetNotificationPreferencesResponseModel(
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
    final String? type;
    final bool? isEnabled;

    Datum({
        this.id,
        this.type,
        this.isEnabled,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        type: json["type"],
        isEnabled: json["isEnabled"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "isEnabled": isEnabled,
    };
}
