// To parse this JSON data, do
//
//     final updateNotificationPreferencesRequestModel = updateNotificationPreferencesRequestModelFromJson(jsonString);

import 'dart:convert';

UpdateNotificationPreferencesRequestModel updateNotificationPreferencesRequestModelFromJson(String str) => UpdateNotificationPreferencesRequestModel.fromJson(json.decode(str));

String updateNotificationPreferencesRequestModelToJson(UpdateNotificationPreferencesRequestModel data) => json.encode(data.toJson());

class UpdateNotificationPreferencesRequestModel {
    final List<Preference>? preferences;

    UpdateNotificationPreferencesRequestModel({
        this.preferences,
    });

    factory UpdateNotificationPreferencesRequestModel.fromJson(Map<String, dynamic> json) => UpdateNotificationPreferencesRequestModel(
        preferences: json["preferences"] == null ? [] : List<Preference>.from(json["preferences"]!.map((x) => Preference.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "preferences": preferences == null ? [] : List<dynamic>.from(preferences!.map((x) => x.toJson())),
    };
}

class Preference {
    final String? type;
    final bool? isEnabled;

    Preference({
        this.type,
        this.isEnabled,
    });

    factory Preference.fromJson(Map<String, dynamic> json) => Preference(
        type: json["type"],
        isEnabled: json["isEnabled"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "isEnabled": isEnabled,
    };
}
