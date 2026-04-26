class PostUserParticipatedChallengesResponseModel {
  int? status;
  String? statusText;
  String? message;
  Data? data;

  PostUserParticipatedChallengesResponseModel({
    this.status,
    this.statusText,
    this.message,
    this.data,
  });

  factory PostUserParticipatedChallengesResponseModel.fromJson(
          Map<String, dynamic> json) =>
      PostUserParticipatedChallengesResponseModel(
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
  Challenge? challenge;
  User? user;
  DateTime? completedOn;
  String? id;
  String? progress;
  bool? isCompleted;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  Data({
    this.challenge,
    this.user,
    this.completedOn,
    this.id,
    this.progress,
    this.isCompleted,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        challenge: json["challenge"] == null
            ? null
            : Challenge.fromJson(json["challenge"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        completedOn: json["completedOn"],
        id: json["id"],
        progress: json["progress"],
        isCompleted: json["isCompleted"],
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
        "challenge": challenge?.toJson(),
        "user": user?.toJson(),
        "completedOn": completedOn,
        "id": id,
        "progress": progress,
        "isCompleted": isCompleted,
        "isActive": isActive,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedAt": deletedAt,
      };
}

class Challenge {
  String? id;
  String? title;
  DateTime? startDate;
  DateTime? endDate;
  List<QualifyingSport>? qualifyingSports;
  Author? author;

  Challenge({
    this.id,
    this.title,
    this.startDate,
    this.endDate,
    this.qualifyingSports,
    this.author,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
        id: json["id"],
        title: json["title"],
        startDate: json["startDate"] == null
            ? null
            : DateTime.parse(json["startDate"]),
        endDate:
            json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        qualifyingSports: json["qualifyingSports"] == null
            ? []
            : List<QualifyingSport>.from(json["qualifyingSports"]!
                .map((x) => QualifyingSport.fromJson(x))),
        author: json["author"] == null ? null : Author.fromJson(json["author"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "startDate":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "endDate":
            "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
        "qualifyingSports": qualifyingSports == null
            ? []
            : List<dynamic>.from(qualifyingSports!.map((x) => x.toJson())),
        "author": author?.toJson(),
      };
}

class Author {
  String? id;
  String? name;
  String? phoneNumber;
  String? email;
  String? companyName;
  String? companyLogo;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  Author({
    this.id,
    this.name,
    this.phoneNumber,
    this.email,
    this.companyName,
    this.companyLogo,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        companyName: json["companyName"],
        companyLogo: json["companyLogo"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phoneNumber": phoneNumber,
        "email": email,
        "companyName": companyName,
        "companyLogo": companyLogo,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedAt": deletedAt,
      };
}

class QualifyingSport {
  String? id;
  String? name;
  String? icon;

  QualifyingSport({
    this.id,
    this.name,
    this.icon,
  });

  factory QualifyingSport.fromJson(Map<String, dynamic> json) =>
      QualifyingSport(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "icon": icon,
      };
}

class User {
  String? id;
  String? name;
  String? phoneNumber;
  String? email;

  User({
    this.id,
    this.name,
    this.phoneNumber,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phoneNumber": phoneNumber,
        "email": email,
      };
}
