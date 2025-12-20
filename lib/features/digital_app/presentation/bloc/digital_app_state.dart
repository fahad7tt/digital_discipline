part of 'digital_app_bloc.dart';

abstract class DigitalAppState extends Equatable {
  const DigitalAppState();

  @override
  List<Object?> get props => [];
}

class DigitalAppInitial extends DigitalAppState {}

class DigitalAppLoading extends DigitalAppState {}

class DigitalAppLoaded extends DigitalAppState {
  final List<DigitalApp> apps;

  const DigitalAppLoaded(this.apps);

  @override
  List<Object?> get props => [apps];
}

class DigitalAppError extends DigitalAppState {
  final String message;

  const DigitalAppError(this.message);

  @override
  List<Object?> get props => [message];
}
