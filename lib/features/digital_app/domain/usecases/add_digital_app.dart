import '../entities/digital_app.dart';
import '../repositories/digital_app_repo.dart';

class AddDigitalApp {
  final DigitalAppRepository repository;

  AddDigitalApp(this.repository);

  Future<void> call(DigitalApp app) {
    return repository.add(app);
  }
}
