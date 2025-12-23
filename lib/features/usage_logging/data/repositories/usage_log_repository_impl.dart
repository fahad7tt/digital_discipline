import 'package:digital_discipline/features/usage_logging/domain/entities/app_usage.dart';

import '../../domain/repositories/usage_log_repo.dart';
import '../datasources/usage_log_local_datasource.dart';

class UsageRepositoryImpl implements UsageRepository {
  final AndroidUsageDataSource dataSource;

  UsageRepositoryImpl(this.dataSource);

  @override
  Future<bool> hasUsageAccess() {
    return dataSource.hasUsageAccess();
  }

  @override
  Future<List<AppUsage>> getTodayUsage() async {
    final rawList = await dataSource.getTodayUsage();
    final Map<String, AppUsage> aggregated = {};

    for (final map in rawList) {
      final packageName = map['packageName'] as String;
      final appName = map['appName'] as String;
      final minutes = map['minutesUsed'] as int;

      if (aggregated.containsKey(packageName)) {
        final existing = aggregated[packageName]!;
        aggregated[packageName] = AppUsage(
          packageName: packageName,
          appName: appName.isNotEmpty ? appName : existing.appName,
          minutesUsed: existing.minutesUsed + minutes,
        );
      } else {
        aggregated[packageName] = AppUsage(
          packageName: packageName,
          appName: appName,
          minutesUsed: minutes,
        );
      }
    }

    return aggregated.values.toList();
  }

  @override
  Future<List<AppUsage>> getWeeklyUsage() async {
    final rawList = await dataSource.getWeeklyUsage();
    return rawList
        .map((map) => AppUsage(
              packageName: map['packageName'] as String,
              appName: map['appName'] as String,
              minutesUsed: map['minutesUsed'] as int,
              startDate: map['date'] != null
                  ? DateTime.fromMillisecondsSinceEpoch(map['date'] as int)
                  : null,
            ))
        .toList();
  }
}
