import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/reflection.dart';
import '../../domain/usecases/save_reflection.dart';
import '../../domain/repositories/reflection_repository.dart';

part 'reflection_events.dart';
part 'reflection_states.dart';

class ReflectionBloc extends Bloc<ReflectionEvent, ReflectionState> {
  final SaveReflection saveReflection;
  final ReflectionRepository repository;

  ReflectionBloc(this.saveReflection, this.repository)
      : super(ReflectionInitial()) {
    on<LoadTodayReflection>(_onLoad);
    on<SaveTodayReflection>(_onSave);
  }

  Future<void> _onLoad(
      LoadTodayReflection event, Emitter<ReflectionState> emit) async {
    final reflection = await repository.getReflectionByDate(event.date);
    if (reflection != null) {
      emit(ReflectionLoaded(reflection));
    } else {
      emit(ReflectionEmpty());
    }
  }

  Future<void> _onSave(
      SaveTodayReflection event, Emitter<ReflectionState> emit) async {
    await saveReflection(event.reflection);
    emit(ReflectionSaved());
  }
}
