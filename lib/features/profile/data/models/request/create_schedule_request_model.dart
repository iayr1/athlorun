class CreateScheduleRequestModel {
  final String? scheduleName;
  final String? sportId;
  final String? scheduleAt;
  final bool? isCompleted;

  CreateScheduleRequestModel(
      {this.scheduleName, this.sportId, this.scheduleAt, this.isCompleted});

  factory CreateScheduleRequestModel.fromJson(Map<String, dynamic> json) =>
      CreateScheduleRequestModel(
          scheduleName: json["name"],
          sportId: json["sportId"],
          scheduleAt: json["scheduledAt"],
          isCompleted: json["isCompleted"]);

  Map<String, dynamic> toJson() => {
        if (scheduleName != null) "name": scheduleName,
        if (sportId != null) "sportId": sportId,
        if (scheduleAt != null) "scheduledAt": scheduleAt,
        if (isCompleted != null) "isCompleted": isCompleted
      };
}
