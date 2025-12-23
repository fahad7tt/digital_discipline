part of 'reflection_bloc.dart';

abstract class ReflectionState {}

class ReflectionInitial extends ReflectionState {}

class ReflectionLoading extends ReflectionState {}

class ReflectionLoaded extends ReflectionState {
  final DailyReflection? reflection;

  ReflectionLoaded({this.reflection});

  bool get hasReflection => reflection != null;
}

class ReflectionSaved extends ReflectionState {
  final DailyReflection reflection;

  ReflectionSaved(this.reflection);
}

class ReflectionError extends ReflectionState {
  final String message;

  ReflectionError(this.message);
}
