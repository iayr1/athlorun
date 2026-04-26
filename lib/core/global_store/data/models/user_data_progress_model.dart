class UserDataProgressModel {
  String? name;
  String? phoneNumber;
  String? email;
  int? height;
  int? weight;
  String? gender;
  int? age;
  String? target;
  String? exerciseLevel;
  int? activitiesCount;
  String? profilePhoto;
  //  String? reminder;

  UserDataProgressModel({
    this.name,
    this.phoneNumber,
    this.email,
    this.height,
    this.weight,
    this.gender,
    this.age,
    this.target,
    this.exerciseLevel,
    this.activitiesCount,
    this.profilePhoto,
    // this.reminder,
  });

  factory UserDataProgressModel.fromJson(Map<String, dynamic> json) =>
      UserDataProgressModel(
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        height: json["height"],
        weight: json["weight"],
        gender: json["gender"],
        age: json["age"],
        target: json["target"],
        exerciseLevel: json["exerciseLevel"],
        activitiesCount: json["activitiesCount"],
        profilePhoto: json["profilePhoto"],
        // reminder: json["reminder"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phoneNumber": phoneNumber,
        "email": email,
        "height": height,
        "weight": weight,
        "gender": gender,
        "age": age,
        "target": target,
        "exerciseLevel": exerciseLevel,
        "activitiesCount": activitiesCount,
        "profilePhoto": profilePhoto,
        // "reminder": reminder,
      };
}
