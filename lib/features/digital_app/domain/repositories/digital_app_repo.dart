import '../entities/digital_discipline.dart';
abstract class DigitalDisciplineRepository {
  Future<List<DigitalDiscipline>> getAll();
  Future<void> add(DigitalDiscipline discipline);
  Future<void> delete(String id);
}
