class AppUsage {
  final String packageName;
  final String appName;
  final int minutesUsed;
  final DateTime? startDate;

  AppUsage({
    required this.packageName,
    required this.appName,
    required this.minutesUsed,
    this.startDate,
  });
}
