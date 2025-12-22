import 'package:digital_discipline/features/usage_logging/domain/entities/app_usage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/usage_log_bloc.dart';
import '../bloc/usage_log_event.dart';
import '../bloc/usage_log_state.dart';
import '../widgets/usage_detail_view.dart';
import '../widgets/usage_permission.dart';

class AppUsageDetailScreen extends StatelessWidget {
  final String packageName;
  final String appName;

  const AppUsageDetailScreen({
    required this.packageName,
    required this.appName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appName)),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<AppUsageBloc>().add(RefreshUsage());
        },
        child: BlocBuilder<AppUsageBloc, AppUsageState>(
          builder: (context, state) {
            if (state is AppUsageLoading) {
              return ListView(
                children: [
                  SizedBox(height: 300),
                  Center(child: CircularProgressIndicator()),
                ],
              );
            }

            if (state is AppUsagePermissionRequired) {
              return ListView(
                children: [
                  SizedBox(height: 300),
                  PermissionRequiredView(),
                ],
              );
            }

            if (state is AppUsageLoaded) {
              debugPrint('USAGE_DEBUG_UI → AppUsageLoaded received');

              // 🔍 Print all usages coming from bloc
              for (final u in state.usages) {
                debugPrint(
                  'USAGE_DEBUG_UI → usage: ${u.packageName} = ${u.minutesUsed} min',
                );
              }

              debugPrint(
                'USAGE_DEBUG_UI → Looking for packageName: "$packageName"',
              );

              final usage = state.usages.firstWhere(
                (u) => u.packageName == packageName,
                orElse: () {
                  debugPrint(
                    'USAGE_DEBUG_UI → ❌ Package NOT found, falling back to 0',
                  );
                  return AppUsage(
                    packageName: packageName,
                    appName: appName,
                    minutesUsed: 0,
                  );
                },
              );

              debugPrint(
                'USAGE_DEBUG_UI → ✅ Final UI value for $packageName: '
                '${usage.minutesUsed} min',
              );

              return ListView(
                children: [
                  UsageDetailView(minutes: usage.minutesUsed),
                ],
              );
            }

            return ListView(
              children: [SizedBox(height: 300)],
            );
          },
        ),
      ),
    );
  }
}
