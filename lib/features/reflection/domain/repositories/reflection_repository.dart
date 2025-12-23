import '../entities/daily_reflection.dart';

abstract class ReflectionRepository {
  Future<void> saveReflection(DailyReflection reflection);
  Future<DailyReflection?> getTodayReflection();
  Future<DailyReflection?> getYesterdayReflection();
  Future<List<DailyReflection>> getLastNDaysReflections(int days);
  Future<List<DailyReflection>> getAllReflections();
  Future<int> calculateStreak();
}
