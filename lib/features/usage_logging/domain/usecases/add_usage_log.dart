import '../entities/usage_log.dart';
import '../repositories/usage_log_repo.dart';

class AddUsageLog {
  final UsageLogRepository repository;

  AddUsageLog(this.repository);

  Future<void> call(UsageLog log) => repository.addLog(log);
}
