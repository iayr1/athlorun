class TicketBookingRequestModel {
  List<TicketHolder>? tickets;
  double? amountPaid;
  int? coinsUsed;
  List<String>? couponsApplied;

  TicketBookingRequestModel(
      {this.tickets, this.amountPaid, this.coinsUsed, this.couponsApplied});

  factory TicketBookingRequestModel.fromJson(Map<String, dynamic> json) =>
      TicketBookingRequestModel(
        tickets: json["tickets"] == null
            ? []
            : List<TicketHolder>.from(
                json["tickets"]!.map((x) => TicketHolder.fromJson(x))),
        amountPaid: json["amountPaid"],
        coinsUsed: json["coinsUsed"],
        couponsApplied: json["couponsApplied"] == null
            ? []
            : List<String>.from(json["couponsApplied"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "tickets": tickets == null
            ? []
            : List<dynamic>.from(
                tickets!.map(
                  (x) => x.toJson(),
                ),
              ),
        "amountPaid": amountPaid,
        "coinsUsed": coinsUsed,
        "couponsApplied": couponsApplied == null
            ? []
            : List<dynamic>.from(couponsApplied!.map((x) => x)),
      };
}

class TicketHolder {
  String? name;
  int? age;
  String? gender;

  TicketHolder({
    required this.name,
    required this.age,
    required this.gender,
  });

  factory TicketHolder.fromJson(Map<String, dynamic> json) => TicketHolder(
        name: json["name"],
        age: json["age"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "age": age,
        "gender": gender!.toLowerCase(),
      };
}
