class SendOtpResponseModel {
    final int? statusCode;
    final String? message;
    final Data? data;

    SendOtpResponseModel({
        this.statusCode,
        this.message,
        this.data,
    });

    factory SendOtpResponseModel.fromJson(Map<String, dynamic> json) => SendOtpResponseModel(
        statusCode: json["statusCode"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    final bool? flash;
    final String? message;

    Data({
        this.flash,
        this.message,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        flash: json["flash"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "flash": flash,
        "message": message,
    };
}
