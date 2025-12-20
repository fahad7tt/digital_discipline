import '../entities/digital_app.dart';
abstract class DigitalAppRepository {
  Future<List<DigitalApp>> getAll();
  Future<void> add(DigitalApp app);
  Future<void> delete(String id);
}
