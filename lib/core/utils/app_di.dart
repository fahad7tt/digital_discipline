import 'package:hive/hive.dart';
import '../../features/digital_app/data/datasources/digital_app_local_datasource.dart';
import '../../features/digital_app/data/models/digital_app_model.dart';
import '../../features/digital_app/data/repositories/digital_app_repository_impl.dart';
import '../../features/digital_app/domain/usecases/add_digital_app.dart';
import '../../features/usage_logging/data/datasources/usage_log_local_datasource.dart';
import '../../features/usage_logging/data/models/usage_log_model.dart';
import '../../features/usage_logging/data/repositories/usage_log_repository_impl.dart';
import '../../features/usage_logging/domain/usecases/add_usage_log.dart';
import '../../features/stats/domain/usecases/calculate_discipline.dart';
import '../../features/stats/domain/usecases/weekly_summary.dart';
import '../../features/dashboard/domain/usecases/get_todays_insight.dart';
import '../../features/dashboard/domain/usecases/get_contextual_insight.dart';

class AppDI {
  static late DigitalAppRepositoryImpl digitalAppRepository;
  static late AddDigitalApp addDigitalApp;
  static late UsageLogRepositoryImpl usageLogRepository;
  static late AddUsageLog addUsageLog;
  static late WeeklySummary weeklySummary;
  static late CalculateDailyDiscipline calculateDailyDiscipline;
  static late GetTodaysInsight getTodaysInsight;
  static late GetContextualInsight getContextualInsight;

  static Future<void> init() async {
    final digitalAppBox =
        await Hive.openBox<DigitalAppModel>('digitalAppsBox');

    final localDataSource =
        DigitalAppLocalDataSourceImpl(digitalAppBox);

    digitalAppRepository =
        DigitalAppRepositoryImpl(localDataSource);

    addDigitalApp = AddDigitalApp(digitalAppRepository);

    // Usage logs box & DI
    final usageLogBox = await Hive.openBox<UsageLogModel>('usageLogsBox');
    final usageLocal = UsageLogLocalDataSourceImpl(usageLogBox);
    usageLogRepository = UsageLogRepositoryImpl(usageLocal);
    addUsageLog = AddUsageLog(usageLogRepository);

    // Insights usecases
    weeklySummary = WeeklySummary();
    calculateDailyDiscipline = CalculateDailyDiscipline();

    // Dashboard insights
    getTodaysInsight = GetTodaysInsight();
    getContextualInsight = GetContextualInsight();
  }
}
