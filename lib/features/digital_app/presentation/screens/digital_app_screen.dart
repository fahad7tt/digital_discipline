import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/digital_app.dart';
import '../bloc/digital_app_bloc.dart';
import 'package:uuid/uuid.dart';

class DigitalAppScreen extends StatelessWidget {
  const DigitalAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Focus Apps')),
      body: BlocBuilder<DigitalAppBloc, DigitalAppState>(
        builder: (context, state) {
          if (state is DigitalAppLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DigitalAppLoaded) {
            final apps = state.apps;
            return ListView.builder(
              itemCount: apps.length,
              itemBuilder: (_, index) => ListTile(
                title: Text(apps[index].name),
                subtitle: Text('Limit: ${apps[index].dailyLimitMinutes} min'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    context.read<DigitalAppBloc>().add(DeleteDigitalAppEvent(apps[index].id));
                  },
                ),
              ),
            );
          } else if (state is DigitalAppError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddDialog(context),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    final limitController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Focus App'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'App Name')),
            TextField(controller: limitController, decoration: const InputDecoration(labelText: 'Daily Limit (min)'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final id = const Uuid().v4();
              final name = nameController.text;
              final limit = int.tryParse(limitController.text) ?? 30;
              final app = DigitalApp(id: id, name: name, dailyLimitMinutes: limit, createdAt: DateTime.now());
              context.read<DigitalAppBloc>().add(AddDigitalAppEvent(app));
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
