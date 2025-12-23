import 'package:hive/hive.dart';
import '../../domain/entities/daily_reflection.dart';

part 'reflection_model.g.dart';

@HiveType(typeId: 2)
class ReflectionModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  int mood;

  @HiveField(3)
  String reflectionAnswer;

  @HiveField(4)
  String gratitude;

  @HiveField(5)
  String tomorrowIntention;

  ReflectionModel({
    required this.id,
    required this.date,
    required this.mood,
    required this.reflectionAnswer,
    required this.gratitude,
    required this.tomorrowIntention,
  });

  // Convert to domain entity
  toDomain() {
    return DailyReflection(
      id: id,
      date: date,
      mood: mood,
      reflectionAnswer: reflectionAnswer,
      gratitude: gratitude,
      tomorrowIntention: tomorrowIntention,
    );
  }

  // Create from domain entity
  factory ReflectionModel.fromDomain(DailyReflection reflection) {
    return ReflectionModel(
      id: reflection.id,
      date: reflection.date,
      mood: reflection.mood,
      reflectionAnswer: reflection.reflectionAnswer,
      gratitude: reflection.gratitude,
      tomorrowIntention: reflection.tomorrowIntention,
    );
  }
}
