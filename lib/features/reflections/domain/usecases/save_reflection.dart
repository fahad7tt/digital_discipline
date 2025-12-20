import '../entities/reflection.dart';
import '../repositories/reflection_repository.dart';

class SaveReflection {
  final ReflectionRepository repository;

  SaveReflection(this.repository);

  Future<void> call(Reflection reflection) {
    return repository.saveReflection(reflection);
  }
}
