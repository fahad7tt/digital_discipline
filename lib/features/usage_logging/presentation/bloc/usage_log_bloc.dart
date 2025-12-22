import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/usage_log_repo.dart';
import 'usage_log_event.dart';
import 'usage_log_state.dart';

class AppUsageBloc extends Bloc<AppUsageEvent, AppUsageState> {
  final UsageRepository repository;

  AppUsageBloc(this.repository) : super(AppUsageInitial()) {
    on<LoadTodayUsage>(_onLoadUsage);
    on<RefreshUsage>(_onLoadUsage);
  }

  Future<void> _onLoadUsage(
  AppUsageEvent event,
  Emitter<AppUsageState> emit,
) async {
  emit(AppUsageLoading());

  try {
    final hasPermission = await repository.hasUsageAccess();
    log('USAGE_DEBUG → hasPermission: $hasPermission');

    if (!hasPermission) {
      emit(AppUsagePermissionRequired());
      return;
    }

    final usages = await repository.getTodayUsage();

    log('USAGE_DEBUG → Raw usages from repository:');
    for (final u in usages) {
      log('USAGE_DEBUG → ${u.packageName} = ${u.minutesUsed} min');
    }

    final totalMinutes =
        usages.fold<int>(0, (sum, u) => sum + u.minutesUsed);

    log('USAGE_DEBUG → Total minutes: $totalMinutes');

    emit(
      AppUsageLoaded(
        usages: usages,
        totalMinutes: totalMinutes,
      ),
    );
  } catch (e) {
    log('USAGE_DEBUG → ERROR: $e');
    emit(AppUsageError(e.toString()));
  }
}
}
