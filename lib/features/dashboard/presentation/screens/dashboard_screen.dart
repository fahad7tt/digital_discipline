import 'package:digital_discipline/core/utils/app_di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/insight_rule.dart';
import '../../../digital_app/presentation/bloc/digital_app_bloc.dart';
import '../../../reflection/presentation/bloc/reflection_bloc.dart';
import '../../../usage_logging/domain/repositories/usage_log_repo.dart';
import '../../../usage_logging/presentation/bloc/usage_log_bloc.dart';
import '../../../usage_logging/presentation/bloc/usage_log_event.dart';

import '../widgets/contextual_insight_card.dart';
import '../widgets/reflection_insights_card.dart';
import '../widgets/reflection_prompt.dart';
import '../widgets/reflection_streak_card.dart';
import '../widgets/today_status_card.dart';
import '../../../settings/presentation/screens/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkFirstLaunch();
  }

  void _checkFirstLaunch() {
    final hasSeenWelcome =
        AppDI.settingsBox.get('has_seen_welcome', defaultValue: false);
    if (!hasSeenWelcome) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showWelcomeDialog();
      });
    }
  }

  void _showWelcomeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Welcome to Intent'),
        content: const Text(
          'Your journey to digital discipline starts here. Intent helps you monitor your app usage and stay mindful of your digital habits.\n\nSet your intentions, check your insights, and reflect daily to improve your focus.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              AppDI.settingsBox.put('has_seen_welcome', true);
              Navigator.pop(context);
            },
            child: const Text('Let\'s Start'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh data when app comes back to foreground (especially important for midnight rollover)
      context.read<ReflectionBloc>().add(LoadTodayReflection());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intent'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<DigitalAppBloc>().add(LoadDigitalApps());
          context.read<ReflectionBloc>().add(LoadTodayReflection());
          context.read<AppUsageBloc>().add(LoadTodayUsage());
          // Optional: slight delay for smooth animation
          await Future.delayed(const Duration(milliseconds: 600));
        },
        child: BlocBuilder<DigitalAppBloc, DigitalAppState>(
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                // Streak Counter with Today's Focus
                const ReflectionStreakCard(),
                const SizedBox(height: 16),

                TodayStatusCard(),
                const SizedBox(height: 16),

                _buildInsightSection(context, state),

                // Reflection Insights
                const ReflectionInsightsCard(),
                ReflectionPrompt(),
                const SizedBox(height: 24),
                _buildFeedbackCard(),
                const SizedBox(height: 32),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeedbackCard() {
    return Card(
      elevation: 0,
      color: Theme.of(context)
          .colorScheme
          .secondaryContainer
          .withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.rate_review_outlined,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Help us improve!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'As a closed tester, your feedback is crucial. Please let us know what you think on the Play Store.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // Link to Play Store feedback (placeholder for now)
                  // In actual production this would open the Play Store listing
                  // For closed testing, we can guide them to provide feedback via the Play Store app
                  // Or use the email intent as a fallback.
                  _openFeedback();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                  side: BorderSide(
                      color: Theme.of(context).colorScheme.secondary),
                ),
                child: const Text('Provide Feedback on Play Store'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFeedback() {
    // Placeholder logic - users can provide feedback via Play Console/Play Store app during closed testing.
    // We provide a Snackbar or open the Play Store link if available.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Redirecting to Play Store feedback section...'),
      ),
    );
  }

  Widget _buildInsightSection(
    BuildContext context,
    DigitalAppState state,
  ) {
    if (state is! DigitalAppLoaded || state.apps.isEmpty) {
      return _buildFallbackInsight();
    }

    return _buildContextualInsights(context, state.apps);
  }

  Widget _buildContextualInsights(
    BuildContext context,
    List apps,
  ) {
    final usageRepository = RepositoryProvider.of<UsageRepository>(context);

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

    final highestUsage =
        usages.map((u) => u.minutesUsed).reduce((a, b) => a > b ? a : b);

    if (highestUsage >= 15) {
      return AppDI.getContextualInsight(highestUsage);
    }

    return null;
  }

  Widget _buildFallbackInsight() {
    final researchInsight = AppDI.getTodaysInsight();
    final adaptedRule = InsightRule(
      minMinutes: 0,
      insightText: researchInsight.description,
      category: 'daily_wisdom',
    );

    return Column(
      children: [
        ContextualInsightCard(insight: adaptedRule),
        const SizedBox(height: 16),
      ],
    );
  }
}
