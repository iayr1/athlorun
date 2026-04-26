class GetGearResponseModel {
  final int? status;
  final String? statusText;
  final String? message;
  final List<GetGearResponseModelData>? data;

  GetGearResponseModel({this.status, this.statusText, this.message, this.data});

  factory GetGearResponseModel.fromJson(Map<String, dynamic> json) =>
      GetGearResponseModel(
        status: json["status"],
        statusText: json["statusText"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<GetGearResponseModelData>.from(json["data"]!.map((data) => GetGearResponseModelData.fromJson(data))),
      );
}

class GetGearResponseModelData {
  final String? id;
  final String? brand;
  final String? model;
  final String? weight;
  final String? photo;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final GearType? type;
  final SportGear? sport;

  GetGearResponseModelData(
      {this.id,
      this.brand,
      this.model,
      this.weight,
      this.photo,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.type,
      this.sport});

  factory GetGearResponseModelData.fromJson(Map<String, dynamic> json) => GetGearResponseModelData(
        id: json["id"],
        brand: json["brand"],
        model: json["model"],
        weight: json["weight"],
        photo: json["photo"],
        isActive: json["isActive"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        deletedAt: json["deletedAt"],
        type: json["type"] == null ? null : GearType.fromJson(json["type"]),
        sport: json["sport"] == null ? null : SportGear.fromJson(json["sport"]),
      );
}

class GearType {
  final String? id;
  final String? name;
  final String? icon;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  GearType(
      {this.id,
      this.name,
      this.icon,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  factory GearType.fromJson(Map<String, dynamic> json) => GearType(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
        isActive: json["isActive"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        deletedAt: json["deletedAt"],
      );
}

class SportGear {
  final String? id;
  final String? name;
  final String? icon;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  SportGear(
      {this.id,
      this.name,
      this.icon,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  factory SportGear.fromJson(Map<String, dynamic> json) => SportGear(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
        isActive: json["isActive"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        deletedAt: json["deletedAt"],
      );
}
