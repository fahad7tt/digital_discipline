part of 'reflection_bloc.dart';

abstract class ReflectionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTodayReflection extends ReflectionEvent {
  final DateTime date;
  LoadTodayReflection(this.date);
}

class SaveTodayReflection extends ReflectionEvent {
  final Reflection reflection;
  SaveTodayReflection(this.reflection);
}
