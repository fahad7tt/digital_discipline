import 'package:hive/hive.dart';
import '../../domain/entities/reflection.dart';

part 'reflection_model.g.dart';

@HiveType(typeId: 2)
class ReflectionModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  String mood;

  @HiveField(3)
  String note;

  ReflectionModel({
    required this.id,
    required this.date,
    required this.mood,
    required this.note,
  });

  Reflection toEntity() =>
      Reflection(id: id, date: date, mood: mood, note: note);

  static ReflectionModel fromEntity(Reflection r) => ReflectionModel(
        id: r.id,
        date: r.date,
        mood: r.mood,
        note: r.note,
      );
}
