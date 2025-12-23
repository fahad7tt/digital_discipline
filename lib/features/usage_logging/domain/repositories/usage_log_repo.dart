import '../entities/app_usage.dart';

abstract class UsageRepository {
  Future<bool> hasUsageAccess();
  Future<List<AppUsage>> getTodayUsage();
  Future<List<AppUsage>> getWeeklyUsage();
}
