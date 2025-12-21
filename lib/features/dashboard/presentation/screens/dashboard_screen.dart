import 'package:digital_discipline/core/utils/app_di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../digital_app/presentation/bloc/digital_app_bloc.dart';
import '../../../usage_logging/domain/repositories/usage_log_repo.dart';
import '../widgets/app_summary.dart';
import '../widgets/contextual_insight_card.dart';
import '../widgets/reflection_prompt.dart';
import '../widgets/today_status_card.dart';
import '../widgets/todays_insight_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Intent')),
      body: BlocBuilder<DigitalAppBloc, DigitalAppState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                TodayStatusCard(),
                const SizedBox(height: 16),
                AppSummary(),
                const SizedBox(height: 16),
                TodaysInsightCard(insight: AppDI.getTodaysInsight()),
                const SizedBox(height: 16),
                // Show contextual insight if user has exceeded any threshold
                if (state is DigitalAppLoaded && state.apps.isNotEmpty)
                  _buildContextualInsights(context, state.apps),
                ReflectionPrompt(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContextualInsights(
    BuildContext context,
    List apps,
  ) {
    final usageLogRepository = RepositoryProvider.of<UsageLogRepository>(context);

    return FutureBuilder(
      future: _getHighestUsageInsight(usageLogRepository, apps),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        if (snapshot.hasData && snapshot.data != null) {
          return Column(
            children: [
              ContextualInsightCard(insight: snapshot.data!),
              const SizedBox(height: 16),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Future _getHighestUsageInsight(
    UsageLogRepository repo,
    List apps,
  ) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);

    // Find the app with highest usage today
    var highestDuration = 0;

    for (final app in apps) {
      final logs = await repo.getLogsForApp(app.id);
      final todayLogs =
          logs.where((l) => l.loggedAt.isAfter(startOfDay)).toList();
      final totalToday =
          todayLogs.fold<int>(0, (sum, log) => sum + log.durationMinutes);

      if (totalToday > highestDuration) {
        highestDuration = totalToday;
      }
    }

    // Get contextual insight for highest usage
    if (highestDuration >= 15) {
      return AppDI.getContextualInsight(highestDuration);
    }

    return null;
  }
}
