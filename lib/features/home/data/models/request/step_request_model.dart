class StepRequestModel {
  int? count;
  String? source;
  String? date;

  StepRequestModel({
    this.count,
    this.source,
    this.date,
  });

  factory StepRequestModel.fromJson(Map<String, dynamic> json) =>
      StepRequestModel(
        count: json["count"],
        source: json["source"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "source": source,
        "date": date,
      };
}
