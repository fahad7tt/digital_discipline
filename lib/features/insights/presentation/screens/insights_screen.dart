import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/insights_bloc.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<InsightsBloc>().add(const LoadInsights());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insights')),
      body: BlocBuilder<InsightsBloc, InsightsState>(
        builder: (context, state) {
          // Loading state
          if (state is InsightsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
          if (state is InsightsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<InsightsBloc>().add(const LoadInsights());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Loaded state
          if (state is InsightsLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<InsightsBloc>().add(const LoadInsights());
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'This Week',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Usage',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                '${state.totalMinutesThisWeek} min',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Average Daily',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                '${state.averageDailyUsage} min/day',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Most Common Trigger',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                state.mostCommonTrigger,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Logs Recorded',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                '${state.logCount}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (state.logCount == 0)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(Icons.show_chart, size: 48, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            const Text(
                              'No usage logs yet',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Start logging your app usage to see insights',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          }

          // Initial state
          return const Center(child: Text('No data'));
        },
      ),
    );
  }
}
