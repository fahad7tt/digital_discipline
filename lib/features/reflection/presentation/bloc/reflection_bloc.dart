import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/daily_reflection.dart';
import '../../domain/repositories/reflection_repository.dart';

part 'reflection_event.dart';
part 'reflection_state.dart';

class ReflectionBloc extends Bloc<ReflectionEvent, ReflectionState> {
  final ReflectionRepository repository;

  ReflectionBloc(this.repository) : super(ReflectionInitial()) {
    on<LoadTodayReflection>(_onLoadTodayReflection);
    on<LoadYesterdayReflection>(_onLoadYesterdayReflection);
    on<SaveReflection>(_onSaveReflection);
  }

  Future<void> _onLoadTodayReflection(
    LoadTodayReflection event,
    Emitter<ReflectionState> emit,
  ) async {
    if (state is! ReflectionLoaded) {
      emit(ReflectionLoading());
    }
    try {
      final reflection = await repository.getTodayReflection();
      if (state is ReflectionLoaded) {
        emit((state as ReflectionLoaded).copyWith(todayReflection: reflection));
      } else {
        emit(ReflectionLoaded(todayReflection: reflection));
      }
    } catch (e) {
      emit(ReflectionError(e.toString()));
    }
  }

  Future<void> _onLoadYesterdayReflection(
    LoadYesterdayReflection event,
    Emitter<ReflectionState> emit,
  ) async {
    try {
      final reflection = await repository.getYesterdayReflection();
      if (state is ReflectionLoaded) {
        emit((state as ReflectionLoaded)
            .copyWith(yesterdayReflection: reflection));
      } else {
        emit(ReflectionLoaded(yesterdayReflection: reflection));
      }
    } catch (e) {
      emit(ReflectionError(e.toString()));
    }
  }

  Future<void> _onSaveReflection(
    SaveReflection event,
    Emitter<ReflectionState> emit,
  ) async {
    try {
      final reflection = DailyReflection(
        id: const Uuid().v4(),
        date: DateTime.now(),
        mood: event.mood,
        reflectionAnswer: event.reflectionAnswer,
        gratitude: event.gratitude,
        tomorrowIntention: event.tomorrowIntention,
      );

      await repository.saveReflection(reflection);
      emit(ReflectionSaved(reflection));

      // Reload to show updated state
      add(LoadTodayReflection());
    } catch (e) {
      emit(ReflectionError(e.toString()));
    }
  }
}
