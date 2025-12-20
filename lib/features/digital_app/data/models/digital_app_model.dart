import 'package:digital_discipline/features/digital_app/domain/entities/digital_app.dart';
import 'package:hive/hive.dart';

part 'digital_app_model.g.dart';


@HiveType(typeId: 0)
class DigitalAppModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int dailyLimitMinutes;

  @HiveField(3)
  DateTime createdAt;

  DigitalAppModel({
    required this.id,
    required this.name,
    required this.dailyLimitMinutes,
    required this.createdAt,
  });

  DigitalApp toEntity() => DigitalApp(
        id: id,
        name: name,
        dailyLimitMinutes: dailyLimitMinutes,
        createdAt: createdAt,
      );

  static DigitalAppModel fromEntity(DigitalApp app) => DigitalAppModel(
        id: app.id,
        name: app.name,
        dailyLimitMinutes: app.dailyLimitMinutes,
        createdAt: app.createdAt,
      );
}
