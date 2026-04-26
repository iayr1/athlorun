class UserDataResponseModel {
  final int? statusCode;
  final String? message;
  final UserData? data;

  UserDataResponseModel({
    this.statusCode,
    this.message,
    this.data,
  });

  factory UserDataResponseModel.fromJson(Map<String, dynamic> json) =>
      UserDataResponseModel(
        statusCode: json["statusCode"],
        message: json["message"],
        data: json["data"] == null ? null : UserData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "data": data?.toJson(),
      };
}

class UserData {
  final String? id;
  final dynamic name;
  final String? phoneNumber;
  final dynamic email;
  final String? height;
  final String? weight;
  final dynamic gender;
  final dynamic age;
  final dynamic target;
  final dynamic exerciseLevel;
  final dynamic activitiesCount;
  final dynamic profilePhoto;
  final dynamic reminder;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final Wallet? wallet;

  UserData(
      {this.id,
      this.name,
      this.phoneNumber,
      this.email,
      this.height,
      this.weight,
      this.gender,
      this.age,
      this.target,
      this.exerciseLevel,
      this.activitiesCount,
      this.profilePhoto,
      this.reminder,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.wallet});

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        height: json["height"],
        weight: json["weight"],
        gender: json["gender"],
        age: json["age"],
        target: json["target"],
        exerciseLevel: json["exerciseLevel"],
        activitiesCount: json["activitiesCount"],
        profilePhoto: json["profilePhoto"],
        reminder: json["reminder"],
        isActive: json["isActive"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"] == null
            ? null
            : DateTime.parse(json["deletedAt"]),
        wallet: json["wallet"] == null ? null : Wallet.fromJson(json["wallet"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phoneNumber": phoneNumber,
        "email": email,
        "height": height,
        "weight": weight,
        "gender": gender,
        "age": age,
        "target": target,
        "exerciseLevel": exerciseLevel,
        "activitiesCount": activitiesCount,
        "profilePhoto": profilePhoto,
        "reminder": reminder,
        "isActive": isActive,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedAt": deletedAt?.toIso8601String(),
        "wallet": wallet?.toJson()
      };
}

class Wallet {
  String? id;
  String? balance;
  String? totalCoinsEarned;
  String? totalCoinsUsed;

  Wallet({
    this.id,
    this.balance,
    this.totalCoinsEarned,
    this.totalCoinsUsed,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        id: json["id"],
        balance: json["balance"],
        totalCoinsEarned: json["totalCoinsEarned"],
        totalCoinsUsed: json["totalCoinsUsed"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "balance": balance,
        "totalCoinsEarned": totalCoinsEarned,
        "totalCoinsUsed": totalCoinsUsed,
      };
}
