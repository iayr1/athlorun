class GetEventsResponseModel {
  int? status;
  String? statusText;
  String? message;
  List<GetEventsResponseModelData>? data;

  GetEventsResponseModel({
    this.status,
    this.statusText,
    this.message,
    this.data,
  });

  factory GetEventsResponseModel.fromJson(Map<String, dynamic> json) =>
      GetEventsResponseModel(
        status: json["status"],
        statusText: json["statusText"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<GetEventsResponseModelData>.from(json["data"]!
                .map((x) => GetEventsResponseModelData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusText": statusText,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class GetEventsResponseModelData {
  String? id;
  String? banner;
  String? title;
  String? description;
  DateTime? date;
  String? startTime;
  String? endTime;
  String? participation;
  String? obstacles;
  String? enduranceLevel;
  String? price;
  String? coinsDiscountPercentage;
  int? maxTicketsPerUser;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  Location? location;
  List<Coupon>? coupons;
  List<Slot>? slots;

  GetEventsResponseModelData({
    this.id,
    this.banner,
    this.title,
    this.description,
    this.date,
    this.startTime,
    this.endTime,
    this.participation,
    this.obstacles,
    this.enduranceLevel,
    this.price,
    this.coinsDiscountPercentage,
    this.maxTicketsPerUser,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.location,
    this.coupons,
    this.slots,
  });

  factory GetEventsResponseModelData.fromJson(Map<String, dynamic> json) =>
      GetEventsResponseModelData(
        id: json["id"],
        banner: json["banner"],
        title: json["title"],
        description: json["description"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        startTime: json["startTime"],
        endTime: json["endTime"],
        participation: json["participation"],
        obstacles: json["obstacles"],
        enduranceLevel: json["enduranceLevel"],
        price: json["price"],
        coinsDiscountPercentage: json["coinsDiscountPercentage"],
        maxTicketsPerUser: json["maxTicketsPerUser"],
        isActive: json["isActive"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        coupons: json["coupons"] == null
            ? []
            : List<Coupon>.from(
                json["coupons"]!.map((x) => Coupon.fromJson(x))),
        slots: json["slots"] == null
            ? []
            : List<Slot>.from(json["slots"]!.map((x) => Slot.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "banner": banner,
        "title": title,
        "description": description,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "startTime": startTime,
        "endTime": endTime,
        "participation": participation,
        "obstacles": obstacles,
        "enduranceLevel": enduranceLevel,
        "price": price,
        "coinsDiscountPercentage": coinsDiscountPercentage,
        "maxTicketsPerUser": maxTicketsPerUser,
        "isActive": isActive,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedAt": deletedAt,
        "location": location?.toJson(),
        "coupons": coupons == null
            ? []
            : List<dynamic>.from(coupons!.map((x) => x.toJson())),
        "slots": slots == null
            ? []
            : List<dynamic>.from(slots!.map((x) => x.toJson())),
      };
}

class Coupon {
  String? id;
  String? code;
  String? description;
  String? discountType;
  String? discountValue;
  dynamic maxDiscountValue;
  String? minimumPurchase;
  List<String>? applicableCategories;
  DateTime? startDate;
  DateTime? endDate;
  int? usageLimit;
  int? usageLimitPerUser;
  int? usageCount;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  Coupon({
    this.id,
    this.code,
    this.description,
    this.discountType,
    this.discountValue,
    this.maxDiscountValue,
    this.minimumPurchase,
    this.applicableCategories,
    this.startDate,
    this.endDate,
    this.usageLimit,
    this.usageLimitPerUser,
    this.usageCount,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        id: json["id"],
        code: json["code"],
        description: json["description"] ?? "",
        discountType: json["discountType"],
        discountValue: json["discountValue"],
        maxDiscountValue: json["maxDiscountValue"] ?? "",
        minimumPurchase: json["minimumPurchase"] ?? "",
        applicableCategories: json["applicableCategories"] == null
            ? []
            : List<String>.from(json["applicableCategories"]!.map((x) => x)),
        startDate: json["startDate"] == null
            ? null
            : DateTime.parse(json["startDate"]),
        endDate:
            json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        usageLimit: json["usageLimit"],
        usageLimitPerUser: json["usageLimitPerUser"],
        usageCount: json["usageCount"],
        isActive: json["isActive"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "description": description,
        "discountType": discountType,
        "discountValue": discountValue,
        "maxDiscountValue": maxDiscountValue,
        "minimumPurchase": minimumPurchase,
        "applicableCategories": applicableCategories == null
            ? []
            : List<dynamic>.from(applicableCategories!.map((x) => x)),
        "startDate":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "endDate":
            "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
        "usageLimit": usageLimit,
        "usageLimitPerUser": usageLimitPerUser,
        "usageCount": usageCount,
        "isActive": isActive,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedAt": deletedAt,
      };
}

class Location {
  String? id;
  String? address;
  Coordinate? coordinate;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  Location({
    this.id,
    this.address,
    this.coordinate,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json["id"],
        address: json["address"],
        coordinate: json["coordinate"] == null
            ? null
            : Coordinate.fromJson(json["coordinate"]),
        isActive: json["isActive"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "coordinate": coordinate?.toJson(),
        "isActive": isActive,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedAt": deletedAt,
      };
}

class Coordinate {
  String? type;
  List<double>? coordinates;

  Coordinate({
    this.type,
    this.coordinates,
  });

  factory Coordinate.fromJson(Map<String, dynamic> json) => Coordinate(
        type: json["type"],
        coordinates: json["coordinates"] == null
            ? []
            : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => x)),
      };
}

class Slot {
  String? id;
  String? startTime;
  String? endTime;
  int? capacity;
  int? bookedCount;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  Slot({
    this.id,
    this.startTime,
    this.endTime,
    this.capacity,
    this.bookedCount,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        id: json["id"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        capacity: json["capacity"],
        bookedCount: json["bookedCount"],
        isActive: json["isActive"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "startTime": startTime,
        "endTime": endTime,
        "capacity": capacity,
        "bookedCount": bookedCount,
        "isActive": isActive,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedAt": deletedAt,
      };
}
