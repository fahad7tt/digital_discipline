part of 'reflection_bloc.dart';

abstract class ReflectionState {}

class ReflectionInitial extends ReflectionState {}

class ReflectionLoading extends ReflectionState {}

class ReflectionLoaded extends ReflectionState {
  final DailyReflection? todayReflection;
  final DailyReflection? yesterdayReflection;

  ReflectionLoaded({
    this.todayReflection,
    this.yesterdayReflection,
  });

  bool get hasTodayReflection => todayReflection != null;
  bool get hasYesterdayReflection => yesterdayReflection != null;

  ReflectionLoaded copyWith({
    DailyReflection? todayReflection,
    DailyReflection? yesterdayReflection,
  }) {
    return ReflectionLoaded(
      todayReflection: todayReflection ?? this.todayReflection,
      yesterdayReflection: yesterdayReflection ?? this.yesterdayReflection,
    );
  }
}

class ReflectionSaved extends ReflectionState {
  final DailyReflection reflection;

  ReflectionSaved(this.reflection);
}

class ReflectionError extends ReflectionState {
  final String message;

  ReflectionError(this.message);
}
