class GetParticipatedChallengesResponseModel {
  int? status;
  String? statusText;
  String? message;
  Data? data;

  GetParticipatedChallengesResponseModel({
    this.status,
    this.statusText,
    this.message,
    this.data,
  });

  factory GetParticipatedChallengesResponseModel.fromJson(
          Map<String, dynamic> json) =>
      GetParticipatedChallengesResponseModel(
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
  String? id;
  String? progress;
  String? coinsEarned;
  bool? isCompleted;
  dynamic completedOn;
  Challenge? challenge;

  Data({
    this.id,
    this.progress,
    this.coinsEarned,
    this.isCompleted,
    this.completedOn,
    this.challenge,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        progress: json["progress"],
        coinsEarned: json["coinsEarned"],
        isCompleted: json["isCompleted"],
        completedOn: json["completedOn"],
        challenge: json["challenge"] == null
            ? null
            : Challenge.fromJson(json["challenge"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "progress": progress,
        "coinsEarned": coinsEarned,
        "isCompleted": isCompleted,
        "completedOn": completedOn,
        "challenge": challenge?.toJson(),
      };
}

class Challenge {
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
  DateTime? createdAt;
  DateTime? updatedAt;
  List<QualifyingSport>? qualifyingSports;
  Author? author;
  List<Participant>? participants;
  String? participantsCount;

  Challenge({
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
    this.createdAt,
    this.updatedAt,
    this.qualifyingSports,
    this.author,
    this.participants,
    this.participantsCount,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
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
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        qualifyingSports: json["qualifyingSports"] == null
            ? []
            : List<QualifyingSport>.from(json["qualifyingSports"]!
                .map((x) => QualifyingSport.fromJson(x))),
        author: json["author"] == null ? null : Author.fromJson(json["author"]),
        participants: json["participants"] == null
            ? []
            : List<Participant>.from(
                json["participants"]!.map((x) => Participant.fromJson(x))),
        participantsCount: json["participantsCount"],
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
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "qualifyingSports": qualifyingSports == null
            ? []
            : List<dynamic>.from(qualifyingSports!.map((x) => x.toJson())),
        "author": author?.toJson(),
        "participants": participants == null
            ? []
            : List<dynamic>.from(participants!.map((x) => x.toJson())),
        "participantsCount": participantsCount,
      };
}

class Author {
  String? id;
  dynamic name;
  String? phoneNumber;
  dynamic email;
  dynamic companyName;
  dynamic companyLogo;

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
