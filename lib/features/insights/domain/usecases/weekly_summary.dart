import '../../../usage_logging/domain/entities/usage_log.dart';

class WeeklySummary {
  int totalMinutes(List<UsageLog> logs) =>
      logs.fold(0, (sum, log) => sum + log.durationMinutes);

  String mostCommonTrigger(List<UsageLog> logs) {
    final map = <String, int>{};
    for (var log in logs) {
      map[log.triggerType] = (map[log.triggerType] ?? 0) + 1;
    }
    return map.entries.isEmpty
        ? 'None'
        : map.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}
