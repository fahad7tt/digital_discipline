import '../../domain/entities/reflection.dart';
import '../../domain/repositories/reflection_repository.dart';
import '../datasources/reflection_local_datasource.dart';
import '../models/reflection_model.dart';

class ReflectionRepositoryImpl implements ReflectionRepository {
  final ReflectionLocalDataSource local;

  ReflectionRepositoryImpl(this.local);

  @override
  Future<void> saveReflection(Reflection reflection) {
    return local.save(ReflectionModel.fromEntity(reflection));
  }

  @override
  Future<Reflection?> getReflectionByDate(DateTime date) async {
    final model = await local.getByDate(date);
    return model?.toEntity();
  }
}
