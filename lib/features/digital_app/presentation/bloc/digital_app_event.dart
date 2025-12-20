part of 'digital_app_bloc.dart';

abstract class DigitalAppEvent extends Equatable {
  const DigitalAppEvent();

  @override
  List<Object?> get props => [];
}

class LoadDigitalApps extends DigitalAppEvent {}

class AddDigitalAppEvent extends DigitalAppEvent {
  final DigitalApp app;

  const AddDigitalAppEvent(this.app);

  @override
  List<Object?> get props => [app];
}

class DeleteDigitalAppEvent extends DigitalAppEvent {
  final String id;

  const DeleteDigitalAppEvent(this.id);

  @override
  List<Object?> get props => [id];
}
