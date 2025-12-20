import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/digital_app.dart';
import '../../domain/repositories/digital_app_repo.dart';
import '../../domain/usecases/add_digital_app.dart';

part 'digital_app_event.dart';
part 'digital_app_state.dart';

class DigitalAppBloc extends Bloc<DigitalAppEvent, DigitalAppState> {
  final AddDigitalApp addDigitalApp;
  final DigitalAppRepository repository;

  DigitalAppBloc(this.addDigitalApp, this.repository)
      : super(DigitalAppInitial()) {
    on<LoadDigitalApps>(_onLoad);
    on<AddDigitalAppEvent>(_onAdd);
    on<DeleteDigitalAppEvent>(_onDelete);
    on<UpdateDigitalAppEvent>(_onUpdate);
  }

  Future<void> _onLoad(
      LoadDigitalApps event, Emitter<DigitalAppState> emit) async {
    emit(DigitalAppLoading());
    final apps = await repository.getAll();
    emit(DigitalAppLoaded(apps));
  }

  Future<void> _onAdd(
      AddDigitalAppEvent event, Emitter<DigitalAppState> emit) async {
    emit(DigitalAppLoading());
    try {
      await addDigitalApp(event.app);
      add(LoadDigitalApps());
    } catch (e) {
      emit(DigitalAppError(e.toString()));
    }
  }

  Future<void> _onDelete(
      DeleteDigitalAppEvent event, Emitter<DigitalAppState> emit) async {
    emit(DigitalAppLoading());
    try {
      await repository.delete(event.id);
      add(LoadDigitalApps());
    } catch (e) {
      emit(DigitalAppError(e.toString()));
    }
  }

  Future<void> _onUpdate(
      UpdateDigitalAppEvent event, Emitter<DigitalAppState> emit) async {
    emit(DigitalAppLoading());
    try {
      // repository.add uses put which updates existing key
      await repository.add(event.app);
      add(LoadDigitalApps());
    } catch (e) {
      emit(DigitalAppError(e.toString()));
    }
  }
}
