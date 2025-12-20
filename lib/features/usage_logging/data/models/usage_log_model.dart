import 'package:hive/hive.dart';
import '../../domain/entities/usage_log.dart';

part 'usage_log_model.g.dart';

@HiveType(typeId: 1)
class UsageLogModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String focusAppId;

  @HiveField(2)
  int durationMinutes;

  @HiveField(3)
  String triggerType;

  @HiveField(4)
  DateTime loggedAt;

  UsageLogModel({
    required this.id,
    required this.focusAppId,
    required this.durationMinutes,
    required this.triggerType,
    required this.loggedAt,
  });

  UsageLog toEntity() => UsageLog(
      id: id,
      focusAppId: focusAppId,
      durationMinutes: durationMinutes,
      triggerType: triggerType,
      loggedAt: loggedAt);

  static UsageLogModel fromEntity(UsageLog log) => UsageLogModel(
      id: log.id,
      focusAppId: log.focusAppId,
      durationMinutes: log.durationMinutes,
      triggerType: log.triggerType,
      loggedAt: log.loggedAt);
}
