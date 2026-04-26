// To parse this JSON data, do
//
//     final updateNotificationPreferencesResponseModel = updateNotificationPreferencesResponseModelFromJson(jsonString);

import 'dart:convert';

UpdateNotificationPreferencesResponseModel updateNotificationPreferencesResponseModelFromJson(String str) => UpdateNotificationPreferencesResponseModel.fromJson(json.decode(str));

String updateNotificationPreferencesResponseModelToJson(UpdateNotificationPreferencesResponseModel data) => json.encode(data.toJson());

class UpdateNotificationPreferencesResponseModel {
    final int? status;
    final String? statusText;
    final String? message;
    final dynamic data;

    UpdateNotificationPreferencesResponseModel({
        this.status,
        this.statusText,
        this.message,
        this.data,
    });

    factory UpdateNotificationPreferencesResponseModel.fromJson(Map<String, dynamic> json) => UpdateNotificationPreferencesResponseModel(
        status: json["status"],
        statusText: json["statusText"],
        message: json["message"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "statusText": statusText,
        "message": message,
        "data": data,
    };
}
