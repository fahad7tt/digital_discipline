import '../../domain/entities/stats.dart';

class StatsModel extends Stats {
  StatsModel({
    required super.id,
    required super.title,
    required super.description,
    required super.minUsageMinutes,
  });
}
