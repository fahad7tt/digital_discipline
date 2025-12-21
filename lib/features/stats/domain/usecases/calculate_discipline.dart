import 'package:digital_discipline/features/digital_app/domain/entities/digital_app.dart';
import '../../../usage_logging/domain/entities/usage_log.dart';
import '../entities/discipline_score.dart';

class CalculateDailyDiscipline {
  DisciplineScore call({
    required DateTime date,
    required DigitalApp app,
    required List<UsageLog> logs,
  }) {
    final totalUsed =
        logs.fold<int>(0, (sum, log) => sum + log.durationMinutes);

    return DisciplineScore(
      date: date,
      loggedHonestly: logs.isNotEmpty,
      limitRespected: totalUsed <= app.dailyLimitMinutes,
    );
  }
}
