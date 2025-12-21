import '../entities/insight_rule.dart';

class GetContextualInsight {
  // Rules organized by usage time threshold
  // Ordered from lowest to highest time
  // The highest applicable rule is used
  static final List<InsightRule> _rules = [
    InsightRule(
      minMinutes: 15,
      insightText:
          'Brief app sessions can feel productive but often fragment focus. Single, intentional checks work better.',
      category: 'attention',
    ),
    InsightRule(
      minMinutes: 30,
      insightText:
          'Short, frequent interruptions reduce working memory for up to 25 minutes after each switch. Batching helps.',
      category: 'cognitive_load',
    ),
    InsightRule(
      minMinutes: 45,
      insightText:
          'After 45 minutes of scrolling, most users report declining mood satisfaction. Time to step away.',
      category: 'mood',
    ),
    InsightRule(
      minMinutes: 60,
      insightText:
          'Extended scrolling creates a familiarity loop: the more you see, the more you feel you\'re missing. A useful thing to notice.',
      category: 'emotional_regulation',
    ),
    InsightRule(
      minMinutes: 90,
      insightText:
          'At 90+ minutes, mental fatigue sets in. Continuing often reflects avoidance, not engagement. What are you avoiding?',
      category: 'self_awareness',
    ),
    InsightRule(
      minMinutes: 120,
      insightText:
          'Extended usage without breaks reduces sleep quality, mood stability, and next-day focus. Rest is productive.',
      category: 'wellbeing',
    ),
  ];

  /// Get the most relevant insight for the given usage time.
  /// Returns null if no threshold is met.
  InsightRule? call(int durationMinutes) {
    // Find the highest threshold that the user has met
    InsightRule? applicable;
    for (final rule in _rules) {
      if (durationMinutes >= rule.minMinutes) {
        applicable = rule;
      }
    }
    return applicable;
  }

  /// Get all available rules (for testing, debugging, or future features)
  List<InsightRule> getAllRules() => _rules;
}
