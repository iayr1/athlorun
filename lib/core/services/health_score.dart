import 'cloud_sync.dart';

/// Rule-based health score (1–99) from the onboarding assessment, with the
/// suggestions and flags ("anomalies") behind it.
class HealthScore {
  final int score;
  final List<String> suggestions;
  final List<String> anomalies;

  const HealthScore({
    required this.score,
    required this.suggestions,
    required this.anomalies,
  });

  /// Scores at or above this are shown on blue, below on red.
  static const goodThreshold = 50;

  bool get isGood => score >= goodThreshold;

  factory HealthScore.from(HealthAssessment a) {
    var score = 60.0;
    final suggestions = <String>[];
    final anomalies = <String>[];

    final fitness = a.fitnessLevel ?? 3;
    score += (fitness - 3) * 8;
    if (fitness <= 2) {
      anomalies.add('Low activity level');
      suggestions
        ..add('Start with a 20-minute walk every day')
        ..add('Add two short strength sessions a week');
    } else if (fitness >= 4) {
      suggestions.add('Schedule a recovery day each week');
    } else {
      suggestions.add('Add one interval run a week to build stamina');
    }

    final sleep = a.sleepLevel ?? 3;
    score += (sleep - 3) * 8;
    if (sleep <= 2) {
      anomalies.add('Not enough sleep');
      suggestions
        ..add('Keep a fixed bedtime, even on weekends')
        ..add('Avoid screens for 30 minutes before bed');
    } else if (sleep == 3) {
      suggestions.add('Aim for 7–8 hours of sleep');
    }

    switch (a.mood) {
      case 'Sad':
        score -= 10;
        anomalies.add('Low mood');
        suggestions.add('Talk to someone you trust about how you feel');
      case 'Down':
        score -= 5;
        suggestions.add('Get outside for some daylight and movement');
      case 'Happy':
        score += 4;
      case 'Overjoyed':
        score += 6;
    }

    switch (a.eatingHabit) {
      case 'Balanced Diet':
        score += 6;
      case 'Mostly Vegetarian':
        score += 4;
        suggestions.add('Check your protein, iron and B12 intake');
      case 'Low Carb':
        score += 2;
        suggestions.add('Fuel long runs with enough carbohydrates');
      case 'Gluten Free':
        score += 2;
        suggestions.add('Choose whole-grain gluten-free options for fibre');
      case null:
        suggestions.add('Track your meals for a week to spot habits');
    }

    if (a.symptoms.isNotEmpty) {
      score -= (a.symptoms.length * 3).clamp(0, 15);
      anomalies.addAll(a.symptoms.map((s) => 'Reported: $s'));
      suggestions.add('Mention your symptoms to a doctor if they persist');
    }
    if (a.medications.isNotEmpty) {
      score -= a.medications.length.clamp(0, 5);
      suggestions.add('Turn on medication reminders');
    }
    if (a.weightKg == null) {
      suggestions.add('Log your weight to track progress');
    }
    suggestions.add('Drink water regularly through the day');

    return HealthScore(
      score: score.round().clamp(1, 99),
      suggestions: suggestions,
      anomalies: anomalies,
    );
  }
}
