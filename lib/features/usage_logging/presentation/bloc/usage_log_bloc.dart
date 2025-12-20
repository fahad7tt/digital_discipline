import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/usage_log.dart';
import '../../domain/repositories/usage_log_repo.dart';
import '../../domain/usecases/add_usage_log.dart';

part 'usage_log_event.dart';
part 'usage_log_state.dart';

class UsageLogBloc extends Bloc<UsageLogEvent, UsageLogState> {
  final UsageLogRepository repository;
  final AddUsageLog addUsageLog;

  UsageLogBloc(this.repository, this.addUsageLog) : super(UsageLogInitial()) {
    on<LoadUsageLogs>(_onLoad);
    on<AddUsageLogEvent>(_onAdd);
  }

  Future<void> _onLoad(LoadUsageLogs event, Emitter<UsageLogState> emit) async {
    emit(UsageLogLoading());
    final logs = await repository.getLogsForApp(event.focusAppId);
    emit(UsageLogLoaded(logs));
  }

  Future<void> _onAdd(AddUsageLogEvent event, Emitter<UsageLogState> emit) async {
    await addUsageLog(event.log);
    add(LoadUsageLogs(focusAppId: event.log.focusAppId));
  }
}
