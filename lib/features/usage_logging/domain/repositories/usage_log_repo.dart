import '../entities/usage_log.dart';

abstract class UsageLogRepository {
  Future<List<UsageLog>> getLogsForApp(String focusAppId);
  Future<void> addLog(UsageLog log);
  Future<void> deleteLog(String id);
}
