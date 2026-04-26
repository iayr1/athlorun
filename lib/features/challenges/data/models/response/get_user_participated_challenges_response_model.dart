class GetUserParticipatedChallengesResponseModel {
  int? status;
  String? statusText;
  String? message;
  Data? data;

  GetUserParticipatedChallengesResponseModel({
    this.status,
    this.statusText,
    this.message,
    this.data,
  });

  factory GetUserParticipatedChallengesResponseModel.fromJson(
          Map<String, dynamic> json) =>
      GetUserParticipatedChallengesResponseModel(
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
  List<ChallengeElement>? challenges;
  int? challengesCount;

  Data({
    this.challenges,
    this.challengesCount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        challenges: json["participatedChallenges"] == null
            ? []
            : List<ChallengeElement>.from(json["participatedChallenges"]!
                .map((x) => ChallengeElement.fromJson(x))),
        challengesCount: json["participatedChallengesCount"],
      );

  Map<String, dynamic> toJson() => {
        "participatedChallenges": challenges == null
            ? []
            : List<dynamic>.from(challenges!.map((x) => x.toJson())),
        "participatedChallengesCount": challengesCount,
      };
}

class ChallengeElement {
  String? id;
  bool? isCompleted;
  String? completedOn;
  ChallengeChallenge? challenge;

  ChallengeElement({
    this.id,
    this.isCompleted,
    this.completedOn,
    this.challenge,
  });

  factory ChallengeElement.fromJson(Map<String, dynamic> json) =>
      ChallengeElement(
        id: json["id"],
        isCompleted: json["isCompleted"],
        completedOn: json["completedOn"],
        challenge: json["challenge"] == null
            ? null
            : ChallengeChallenge.fromJson(json["challenge"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "isCompleted": isCompleted,
        "completedOn": completedOn,
        "challenge": challenge?.toJson(),
      };
}

class ChallengeChallenge {
  String? id;
  String? title;
  String? badge;
  DateTime? startDate;
  DateTime? endDate;
  int? targetValue;
  String? targetUnit;

  ChallengeChallenge({
    this.id,
    this.title,
    this.badge,
    this.startDate,
    this.endDate,
    this.targetValue,
    this.targetUnit,
  });

  factory ChallengeChallenge.fromJson(Map<String, dynamic> json) =>
      ChallengeChallenge(
        id: json["id"],
        title: json["title"],
        badge: json["badge"],
        startDate: json["startDate"] == null
            ? null
            : DateTime.parse(json["startDate"]),
        endDate:
            json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        targetValue: json["targetValue"],
        targetUnit: json["targetUnit"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "badge": badge,
        "startDate":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "endDate":
            "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
        "targetValue": targetValue,
        "targetUnit": targetUnit,
      };
}
