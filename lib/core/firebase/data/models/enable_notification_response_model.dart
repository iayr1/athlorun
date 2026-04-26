class EnableNotificationResponseModel {
    final int status;
    final String statusText;
    final String message;
    final Data data;

    EnableNotificationResponseModel({
        required this.status,
        required this.statusText,
        required this.message,
        required this.data,
    });

    factory EnableNotificationResponseModel.fromJson(Map<String, dynamic> json) => EnableNotificationResponseModel(
        status: json["status"],
        statusText: json["statusText"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "statusText": statusText,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    final String userId;
    final String deviceType;
    final String notificationToken;
    final String status;
    final String id;
    final DateTime createdAt;
    final DateTime updatedAt;
    final dynamic deletedAt;

    Data({
        required this.userId,
        required this.deviceType,
        required this.notificationToken,
        required this.status,
        required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["userId"],
        deviceType: json["deviceType"],
        notificationToken: json["notificationToken"],
        status: json["status"],
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "deviceType": deviceType,
        "notificationToken": notificationToken,
        "status": status,
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "deletedAt": deletedAt,
    };
}
