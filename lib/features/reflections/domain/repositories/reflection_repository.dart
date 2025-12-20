import '../entities/reflection.dart';

abstract class ReflectionRepository {
  Future<void> saveReflection(Reflection reflection);
  Future<Reflection?> getReflectionByDate(DateTime date);
}
