import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../usage_logging/domain/repositories/usage_log_repo.dart';
import '../../domain/usecases/weekly_summary.dart';
import '../../domain/usecases/calculate_discipline.dart';
part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final UsageRepository usageRepository;
  final WeeklySummary weeklySummary;
  final CalculateDailyDiscipline calculateDailyDiscipline;

  StatsBloc(
    this.usageRepository,
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
      // Fetch today’s usage snapshot
      final todayUsage = await usageRepository.getTodayUsage();

      final todayTotal =
          todayUsage.fold<int>(0, (sum, u) => sum + u.minutesUsed);

      // ⚠️ Placeholder until historical storage is added
      // For now we simulate a 7-day list using today’s data
      final last7Days = List<int>.filled(7, todayTotal);

      final weeklyTotal =
          weeklySummary.totalMinutes(last7Days);

      final avgDaily =
          weeklySummary.averageDailyUsage(last7Days).round();

      emit(
        StatsLoaded(
          totalMinutesThisWeek: weeklyTotal,
          averageDailyUsage: avgDaily,
          isImproving: false, // real comparison later
        ),
      );
    } catch (e) {
      emit(StatsError(e.toString()));
    }
  }
}
