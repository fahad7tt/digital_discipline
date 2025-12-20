import '../../domain/entities/digital_app.dart';
import '../../domain/repositories/digital_app_repo.dart';
import '../datasources/digital_app_local_datasource.dart';
import '../models/digital_app_model.dart';

class DigitalAppRepositoryImpl implements DigitalAppRepository {
  final DigitalAppLocalDataSource local;

  DigitalAppRepositoryImpl(this.local);

  @override
  Future<void> add(DigitalApp app) {
    return local.add(DigitalAppModel.fromEntity(app));
  }

  @override
  Future<void> delete(String id) {
    return local.delete(id);
  }

  @override
  Future<List<DigitalApp>> getAll() async {
    final models = await local.getAll();
    return models.map((e) => e.toEntity()).toList();
  }
}
