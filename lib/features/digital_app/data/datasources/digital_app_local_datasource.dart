import 'package:hive/hive.dart';
import '../models/digital_app_model.dart';

abstract class DigitalAppLocalDataSource {
  Future<List<DigitalAppModel>> getAll();
  Future<void> add(DigitalAppModel model);
  Future<void> delete(String id);
}

class DigitalAppLocalDataSourceImpl implements DigitalAppLocalDataSource {
  final Box<DigitalAppModel> box;

  DigitalAppLocalDataSourceImpl(this.box);

  @override
  Future<List<DigitalAppModel>> getAll() async => box.values.toList();

  @override
  Future<void> add(DigitalAppModel model) async {
    await box.put(model.id, model);
  }

  @override
  Future<void> delete(String id) async {
    await box.delete(id);
  }
}
