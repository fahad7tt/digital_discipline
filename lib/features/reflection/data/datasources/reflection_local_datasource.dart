import 'package:hive/hive.dart';
import '../../domain/entities/daily_reflection.dart';
import '../models/reflection_model.dart';

class ReflectionLocalDatasource {
  static const String _boxName = 'reflections';

  Future<Box<ReflectionModel>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<ReflectionModel>(_boxName);
    }
    return Hive.box<ReflectionModel>(_boxName);
  }

  Future<void> saveReflection(DailyReflection reflection) async {
    final box = await _getBox();
    final model = ReflectionModel.fromDomain(reflection);
    await box.put(reflection.id, model);
  }

  Future<DailyReflection?> getTodayReflection() async {
    final box = await _getBox();
    final now = DateTime.now();

    // Find reflection for today
    for (var model in box.values) {
      if (model.date.year == now.year &&
          model.date.month == now.month &&
          model.date.day == now.day) {
        return model.toDomain();
      }
    }
    return null;
  }

  Future<List<DailyReflection>> getAllReflections() async {
    final box = await _getBox();
    return box.values
        .map((model) => model.toDomain())
        .toList()
        .cast<DailyReflection>();
  }
}
