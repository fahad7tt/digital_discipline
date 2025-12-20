import 'package:equatable/equatable.dart';

class UsageLog extends Equatable {
  final String id;
  final String focusAppId;
  final int durationMinutes;
  final String triggerType;
  final DateTime loggedAt;

  const UsageLog({
    required this.id,
    required this.focusAppId,
    required this.durationMinutes,
    required this.triggerType,
    required this.loggedAt,
  });

  @override
  List<Object?> get props => [id, focusAppId, durationMinutes, triggerType, loggedAt];
}
