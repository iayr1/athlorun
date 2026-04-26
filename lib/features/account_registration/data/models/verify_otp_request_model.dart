class VerifyOtpRequestModel {
  final String? phoneNumber;
  final String? role;
  final String? otp;

  VerifyOtpRequestModel( {
    this.phoneNumber,
    this.otp,
    this.role = "user"
  });

  factory VerifyOtpRequestModel.fromJson(Map<String, dynamic> json) =>
      VerifyOtpRequestModel(
        phoneNumber: json["phoneNumber"],
        otp: json["otp"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "phoneNumber": phoneNumber,
        "otp": otp,
        "role": role, 
      };
}
