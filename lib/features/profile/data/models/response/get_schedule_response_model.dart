class GetScheduleResponseModel {
  final int? status;
  final String? statusText;
  final String? message;
  final List<GetScheduleResponseModelData>? data;

  GetScheduleResponseModel(
      {this.status, this.statusText, this.message, this.data});

  factory GetScheduleResponseModel.fromJson(Map<String, dynamic> json) =>
      GetScheduleResponseModel(
          status: json["status"],
          statusText: json["statusText"],
          message: json["message"],
          data: json["data"] == null
              ? []
              : List<GetScheduleResponseModelData>.from(json["data"]!
                  .map((data) => GetScheduleResponseModelData.fromJson(data))));
}

class GetScheduleResponseModelData {
  final String? id;
  final String? name;
  final String? scheduleAt;
  final bool? isCompleted;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final SportData? sport;

  GetScheduleResponseModelData(
      {this.id,
      this.name,
      this.scheduleAt,
      this.isCompleted,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.sport});

  factory GetScheduleResponseModelData.fromJson(Map<String, dynamic> json) =>
      GetScheduleResponseModelData(
        id: json["id"],
        name: json["name"],
        scheduleAt: json["scheduledAt"],
        isCompleted: json["isCompleted"],
        isActive: json["isActive"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        deletedAt: json["deletedAt"],
        sport: json["sport"] == null ? null : SportData.fromJson(json["sport"]),
      );
}

class SportData {
  final String? id;
  final String? name;
  final String? icon;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  SportData(
      {this.id,
      this.name,
      this.icon,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  factory SportData.fromJson(Map<String, dynamic> json) => SportData(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
        isActive: json["isActive"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        deletedAt: json["deletedAt"],
      );
}
