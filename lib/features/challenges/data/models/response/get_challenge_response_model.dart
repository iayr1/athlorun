class GetChallengeResponseModel {
  int? status;
  String? statusText;
  String? message;
  List<GetChallengeResponseDataModel>? data;

  GetChallengeResponseModel({
    this.status,
    this.statusText,
    this.message,
    this.data,
  });

  factory GetChallengeResponseModel.fromJson(Map<String, dynamic> json) =>
      GetChallengeResponseModel(
        status: json["status"],
        statusText: json["statusText"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<GetChallengeResponseDataModel>.from(json["data"]!
                .map((x) => GetChallengeResponseDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusText": statusText,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class GetChallengeResponseDataModel {
  String? id;
  String? title;
  String? banner;
  String? badge;
  DateTime? startDate;
  DateTime? endDate;
  int? targetValue;
  String? targetUnit;
  String? targetDescription;
  int? rewardCoinsInterval;
  int? rewardCoinsPerInterval;
  int? rewardCoinsMultiplier;
  String? maxRewardCoins;
  String? reward;
  String? description;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  Author? author;
  List<QualifyingSport>? qualifyingSports;
  List<Participant>? participants;
  dynamic participantsCount;
  bool? isParticipated;

  GetChallengeResponseDataModel({
    this.id,
    this.title,
    this.banner,
    this.badge,
    this.startDate,
    this.endDate,
    this.targetValue,
    this.targetUnit,
    this.targetDescription,
    this.rewardCoinsInterval,
    this.rewardCoinsPerInterval,
    this.rewardCoinsMultiplier,
    this.maxRewardCoins,
    this.reward,
    this.description,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.author,
    this.qualifyingSports,
    this.participants,
    this.participantsCount,
    this.isParticipated,
  });

  factory GetChallengeResponseDataModel.fromJson(Map<String, dynamic> json) =>
      GetChallengeResponseDataModel(
        id: json["id"],
        title: json["title"],
        banner: json["banner"],
        badge: json["badge"],
        startDate: json["startDate"] == null
            ? null
            : DateTime.parse(json["startDate"]),
        endDate:
            json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        targetValue: json["targetValue"],
        targetUnit: json["targetUnit"],
        targetDescription: json["targetDescription"],
        rewardCoinsInterval: json["rewardCoinsInterval"],
        rewardCoinsPerInterval: json["rewardCoinsPerInterval"],
        rewardCoinsMultiplier: json["rewardCoinsMultiplier"],
        maxRewardCoins: json["maxRewardCoins"],
        reward: json["reward"],
        description: json["description"],
        isActive: json["isActive"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
        author: json["author"] == null ? null : Author.fromJson(json["author"]),
        qualifyingSports: json["qualifyingSports"] == null
            ? []
            : List<QualifyingSport>.from(json["qualifyingSports"]!
                .map((x) => QualifyingSport.fromJson(x))),
        participants: json["participants"] == null
            ? []
            : List<Participant>.from(
                json["participants"]!.map((x) => Participant.fromJson(x))),
        participantsCount: json["participantsCount"],
        isParticipated: json["isParticipated"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "banner": banner,
        "badge": badge,
        "startDate":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "endDate":
            "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
        "targetValue": targetValue,
        "targetUnit": targetUnit,
        "targetDescription": targetDescription,
        "rewardCoinsInterval": rewardCoinsInterval,
        "rewardCoinsPerInterval": rewardCoinsPerInterval,
        "rewardCoinsMultiplier": rewardCoinsMultiplier,
        "maxRewardCoins": maxRewardCoins,
        "reward": reward,
        "description": description,
        "isActive": isActive,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedAt": deletedAt,
        "author": author?.toJson(),
        "qualifyingSports": qualifyingSports == null
            ? []
            : List<dynamic>.from(qualifyingSports!.map((x) => x.toJson())),
        "participants": participants == null
            ? []
            : List<dynamic>.from(participants!.map((x) => x.toJson())),
        "participantsCount": participantsCount,
        "isParticipated": isParticipated,
      };
}

class Author {
  String? id;
  String? name;
  String? phoneNumber;
  String? email;
  String? companyName;
  String? companyLogo;

  Author({
    this.id,
    this.name,
    this.phoneNumber,
    this.email,
    this.companyName,
    this.companyLogo,
  });

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        companyName: json["companyName"],
        companyLogo: json["companyLogo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phoneNumber": phoneNumber,
        "email": email,
        "companyName": companyName,
        "companyLogo": companyLogo,
      };
}

class Participant {
  String? participationId;
  String? participantId;
  String? participantName;

  Participant({
    this.participationId,
    this.participantId,
    this.participantName,
  });

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
        participationId: json["participationId"],
        participantId: json["participantId"],
        participantName: json["participantName"],
      );

  Map<String, dynamic> toJson() => {
        "participationId": participationId,
        "participantId": participantId,
        "participantName": participantName,
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
