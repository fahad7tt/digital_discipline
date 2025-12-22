class WeeklySummary {
  /// Total minutes used in the week
  int totalMinutes(List<int> dailyUsageMinutes) {
    return dailyUsageMinutes.fold(0, (sum, m) => sum + m);
  }

  /// Average daily usage
  double averageDailyUsage(List<int> dailyUsageMinutes) {
    if (dailyUsageMinutes.isEmpty) return 0;
    return totalMinutes(dailyUsageMinutes) / dailyUsageMinutes.length;
  }

  /// Whether usage is improving compared to last week
  bool isImproving({
    required int thisWeekTotal,
    required int lastWeekTotal,
  }) {
    return thisWeekTotal < lastWeekTotal;
  }
}
