class ErrorResponse {
  int? status;
  String? statusText;
  String? message;
  dynamic data;

  ErrorResponse({
    this.status,
    this.statusText,
    this.message,
    this.data,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
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
