// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_di.dart';
import 'features/digital_app/data/models/digital_app_model.dart';
import 'features/digital_app/presentation/bloc/digital_app_bloc.dart';
import 'features/onboarding/presentation/screens/splash_screen.dart';
import 'features/reflection/data/models/reflection_model.dart';
import 'features/reflection/presentation/bloc/reflection_bloc.dart';
import 'features/stats/presentation/bloc/stats_bloc.dart';
import 'features/usage_logging/data/models/usage_log_model.dart';
import 'features/usage_logging/domain/repositories/usage_log_repo.dart';
import 'features/usage_logging/presentation/bloc/usage_log_bloc.dart';
import 'features/usage_logging/presentation/bloc/usage_log_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(DigitalAppModelAdapter());
  Hive.registerAdapter(AppUsageModelAdapter());
  Hive.registerAdapter(ReflectionModelAdapter());

  await AppDI.init();

  // Initialize notification service
  try {
    await NotificationService().initialize();

    // Check if reflection is already completed for today
    final todayReflection =
        await AppDI.reflectionRepository.getTodayReflection();
    final isDone = todayReflection != null;

    if (isDone) {
      // If already done, schedule for tomorrow
      await NotificationService().scheduleEveningReminder(forceNextDay: true);
      print(
          '✅ Reflection already done for today. Reminder scheduled for tomorrow.');
    } else {
      // Not done yet, schedule for today (or tomorrow if after 9 PM)
      await NotificationService().scheduleEveningReminder();
      print('✅ Daily reflection reminder scheduled.');
    }
  } catch (e) {
    print('⚠️ Notification setup failed: $e');
  }

  runApp(const IntentApp());
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
          title: 'Intent – Digital Discipline',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
