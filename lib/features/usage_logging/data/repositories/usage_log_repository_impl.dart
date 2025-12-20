import '../../domain/entities/usage_log.dart';
import '../../domain/repositories/usage_log_repo.dart';
import '../datasources/usage_log_local_datasource.dart';
import '../models/usage_log_model.dart';

class UsageLogRepositoryImpl implements UsageLogRepository {
  final UsageLogLocalDataSource local;

  UsageLogRepositoryImpl(this.local);

  @override
  Future<void> addLog(UsageLog log) {
    return local.addLog(UsageLogModel.fromEntity(log));
  }

  @override
  Future<void> deleteLog(String id) {
    return local.deleteLog(id);
  }

  @override
  Future<List<UsageLog>> getLogsForApp(String focusAppId) async {
    final models = await local.getLogsForApp(focusAppId);
    return models.map((e) => e.toEntity()).toList();
  }
}
