class InsightRule {
  final int minMinutes;
  final String insightText;
  final String category; // To avoid showing same category too often

  const InsightRule({
    required this.minMinutes,
    required this.insightText,
    required this.category,
  });
}
