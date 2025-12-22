import 'package:hive/hive.dart';
import '../../domain/entities/app_usage.dart';

part 'usage_log_model.g.dart';

@HiveType(typeId: 1)
class AppUsageModel extends HiveObject {
  @HiveField(0)
  String packageName;

  @HiveField(1)
  String appName;

  @HiveField(2)
  int minutesUsed;

  AppUsageModel({
    required this.packageName,
    required this.appName,
    required this.minutesUsed,
  });

  AppUsage toEntity() => AppUsage(
     packageName: packageName,
      appName: appName,
     minutesUsed: minutesUsed);

  static AppUsageModel fromEntity(AppUsage usage) => AppUsageModel(
      packageName: usage.packageName,
      appName: usage.appName,
      minutesUsed: usage.minutesUsed);
}
