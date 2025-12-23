import '../../domain/entities/daily_reflection.dart';
import '../../domain/repositories/reflection_repository.dart';
import '../datasources/reflection_local_datasource.dart';

class ReflectionRepositoryImpl implements ReflectionRepository {
  final ReflectionLocalDatasource datasource;

  ReflectionRepositoryImpl(this.datasource);

  @override
  Future<void> saveReflection(DailyReflection reflection) async {
    await datasource.saveReflection(reflection);
  }

  @override
  Future<DailyReflection?> getTodayReflection() async {
    return await datasource.getTodayReflection();
  }

  @override
  Future<List<DailyReflection>> getAllReflections() async {
    return await datasource.getAllReflections();
  }

  @override
  Future<DailyReflection?> getYesterdayReflection() async {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final allReflections = await datasource.getAllReflections();

    for (var reflection in allReflections) {
      if (reflection.date.year == yesterday.year &&
          reflection.date.month == yesterday.month &&
          reflection.date.day == yesterday.day) {
        return reflection;
      }
    }
    return null;
  }

  @override
  Future<List<DailyReflection>> getLastNDaysReflections(int days) async {
    final allReflections = await datasource.getAllReflections();
    final now = DateTime.now();

    final filtered = allReflections.where((reflection) {
      final difference = now.difference(reflection.date).inDays;
      return difference >= 0 && difference < days;
    }).toList();

    // Sort by date descending (most recent first)
    filtered.sort((a, b) => b.date.compareTo(a.date));
    return filtered;
  }

  @override
  Future<int> calculateStreak() async {
    final allReflections = await datasource.getAllReflections();
    if (allReflections.isEmpty) return 0;

    // Sort by date descending
    final sorted = allReflections.toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    int streak = 0;
    final now = DateTime.now();
    DateTime checkDate = DateTime(now.year, now.month, now.day);

    for (var reflection in sorted) {
      final reflectionDate = DateTime(
        reflection.date.year,
        reflection.date.month,
        reflection.date.day,
      );

      if (reflectionDate.isAtSameMomentAs(checkDate)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (reflectionDate.isBefore(checkDate)) {
        // Gap in streak
        break;
      }
    }

    return streak;
  }
}
