import '../entities/digital_app.dart';
import '../repositories/digital_app_repo.dart';

class AddDigitalApp {
  final DigitalAppRepository repository;

  AddDigitalApp(this.repository);

  Future<void> call(DigitalApp app) async {
    if (app.name.trim().isEmpty) {
      throw Exception('App name cannot be empty');
    }
    if (app.dailyLimitMinutes <= 0) {
      throw Exception('Daily limit must be greater than zero');
    }
    await repository.add(app);
  }
}
