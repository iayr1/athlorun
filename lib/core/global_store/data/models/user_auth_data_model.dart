class UserAuthDataModel {
  String accessToken;
  String refreshToken;
  String id;

  UserAuthDataModel({
    required this.accessToken,
    required this.refreshToken,
    required this.id,
  });

  factory UserAuthDataModel.fromJson(Map<String, dynamic> json) =>
      UserAuthDataModel(
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "refreshToken": refreshToken,
        "id": id,
      };
}
