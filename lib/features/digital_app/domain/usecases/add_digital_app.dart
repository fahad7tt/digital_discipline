import '../entities/digital_app.dart';
import '../repositories/digital_app_repo.dart';

class AddDigitalDiscipline {
  final DigitalDisciplineRepository repository;

  AddDigitalDiscipline(this.repository);

  Future<void> call(DigitalDiscipline discipline) {
    return repository.add(discipline);
  }
}
