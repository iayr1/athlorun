class SendOtpRequestModel {
    final String phoneNumber;

    SendOtpRequestModel({
        required this.phoneNumber,
    });

    factory SendOtpRequestModel.fromJson(Map<String, dynamic> json) => SendOtpRequestModel(
        phoneNumber: json["phoneNumber"],
    );

    Map<String, dynamic> toJson() => {
        "phoneNumber": phoneNumber,
    };
}
