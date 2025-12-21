import '../entities/stats.dart';
import '../repositories/stats_repository.dart';

class GetContextualStats {
  final StatsRepository repository;

  GetContextualStats(this.repository);

  Stats? call(int usageMinutes) {
    final stats = repository.getAllStats();

    if (stats.isEmpty) return null;

    final applicable = stats
        .where((i) => usageMinutes >= i.minUsageMinutes)
        .toList();

    if (applicable.isEmpty) return null;

    applicable.sort(
      (a, b) => b.minUsageMinutes.compareTo(a.minUsageMinutes),
    );

    return applicable.first;
  }
}
