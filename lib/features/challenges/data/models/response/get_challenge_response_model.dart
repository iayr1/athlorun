class GetChallengeResponseDataModel {
  final String id;
  final String title;
  final String description;
  final int progress;
  final int target;

  const GetChallengeResponseDataModel({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
    required this.target,
  });

  double get completionRatio => target <= 0 ? 0 : progress / target;
}
