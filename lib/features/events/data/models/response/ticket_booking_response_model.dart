class TicketBookingResponseModel {
  int? status;
  String? statusText;
  String? message;
  Data? data;

  TicketBookingResponseModel({
    this.status,
    this.statusText,
    this.message,
    this.data,
  });

  factory TicketBookingResponseModel.fromJson(Map<String, dynamic> json) =>
      TicketBookingResponseModel(
        status: json["status"],
        statusText: json["statusText"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusText": statusText,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  TicketSlot? slot;
  User? user;
  Payment? payment;
  dynamic qrCode;
  String? id;
  String? participationStatus;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  List<Ticket>? tickets;

  Data({
    this.slot,
    this.user,
    this.payment,
    this.qrCode,
    this.id,
    this.participationStatus,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.tickets,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        slot: json["slot"] == null ? null : TicketSlot.fromJson(json["slot"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        payment:
            json["payment"] == null ? null : Payment.fromJson(json["payment"]),
        qrCode: json["qrCode"],
        id: json["id"],
        participationStatus: json["participationStatus"],
        isActive: json["isActive"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
        tickets: json["tickets"] == null
            ? []
            : List<Ticket>.from(
                json["tickets"]!.map((x) => Ticket.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "slot": slot?.toJson(),
        "user": user?.toJson(),
        "payment": payment?.toJson(),
        "qrCode": qrCode,
        "id": id,
        "participationStatus": participationStatus,
        "isActive": isActive,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedAt": deletedAt,
        "tickets": tickets == null
            ? []
            : List<dynamic>.from(tickets!.map((x) => x.toJson())),
      };
}

class Payment {
  String? id;
  String? coinsUsed;
  int? amountPaid;
  String? orderId;
  String? orderStatus;
  String? paymentSessionId;
  dynamic paymentMode;
  User? payer;

  Payment({
    this.id,
    this.coinsUsed,
    this.amountPaid,
    this.orderId,
    this.orderStatus,
    this.paymentSessionId,
    this.paymentMode,
    this.payer,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        coinsUsed: json["coinsUsed"],
        amountPaid: json["amountPaid"],
        orderId: json["orderId"],
        orderStatus: json["orderStatus"],
        paymentSessionId: json["paymentSessionId"],
        paymentMode: json["paymentMode"],
        payer: json["payer"] == null ? null : User.fromJson(json["payer"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "coinsUsed": coinsUsed,
        "amountPaid": amountPaid,
        "orderId": orderId,
        "orderStatus": orderStatus,
        "paymentSessionId": paymentSessionId,
        "paymentMode": paymentMode,
        "payer": payer?.toJson(),
      };
}

class User {
  String? id;
  String? name;
  String? phoneNumber;
  String? email;

  User({
    this.id,
    this.name,
    this.phoneNumber,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phoneNumber": phoneNumber,
        "email": email,
      };
}

class TicketSlot {
  String? id;
  String? startTime;
  String? endTime;
  int? capacity;
  int? bookedCount;

  TicketSlot({
    this.id,
    this.startTime,
    this.endTime,
    this.capacity,
    this.bookedCount,
  });

  factory TicketSlot.fromJson(Map<String, dynamic> json) => TicketSlot(
        id: json["id"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        capacity: json["capacity"],
        bookedCount: json["bookedCount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "startTime": startTime,
        "endTime": endTime,
        "capacity": capacity,
        "bookedCount": bookedCount,
      };
}

class Ticket {
  String? id;
  String? name;
  int? age;
  String? gender;

  Ticket({
    this.id,
    this.name,
    this.age,
    this.gender,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        id: json["id"],
        name: json["name"],
        age: json["age"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "age": age,
        "gender": gender,
      };
}
