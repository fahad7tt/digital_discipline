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
    final raw = await dataSource.getTodayUsage();
    return raw.entries
        .map((e) => AppUsage(
              packageName: e.key,
              appName: e.key, 
              minutesUsed: e.value,
            ))
        .toList();
  }
}
