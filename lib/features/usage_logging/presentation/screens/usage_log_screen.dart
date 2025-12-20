import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/usage_log.dart';
import '../bloc/usage_log_bloc.dart';
import 'package:uuid/uuid.dart';

class UsageLogScreen extends StatelessWidget {
  final String focusAppId;
  final String focusAppName;
  const UsageLogScreen({required this.focusAppId, required this.focusAppName, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UsageLogBloc(
          RepositoryProvider.of(context),
          RepositoryProvider.of(context))..add(LoadUsageLogs(focusAppId: focusAppId)),
      child: Scaffold(
        appBar: AppBar(title: Text('Usage Logs – $focusAppName')),
        body: BlocBuilder<UsageLogBloc, UsageLogState>(
          builder: (context, state) {
            if (state is UsageLogLoading) return const Center(child: CircularProgressIndicator());
            if (state is UsageLogLoaded) {
              final logs = state.logs;
              return ListView.builder(
                itemCount: logs.length,
                itemBuilder: (_, index) {
                  final log = logs[index];
                  return ListTile(
                    title: Text('${log.durationMinutes} min'),
                    subtitle: Text('Trigger: ${log.triggerType}'),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => _showAddDialog(context),
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final durationController = TextEditingController();
    String selectedTrigger = 'Habit';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Log Usage'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: durationController, decoration: const InputDecoration(labelText: 'Duration (min)'), keyboardType: TextInputType.number),
            DropdownButton<String>(
              value: selectedTrigger,
              items: ['Habit', 'Boredom', 'Stress', 'Custom'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => selectedTrigger = v!,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final log = UsageLog(
                id: const Uuid().v4(),
                focusAppId: focusAppId,
                durationMinutes: int.tryParse(durationController.text) ?? 10,
                triggerType: selectedTrigger,
                loggedAt: DateTime.now(),
              );
              context.read<UsageLogBloc>().add(AddUsageLogEvent(log));
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
