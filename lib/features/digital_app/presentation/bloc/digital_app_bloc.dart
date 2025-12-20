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
  }

  Future<void> _onLoad(
      LoadDigitalApps event, Emitter<DigitalAppState> emit) async {
    emit(DigitalAppLoading());
    final apps = await repository.getAll();
    emit(DigitalAppLoaded(apps));
  }

  Future<void> _onAdd(
      AddDigitalAppEvent event, Emitter<DigitalAppState> emit) async {
    await addDigitalApp(event.app);
    add(LoadDigitalApps());
  }
}
