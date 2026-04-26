class DeleteUserResponseModel {
  int? statusCode;
  String? message;

  DeleteUserResponseModel({this.statusCode, this.message});

  DeleteUserResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    return data;
  }
}
