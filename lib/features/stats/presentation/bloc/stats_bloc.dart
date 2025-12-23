import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
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
      // Fetch both Today's usage (trusted for current day) and Weekly usage (history)
      final results = await Future.wait([
        usageRepository.getTodayUsage(),
        usageRepository.getWeeklyUsage(),
      ]);
      final rawTodayUsage = results[0];
      final rawWeeklyUsage = results[1];

      // Filter out system apps for both
      bool isUserApp(dynamic u) {
        return !u.packageName.contains('launcher') &&
            !u.packageName.contains('systemui') &&
            !u.packageName.startsWith('com.android');
      }

      final todayData = rawTodayUsage.where(isUserApp).toList();
      final weeklyData = rawWeeklyUsage.where(isUserApp).toList();

      // Calculate start of the week (Sunday)
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday % 7));

      final weeklyUsage = List<int>.filled(7, 0, growable: true);
      final dailyBreakdown = <Map<String, dynamic>>[];

      for (int i = 0; i < 7; i++) {
        final date = startOfWeek.add(Duration(days: i));
        final dayName = DateFormat('EEEE').format(date);
        final isToday = date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;

        int dailyTotal = 0;

        if (isToday) {
          // Trusted Source for TODAY: The 'today' api
          dailyTotal = todayData.fold<int>(0, (sum, u) => sum + u.minutesUsed);
        } else {
          // Source for HISTORY: The 'weekly' api
          final isFuture =
              date.isAfter(DateTime(now.year, now.month, now.day, 23, 59, 59));

          if (!isFuture) {
            dailyTotal = weeklyData.where((u) {
              if (u.startDate == null) return false;
              return u.startDate!.year == date.year &&
                  u.startDate!.month == date.month &&
                  u.startDate!.day == date.day;
            }).fold<int>(0, (sum, u) => sum + u.minutesUsed);
          }
        }

        // Handle visualization
        final isFuture =
            date.isAfter(DateTime(now.year, now.month, now.day, 23, 59, 59));

        if (isFuture) {
          weeklyUsage[i] = 0;
          dailyBreakdown.add({
            'day': dayName,
            'minutes': null,
          });
        } else {
          weeklyUsage[i] = dailyTotal;
          dailyBreakdown.add({
            'day': isToday ? '$dayName (Today)' : dayName,
            'minutes': dailyTotal,
          });
        }
      }

      final weeklyTotal = weeklySummary.totalMinutes(weeklyUsage);
      final avgDaily = weeklySummary.averageDailyUsage(weeklyUsage).round();

      emit(
        StatsLoaded(
          totalMinutesThisWeek: weeklyTotal,
          averageDailyUsage: avgDaily,
          isImproving: false, // real comparison later
          dailyBreakdown: dailyBreakdown,
        ),
      );
    } catch (e) {
      emit(StatsError(e.toString()));
    }
  }
}
