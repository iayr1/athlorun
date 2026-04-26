class UpdateUserProfileRequestModel {
  final dynamic name;
  final dynamic email;
  final String? height;
  final String? weight;
  final dynamic age;
  final dynamic target;
  final dynamic exerciseLevel;

  UpdateUserProfileRequestModel({
    this.name,
    this.email,
    this.height,
    this.weight,
    this.age,
    this.target,
    this.exerciseLevel,
  });

  factory UpdateUserProfileRequestModel.fromJson(Map<String, dynamic> json) =>
      UpdateUserProfileRequestModel(
        name: json["name"],
        email: json["email"],
        height: json["height"],
        weight: json["weight"],
        age: json["age"],
        target: json["target"],
        exerciseLevel: json["exerciseLevel"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "height": height,
        "weight": weight,
        "age": age,
        "target": target,
        "exerciseLevel": exerciseLevel,
      };
}
