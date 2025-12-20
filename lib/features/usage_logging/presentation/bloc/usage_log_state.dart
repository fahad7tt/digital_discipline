part of 'usage_log_bloc.dart';

abstract class UsageLogState extends Equatable {
  const UsageLogState();
  @override
  List<Object?> get props => [];
}

class UsageLogInitial extends UsageLogState {}
class UsageLogLoading extends UsageLogState {}
class UsageLogLoaded extends UsageLogState {
  final List<UsageLog> logs;
  const UsageLogLoaded(this.logs);
  @override
  List<Object?> get props => [logs];
}
class UsageLogError extends UsageLogState {
  final String message;
  const UsageLogError(this.message);
  @override
  List<Object?> get props => [message];
}
