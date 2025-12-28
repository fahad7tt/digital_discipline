// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_di.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'features/digital_app/data/models/digital_app_model.dart';
import 'features/digital_app/presentation/bloc/digital_app_bloc.dart';
import 'features/reflection/data/models/reflection_model.dart';
import 'features/reflection/presentation/bloc/reflection_bloc.dart';
import 'features/stats/presentation/bloc/stats_bloc.dart';
import 'features/usage_logging/data/models/usage_log_model.dart';
import 'features/usage_logging/domain/repositories/usage_log_repo.dart';
import 'features/usage_logging/presentation/bloc/usage_log_bloc.dart';
import 'features/usage_logging/presentation/bloc/usage_log_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Core background services needed for immediate UI rendering
  await Hive.initFlutter();
  Hive.registerAdapter(DigitalAppModelAdapter());
  Hive.registerAdapter(AppUsageModelAdapter());
  Hive.registerAdapter(ReflectionModelAdapter());

  await AppDI.init();

  runApp(const IntentApp());

  // Non-blocking background initialization
  _initializeBackgroundServices();
}

/// Tasks that don't need to block the first frame of the app
Future<void> _initializeBackgroundServices() async {
  try {
    await NotificationService().initialize();

    final todayReflection =
        await AppDI.reflectionRepository.getTodayReflection();
    final isDone = todayReflection != null;

    if (isDone) {
      await NotificationService().scheduleEveningReminder(forceNextDay: true);
    } else {
      await NotificationService().scheduleEveningReminder();
    }
  } catch (e) {
    debugPrint('⚠️ Background initialization failed: $e');
  }
}

class IntentApp extends StatelessWidget {
  const IntentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UsageRepository>.value(
          value: AppDI.usageRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
                AppUsageBloc(AppDI.usageRepository)..add(LoadTodayUsage()),
          ),
          BlocProvider(
            create: (_) => DigitalAppBloc(
              AppDI.addDigitalApp,
              AppDI.digitalAppRepository,
            )..add(LoadDigitalApps()),
          ),
          BlocProvider(
            create: (_) => StatsBloc(
              AppDI.usageRepository,
              AppDI.weeklySummary,
              AppDI.calculateDailyDiscipline,
            ),
          ),
          BlocProvider(
            create: (_) => ReflectionBloc(AppDI.reflectionRepository)
              ..add(LoadTodayReflection()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Intent',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const DashboardScreen(),
        ),
      ),
    );
  }
}
