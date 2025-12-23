part of 'reflection_bloc.dart';

abstract class ReflectionEvent {}

class LoadTodayReflection extends ReflectionEvent {}

class LoadYesterdayReflection extends ReflectionEvent {}

class SaveReflection extends ReflectionEvent {
  final int mood;
  final String reflectionAnswer;
  final String gratitude;
  final String tomorrowIntention;

  SaveReflection({
    required this.mood,
    required this.reflectionAnswer,
    required this.gratitude,
    required this.tomorrowIntention,
  });
}
