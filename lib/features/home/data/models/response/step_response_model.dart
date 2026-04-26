class StepResponseModel {
  int? status;
  String? statusText;
  String? message;
  Data? data;

  StepResponseModel({
    this.status,
    this.statusText,
    this.message,
    this.data,
  });

  factory StepResponseModel.fromJson(Map<String, dynamic> json) =>
      StepResponseModel(
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
  int? count;
  String? source;
  double? coinsEarned;
  double? distanceInMeter;
  double? caloriesInCal;
  DateTime? date;
  User? user;
  String? id;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  Data({
    this.count,
    this.source,
    this.coinsEarned,
    this.distanceInMeter,
    this.caloriesInCal,
    this.date,
    this.user,
    this.id,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        count: json["count"],
        source: json["source"],
        coinsEarned: json["coinsEarned"]?.toDouble(),
        distanceInMeter: json["distanceInMeter"]?.toDouble(),
        caloriesInCal: json["caloriesInCal"]?.toDouble(),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        id: json["id"],
        isActive: json["isActive"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "source": source,
        "coinsEarned": coinsEarned,
        "distanceInMeter": distanceInMeter,
        "caloriesInCal": caloriesInCal,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "user": user?.toJson(),
        "id": id,
        "isActive": isActive,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedAt": deletedAt,
      };
}

class User {
  String? id;
  String? name;

  User({
    this.id,
    this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
