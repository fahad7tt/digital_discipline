import 'package:hive/hive.dart';
import '../../features/digital_app/data/datasources/digital_app_local_datasource.dart';
import '../../features/digital_app/data/models/digital_app_model.dart';
import '../../features/digital_app/data/repositories/digital_app_repository_impl.dart';
import '../../features/digital_app/domain/usecases/add_digital_app.dart';

class AppDI {
  static late DigitalAppRepositoryImpl digitalAppRepository;
  static late AddDigitalApp addDigitalApp;

  static Future<void> init() async {
    final digitalAppBox =
        await Hive.openBox<DigitalAppModel>('digitalAppsBox');

    final localDataSource =
        DigitalAppLocalDataSourceImpl(digitalAppBox);

    digitalAppRepository =
        DigitalAppRepositoryImpl(localDataSource);

    addDigitalApp = AddDigitalApp(digitalAppRepository);
  }
}
