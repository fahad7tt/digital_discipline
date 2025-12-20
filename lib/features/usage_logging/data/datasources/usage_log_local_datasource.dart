import 'package:hive/hive.dart';
import '../models/usage_log_model.dart';

abstract class UsageLogLocalDataSource {
  Future<List<UsageLogModel>> getLogsForApp(String focusAppId);
  Future<void> addLog(UsageLogModel log);
  Future<void> deleteLog(String id);
}

class UsageLogLocalDataSourceImpl implements UsageLogLocalDataSource {
  final Box<UsageLogModel> box;

  UsageLogLocalDataSourceImpl(this.box);

  @override
  Future<void> addLog(UsageLogModel log) async {
    await box.put(log.id, log);
  }

  @override
  Future<void> deleteLog(String id) async {
    await box.delete(id);
  }

  @override
  Future<List<UsageLogModel>> getLogsForApp(String focusAppId) async {
    return box.values.where((log) => log.focusAppId == focusAppId).toList();
  }
}
