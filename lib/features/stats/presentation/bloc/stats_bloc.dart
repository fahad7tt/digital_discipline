import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/weekly_summary.dart';
import '../../domain/usecases/calculate_discipline.dart';
import '../../../usage_logging/domain/repositories/usage_log_repo.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final UsageLogRepository usageLogRepository;
  final WeeklySummary weeklySummary;
  final CalculateDailyDiscipline calculateDailyDiscipline;

  StatsBloc(
    this.usageLogRepository,
    this.weeklySummary,
    this.calculateDailyDiscipline,
  ) : super(StatsInitial()) {
    on<LoadStats>(_onLoad);
  }

  Future<void> _onLoad(
    LoadStats event,
    Emitter<StatsState> emit,
  ) async {
    emit(StatsLoading());
    try {
      // Get logs for all apps (using empty string for all)
      final allLogs = await usageLogRepository.getLogsForApp('');
      
      // Filter logs from the past 7 days
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));
      final weeklyLogs = allLogs
          .where((log) => log.loggedAt.isAfter(sevenDaysAgo))
          .toList();

      final totalMinutes = weeklySummary.totalMinutes(weeklyLogs);
      final mostCommonTrigger = weeklySummary.mostCommonTrigger(weeklyLogs);

      emit(StatsLoaded(
        totalMinutesThisWeek: totalMinutes,
        mostCommonTrigger: mostCommonTrigger,
        logCount: weeklyLogs.length,
        averageDailyUsage:
            weeklyLogs.isEmpty ? 0 : (totalMinutes / 7).round(),
      ));
    } catch (e) {
      emit(StatsError(e.toString()));
    }
  }
}
