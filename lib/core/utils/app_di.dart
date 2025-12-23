import 'package:hive/hive.dart';
import '../../features/digital_app/data/datasources/digital_app_local_datasource.dart';
import '../../features/digital_app/data/models/digital_app_model.dart';
import '../../features/digital_app/data/repositories/digital_app_repository_impl.dart';
import '../../features/digital_app/domain/usecases/add_digital_app.dart';
import '../../features/usage_logging/data/datasources/usage_log_local_datasource.dart';
import '../../features/usage_logging/data/repositories/usage_log_repository_impl.dart';
import '../../features/usage_logging/domain/repositories/usage_log_repo.dart';
import '../../features/stats/domain/usecases/calculate_discipline.dart';
import '../../features/stats/domain/usecases/weekly_summary.dart';
import '../../features/dashboard/domain/usecases/get_todays_insight.dart';
import '../../features/dashboard/domain/usecases/get_contextual_insight.dart';
import '../../features/reflection/data/datasources/reflection_local_datasource.dart';
import '../../features/reflection/data/repositories/reflection_repository_impl.dart';
import '../../features/reflection/domain/repositories/reflection_repository.dart';

class AppDI {
  // Digital apps
  static late DigitalAppRepositoryImpl digitalAppRepository;
  static late AddDigitalApp addDigitalApp;

  // Automatic usage tracking
  static late UsageRepository usageRepository;

  // Reflection
  static late ReflectionRepository reflectionRepository;

  // Stats & insights
  static late WeeklySummary weeklySummary;
  static late CalculateDailyDiscipline calculateDailyDiscipline;

  static late GetTodaysInsight getTodaysInsight;
  static late GetContextualInsight getContextualInsight;

  static Future<void> init() async {
    // ─────────────────────────────────────────────
    // Digital Apps
    // ─────────────────────────────────────────────
    final digitalAppBox = await Hive.openBox<DigitalAppModel>('digitalAppsBox');

    final digitalAppLocal = DigitalAppLocalDataSourceImpl(digitalAppBox);

    digitalAppRepository = DigitalAppRepositoryImpl(digitalAppLocal);

    addDigitalApp = AddDigitalApp(digitalAppRepository);

    // ─────────────────────────────────────────────
    // Automatic Usage Tracking (Android)
    // ─────────────────────────────────────────────
    final androidUsageDataSource = AndroidUsageDataSource();

    usageRepository = UsageRepositoryImpl(androidUsageDataSource);

    // ─────────────────────────────────────────────
    // Reflection
    // ─────────────────────────────────────────────
    final reflectionDatasource = ReflectionLocalDatasource();
    reflectionRepository = ReflectionRepositoryImpl(reflectionDatasource);

    // ─────────────────────────────────────────────
    // Stats & Insights
    // ─────────────────────────────────────────────
    weeklySummary = WeeklySummary();
    calculateDailyDiscipline = CalculateDailyDiscipline();

    getTodaysInsight = GetTodaysInsight();
    getContextualInsight = GetContextualInsight();
  }
}
