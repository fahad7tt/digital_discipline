import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/weekly_summary.dart';
import '../../domain/usecases/calculate_discipline.dart';
import '../../../usage_logging/domain/repositories/usage_log_repo.dart';

part 'insights_event.dart';
part 'insights_state.dart';

class InsightsBloc extends Bloc<InsightsEvent, InsightsState> {
  final UsageLogRepository usageLogRepository;
  final WeeklySummary weeklySummary;
  final CalculateDailyDiscipline calculateDailyDiscipline;

  InsightsBloc(
    this.usageLogRepository,
    this.weeklySummary,
    this.calculateDailyDiscipline,
  ) : super(InsightsInitial()) {
    on<LoadInsights>(_onLoad);
  }

  Future<void> _onLoad(
    LoadInsights event,
    Emitter<InsightsState> emit,
  ) async {
    emit(InsightsLoading());
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

      emit(InsightsLoaded(
        totalMinutesThisWeek: totalMinutes,
        mostCommonTrigger: mostCommonTrigger,
        logCount: weeklyLogs.length,
        averageDailyUsage:
            weeklyLogs.isEmpty ? 0 : (totalMinutes / 7).round(),
      ));
    } catch (e) {
      emit(InsightsError(e.toString()));
    }
  }
}
