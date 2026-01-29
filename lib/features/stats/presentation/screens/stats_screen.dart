import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/stats_bloc.dart';
import '../widgets/error_view.dart';
import '../widgets/stat_tile.dart';
import '../widgets/trend_note.dart';
import '../../../../core/widgets/modern_card.dart';
import '../../../../core/utils/time_formatter.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StatsBloc>().add(const LoadStats());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: BlocBuilder<StatsBloc, StatsState>(
        builder: (context, state) {
          if (state is StatsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StatsError) {
            return ErrorView(
              message: state.message,
              onRetry: () {
                context.read<StatsBloc>().add(const LoadStats());
              },
            );
          }

          if (state is StatsLoaded) {
            if (state.totalMinutesThisWeek == 0) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bar_chart_rounded,
                        size: 64,
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'No Data Yet',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Keep using your intended apps to see your progress here. Data usually appears after a few minutes of usage.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<StatsBloc>().add(const LoadStats());
              },
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    'Weekly Performance',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _TotalThisWeekCard(
                    totalMinutes: state.totalMinutesThisWeek,
                    dailyBreakdown: state.dailyBreakdown,
                  ),
                  const SizedBox(height: 16),
                  StatTile(
                    label: 'Daily Average',
                    value:
                        TimeFormatter.formatDuration(state.averageDailyUsage),
                    icon: Icons.speed_rounded,
                  ),
                  const SizedBox(height: 16),
                  TrendNote(isImproving: state.isImproving),
                  const SizedBox(height: 32),
                ],
              ),
            );
          }

          return Center(
            child: Text(
              'Waiting for data...',
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
            ),
          );
        },
      ),
    );
  }
}

class _TotalThisWeekCard extends StatelessWidget {
  final int totalMinutes;
  final List<Map<String, dynamic>> dailyBreakdown;

  const _TotalThisWeekCard({
    required this.totalMinutes,
    required this.dailyBreakdown,
  });

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'This Week',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        TimeFormatter.formatDuration(totalMinutes),
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.date_range_rounded,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text(
                'Daily Breakdown',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              children: [
                ...dailyBreakdown.map((dayData) {
                  final day = dayData['day'] as String;
                  final minutes = dayData['minutes'] as int?;
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(day,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.outline)),
                        Text(
                          minutes == null
                              ? '-'
                              : TimeFormatter.formatDuration(minutes),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
