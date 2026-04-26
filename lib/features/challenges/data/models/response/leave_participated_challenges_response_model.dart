class LeaveParticipatedChallengesResponseModel {
  int? status;
  String? statusText;
  String? message;
  dynamic data;

  LeaveParticipatedChallengesResponseModel({
    this.status,
    this.statusText,
    this.message,
    this.data,
  });

  factory LeaveParticipatedChallengesResponseModel.fromJson(
          Map<String, dynamic> json) =>
      LeaveParticipatedChallengesResponseModel(
        status: json["status"],
        statusText: json["statusText"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusText": statusText,
        "message": message,
        "data": data,
      };
}
