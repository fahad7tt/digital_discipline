import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/app_usage.dart';
import '../bloc/usage_log_bloc.dart';
import '../bloc/usage_log_event.dart';
import '../bloc/usage_log_state.dart';
import '../widgets/usage_permission.dart';
import '../../../../core/widgets/modern_card.dart';
import '../../../../core/utils/time_formatter.dart';

class UsageOverviewScreen extends StatelessWidget {
  const UsageOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usage')),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<AppUsageBloc>().add(RefreshUsage());
        },
        child: BlocBuilder<AppUsageBloc, AppUsageState>(
          builder: (context, state) {
            if (state is AppUsageLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AppUsagePermissionRequired) {
              return Padding(
                padding: const EdgeInsets.only(top: 100),
                child: PermissionRequiredView(),
              );
            }

            if (state is AppUsageLoaded) {
              final usages = state.usages.where(_isUserApp).toList()
                ..sort(
                  (a, b) => b.minutesUsed.compareTo(a.minutesUsed),
                );

              final totalMinutes =
                  usages.fold<int>(0, (s, u) => s + u.minutesUsed);

              if (usages.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history_toggle_off_rounded,
                          size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        'No usage yet today',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _TotalUsageCard(totalMinutes),
                  const SizedBox(height: 12),
                  const _MindfulnessNote(),
                  const SizedBox(height: 24),
                  Text(
                    'App Breakdown',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  const SizedBox(height: 8),
                  ...usages.map((usage) => _UsageTile(usage)),
                  const SizedBox(height: 20),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  bool _isUserApp(AppUsage u) {
    return !u.packageName.contains('launcher') &&
        !u.packageName.contains('systemui') &&
        !u.packageName.startsWith('com.android');
  }
}

class _TotalUsageCard extends StatelessWidget {
  final int minutes;

  const _TotalUsageCard(this.minutes);

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      gradientColors: [
        Theme.of(context).colorScheme.primary,
        Theme.of(context).colorScheme.secondary
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.query_stats_rounded,
                  color: Colors.white.withValues(alpha: 0.8), size: 20),
              const SizedBox(width: 8),
              Text(
                'Today\'s Activity',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            TimeFormatter.formatDuration(minutes),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 29,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Keep it intentional',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _UsageTile extends StatelessWidget {
  final AppUsage usage;

  const _UsageTile(this.usage);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          usage.appName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            TimeFormatter.formatDuration(usage.minutesUsed),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _MindfulnessNote extends StatelessWidget {
  const _MindfulnessNote();

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.surface,
      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Mindfulness Note',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Usage is tracked automatically to help you build awareness. This is not a goal to "beat," but data to help you stay intentional with your digital life.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}
