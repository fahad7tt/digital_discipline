part of 'stats_bloc.dart';

abstract class StatsState extends Equatable {
  const StatsState();

  @override
  List<Object?> get props => [];
}

class StatsInitial extends StatsState {
  const StatsInitial();
}

class StatsLoading extends StatsState {
  const StatsLoading();
}

class StatsLoaded extends StatsState {
  final int totalMinutesThisWeek;
  final String mostCommonTrigger;
  final int logCount;
  final int averageDailyUsage;

  const StatsLoaded({
    required this.totalMinutesThisWeek,
    required this.mostCommonTrigger,
    required this.logCount,
    required this.averageDailyUsage,
  });

  @override
  List<Object?> get props =>
      [totalMinutesThisWeek, mostCommonTrigger, logCount, averageDailyUsage];
}

class StatsError extends StatsState {
  final String message;

  const StatsError(this.message);

  @override
  List<Object?> get props => [message];
}
