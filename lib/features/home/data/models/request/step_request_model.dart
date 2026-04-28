class StepRequestModel {
  final int steps;
  final DateTime? recordedAt;

  const StepRequestModel({
    required this.steps,
    this.recordedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'steps': steps,
      if (recordedAt != null) 'recorded_at': recordedAt!.toIso8601String(),
    };
  }
}
