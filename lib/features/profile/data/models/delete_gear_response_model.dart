class DeleteGearResponseModel {
  final int? status;
  final String? statusText;
  final String? message;
  final dynamic data;

  DeleteGearResponseModel(
      {this.status, this.statusText, this.message, this.data});

  factory DeleteGearResponseModel.fromJson(Map<String, dynamic> json) =>
      DeleteGearResponseModel(
        status: json["status"],
        statusText: json["statusText"],
        message: json["message"],
        data: json["data"],
      );
}
