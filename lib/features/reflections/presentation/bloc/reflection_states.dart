part of 'reflection_bloc.dart';

abstract class ReflectionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReflectionInitial extends ReflectionState {}
class ReflectionEmpty extends ReflectionState {}
class ReflectionLoaded extends ReflectionState {
  final Reflection reflection;
  ReflectionLoaded(this.reflection);
}
class ReflectionSaved extends ReflectionState {}
