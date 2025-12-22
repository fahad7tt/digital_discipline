import 'package:digital_discipline/features/usage_logging/domain/entities/app_usage.dart';

abstract class AppUsageState {}

class AppUsageInitial extends AppUsageState {}

class AppUsageLoading extends AppUsageState {}

class AppUsageLoaded extends AppUsageState {
  final List<AppUsage> usages;
  final int totalMinutes;

  AppUsageLoaded({
    required this.usages,
    required this.totalMinutes,
  });
}

class AppUsagePermissionRequired extends AppUsageState {}

class AppUsageError extends AppUsageState {
  final String message;
  AppUsageError(this.message);
}
