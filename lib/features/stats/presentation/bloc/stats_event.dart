part of 'stats_bloc.dart';

abstract class StatsEvent extends Equatable {
  const StatsEvent();

  @override
  List<Object?> get props => [];
}

class LoadStats extends StatsEvent {
  const LoadStats();
}

class RefreshStats extends StatsEvent {
  const RefreshStats();
}
