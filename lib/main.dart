import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_di.dart';
import 'features/digital_app/data/models/digital_app_model.dart';
import 'features/digital_app/presentation/bloc/digital_app_bloc.dart';
import 'features/insights/presentation/bloc/insights_bloc.dart';
import 'features/navigation/root_screen.dart';
import 'features/usage_logging/data/models/usage_log_model.dart';
import 'features/usage_logging/domain/repositories/usage_log_repo.dart';
import 'features/usage_logging/domain/usecases/add_usage_log.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(DigitalAppModelAdapter());
  Hive.registerAdapter(UsageLogModelAdapter());

  await AppDI.init();

  runApp(const IntentApp());
}

class IntentApp extends StatelessWidget {
  const IntentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UsageLogRepository>.value(value: AppDI.usageLogRepository),
        RepositoryProvider<AddUsageLog>.value(value: AppDI.addUsageLog),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => DigitalAppBloc(
              AppDI.addDigitalApp,
              AppDI.digitalAppRepository,
            )..add(LoadDigitalApps()),
          ),
          BlocProvider(
            create: (_) => InsightsBloc(
              AppDI.usageLogRepository,
              AppDI.weeklySummary,
              AppDI.calculateDailyDiscipline,
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Intent – Digital Discipline',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const RootScreen(),
        ),
      ),
    );
  }
}
