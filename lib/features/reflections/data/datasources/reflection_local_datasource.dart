import 'package:hive/hive.dart';
import '../models/reflection_model.dart';

class ReflectionLocalDataSource {
  final Box<ReflectionModel> box;

  ReflectionLocalDataSource(this.box);

  Future<void> save(ReflectionModel model) async {
    await box.put(model.date.toIso8601String(), model);
  }

  Future<ReflectionModel?> getByDate(DateTime date) async {
    return box.get(date.toIso8601String());
  }
}
