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
                // TodaysInsightCard(insight: AppDI.getTodaysInsight()),
                // const SizedBox(height: 16),

                // 🔥 SINGLE insight logic
                // _buildInsightSection(context, state),

                if (state is DigitalAppLoaded && state.apps.isNotEmpty)
                  _buildContextualInsights(context, state.apps),

//                   // 🔹 Fallback insight (always rendered once)
// if (state is! DigitalAppLoaded ||
//     state.apps.isEmpty)
//   _buildFallbackInsight(),

                ReflectionPrompt(),
              ],
            ),
          );
        },
      ),
    );
  }

//   Widget _buildInsightSection(
//   BuildContext context,
//   DigitalAppState state,
// ) {
//   if (state is! DigitalAppLoaded || state.apps.isEmpty) {
//     return _buildFallbackInsight();
//   }

//   return _buildContextualInsights(context, state.apps);
// }

  Widget _buildContextualInsights(
    BuildContext context,
    List apps,
  ) {
    final usageRepository =
        RepositoryProvider.of<UsageRepository>(context);

    return FutureBuilder(
      future: _getHighestUsageInsight(usageRepository),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        // ✅ Contextual insight available
        if (snapshot.hasData && snapshot.data != null) {
          return Column(
            children: [
              ContextualInsightCard(insight: snapshot.data!),
              const SizedBox(height: 16),
            ],
          );
        }

        // ✅ FALLBACK when usage is 0 or below threshold
        return _buildFallbackInsight();
      },
    );
  }

  Future _getHighestUsageInsight(
  UsageRepository repo,
) async {
  final usages = await repo.getTodayUsage();

  if (usages.isEmpty) return null;

  final highestUsage = usages
      .map((u) => u.minutesUsed)
      .reduce((a, b) => a > b ? a : b);

  if (highestUsage >= 15) {
    return AppDI.getContextualInsight(highestUsage);
  }

  return null;
}

  Widget _buildFallbackInsight() {
    return Column(
      children: [
        TodaysInsightCard(insight: AppDI.getTodaysInsight()),
        const SizedBox(height: 16),
      ],
    );
  }
}
