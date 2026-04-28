class StepResponseModel {
  final String? id;
  final int steps;
  final DateTime? recordedAt;

  const StepResponseModel({
    this.id,
    required this.steps,
    this.recordedAt,
  });

  factory StepResponseModel.fromJson(Map<String, dynamic> json) {
    return StepResponseModel(
      id: json['id']?.toString(),
      steps: (json['steps'] as num?)?.toInt() ?? 0,
      recordedAt: json['recorded_at'] == null
          ? null
          : DateTime.tryParse(json['recorded_at'].toString()),
    );
  }
}
