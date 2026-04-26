class EnableNotificationRequestModel {
    final String deviceType;
    final String notificationToken;

    EnableNotificationRequestModel({
        required this.deviceType,
        required this.notificationToken,
    });

    factory EnableNotificationRequestModel.fromJson(Map<String, dynamic> json) => EnableNotificationRequestModel(
        deviceType: json["deviceType"],
        notificationToken: json["notificationToken"],
    );

    Map<String, dynamic> toJson() => {
        "deviceType": deviceType,
        "notificationToken": notificationToken,
    };
}
