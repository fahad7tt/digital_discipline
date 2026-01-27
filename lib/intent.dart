import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_di.dart';
import 'features/digital_app/presentation/bloc/digital_app_bloc.dart';
import 'features/navigation/root_screen.dart';
import 'features/reflection/presentation/bloc/reflection_bloc.dart';
import 'features/stats/presentation/bloc/stats_bloc.dart';
import 'features/usage_logging/domain/repositories/usage_log_repo.dart';
import 'features/usage_logging/presentation/bloc/usage_log_bloc.dart';
import 'features/usage_logging/presentation/bloc/usage_log_event.dart';

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
          home: const RootScreen(),
        ),
      ),
    );
  }
}
