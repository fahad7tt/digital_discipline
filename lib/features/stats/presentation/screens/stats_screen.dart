import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/stats_bloc.dart';
import '../widgets/error_view.dart';
import '../widgets/stat_tile.dart';
import '../widgets/trend_note.dart';

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
      appBar: AppBar(title: const Text('Usage')),
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
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'This Week',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _TotalThisWeekCard(
                    totalMinutes: state.totalMinutesThisWeek,
                    dailyBreakdown: state.dailyBreakdown,
                  ),
                  const SizedBox(height: 12),
                  StatTile(
                    label: 'Average per day',
                    value: '${state.averageDailyUsage} min/day',
                  ),
                  const SizedBox(height: 24),
                  TrendNote(isImproving: state.isImproving),
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
    return Card(
      elevation: 0,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: ExpansionTile(
        title: const Text('Total Usage'),
        subtitle: Text(
          _formatDuration(totalMinutes),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: dailyBreakdown.map((dayData) {
          final day = dayData['day'] as String;
          final minutes = dayData['minutes'] as int?;
          return ListTile(
            title: Text(day),
            trailing: Text(minutes == null ? '-' : _formatDuration(minutes)),
          );
        }).toList(),
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
