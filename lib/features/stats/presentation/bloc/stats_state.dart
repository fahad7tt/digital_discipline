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
  final int averageDailyUsage;
  final bool isImproving;

  const StatsLoaded({
    required this.totalMinutesThisWeek,
    required this.averageDailyUsage,
    required this.isImproving,
  });

  @override
  List<Object> get props =>
      [totalMinutesThisWeek, averageDailyUsage, isImproving];
}

class StatsError extends StatsState {
  final String message;

  const StatsError(this.message);

  @override
  List<Object?> get props => [message];
}
