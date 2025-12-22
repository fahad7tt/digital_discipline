import 'package:hive/hive.dart';
import '../../domain/entities/app_usage.dart';

part 'usage_log_model.g.dart';

@HiveType(typeId: 1)
class AppUsageModel extends HiveObject {
  @HiveField(0)
  String packageName;

  @HiveField(1)
  int minutesUsed;

  AppUsageModel({
    required this.packageName,
    required this.minutesUsed,
  });

  AppUsage toEntity() => AppUsage(
     packageName: packageName,
     minutesUsed: minutesUsed);

  static AppUsageModel fromEntity(AppUsage usage) => AppUsageModel(
      packageName: usage.packageName,
      minutesUsed: usage.minutesUsed);
}
