class DeleteScheduleResponseModel {
  final int? status;
  final String? statusText;
  final String? message;
  final dynamic data;

  DeleteScheduleResponseModel(
      {this.status, this.statusText, this.message, this.data});

  factory DeleteScheduleResponseModel.fromJson(Map<String, dynamic> json) =>
      DeleteScheduleResponseModel(
        status: json["status"],
        statusText: json["statusText"],
        message: json["message"],
        data: json["data"],
      );
}
