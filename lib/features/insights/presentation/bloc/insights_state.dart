part of 'insights_bloc.dart';

abstract class InsightsState extends Equatable {
  const InsightsState();

  @override
  List<Object?> get props => [];
}

class InsightsInitial extends InsightsState {
  const InsightsInitial();
}

class InsightsLoading extends InsightsState {
  const InsightsLoading();
}

class InsightsLoaded extends InsightsState {
  final int totalMinutesThisWeek;
  final String mostCommonTrigger;
  final int logCount;
  final int averageDailyUsage;

  const InsightsLoaded({
    required this.totalMinutesThisWeek,
    required this.mostCommonTrigger,
    required this.logCount,
    required this.averageDailyUsage,
  });

  @override
  List<Object?> get props =>
      [totalMinutesThisWeek, mostCommonTrigger, logCount, averageDailyUsage];
}

class InsightsError extends InsightsState {
  final String message;

  const InsightsError(this.message);

  @override
  List<Object?> get props => [message];
}
