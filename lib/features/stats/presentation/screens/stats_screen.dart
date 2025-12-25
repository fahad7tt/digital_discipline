import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/stats_bloc.dart';
import '../widgets/error_view.dart';
import '../widgets/stat_tile.dart';
import '../widgets/trend_note.dart';
import '../../../../core/widgets/modern_card.dart';

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
                    value: '${state.averageDailyUsage} min',
                    icon: Icons.speed_rounded,
                  ),
                  const SizedBox(height: 16),
                  TrendNote(isImproving: state.isImproving),
                  const SizedBox(height: 32),
                ],
              ),
            );
          }

          return const SizedBox();
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
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDuration(totalMinutes),
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
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
                    color: Theme.of(context).colorScheme.primary,
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
                          minutes == null ? '-' : _formatDuration(minutes),
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

String _formatDuration(int totalMinutes) {
  if (totalMinutes < 60) {
    return '$totalMinutes min';
  } else {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (minutes == 0) {
      return '$hours hr';
    }
    return '$hours hr $minutes min';
  }
}
