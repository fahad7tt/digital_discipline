import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/app_usage.dart';
import '../bloc/usage_log_bloc.dart';
import '../bloc/usage_log_event.dart';
import '../bloc/usage_log_state.dart';
import '../widgets/usage_permission.dart';
import 'usage_log_screen.dart';

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
              final usages = state.usages
                  .where(_isUserApp)
                  .toList()
                ..sort(
                  (a, b) => b.minutesUsed.compareTo(a.minutesUsed),
                );

              final totalMinutes =
                  usages.fold<int>(0, (s, u) => s + u.minutesUsed);

              if (usages.isEmpty) {
                return ListView(
                  children: [
                    SizedBox(height: 300),
                    Center(
                      child: Text(
                        'No usage yet today',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                );
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _TotalUsageCard(totalMinutes),
                  const SizedBox(height: 16),
                  ...usages.map((usage) => _UsageTile(usage)),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Today'),
            Text(
              '$minutes min',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UsageTile extends StatelessWidget {
  final AppUsage usage;

  const _UsageTile(this.usage);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(usage.appName),
      trailing: Text('${usage.minutesUsed} min'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AppUsageDetailScreen(
              packageName: usage.packageName,
              appName: usage.appName,
            ),
          ),
        );
      },
    );
  }
}
