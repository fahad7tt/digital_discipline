part of 'usage_log_bloc.dart';

abstract class UsageLogEvent extends Equatable {
  const UsageLogEvent();
  @override
  List<Object?> get props => [];
}

class LoadUsageLogs extends UsageLogEvent {
  final String focusAppId;
  const LoadUsageLogs({required this.focusAppId});
  @override
  List<Object?> get props => [focusAppId];
}

class AddUsageLogEvent extends UsageLogEvent {
  final UsageLog log;
  const AddUsageLogEvent(this.log);
  @override
  List<Object?> get props => [log];
}
