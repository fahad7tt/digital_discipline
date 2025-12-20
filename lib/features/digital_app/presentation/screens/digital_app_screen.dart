import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/digital_app_bloc.dart';
import '../widgets/add_app_dialog.dart';

class DigitalAppScreen extends StatefulWidget {
  const DigitalAppScreen({super.key});

  @override
  State<DigitalAppScreen> createState() => _DigitalAppScreenState();
}

class _DigitalAppScreenState extends State<DigitalAppScreen> {
  @override
  void initState() {
    super.initState();
    // Load apps when screen opens
    context.read<DigitalAppBloc>().add(LoadDigitalApps());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Digital Intentions'),
      ),
      body: BlocBuilder<DigitalAppBloc, DigitalAppState>(
        builder: (context, state) {
          // 1️⃣ Loading state
          if (state is DigitalAppLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 2️⃣ EMPTY STATE - Show message + button to add first app
          if (state is DigitalAppLoaded && state.apps.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.apps,
                      size: 80,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Choose one app you want to be more intentional with.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () => _showAddAppDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add First App'),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3️⃣ DATA STATE - Show list of apps
          if (state is DigitalAppLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: state.apps.length,
              itemBuilder: (context, index) {
                final app = state.apps[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.phone_iphone),
                    title: Text(app.name),
                    subtitle: Text(
                      'Daily limit: ${app.dailyLimitMinutes} minutes',
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          showDialog(
                            context: context,
                            builder: (_) => AddAppDialog(existingApp: app),
                          );
                        } else if (value == 'delete') {
                          // confirm before deleting
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete App'),
                              content: Text('Delete "${app.name}"?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<DigitalAppBloc>()
                                        .add(DeleteDigitalAppEvent(app.id));
                                    Navigator.pop(ctx);
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        const PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          // 4️⃣ ERROR STATE
          if (state is DigitalAppError) {
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
                      context.read<DigitalAppBloc>().add(LoadDigitalApps());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // 5️⃣ FALLBACK
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: BlocBuilder<DigitalAppBloc, DigitalAppState>(
        builder: (context, state) {
          if (state is DigitalAppLoaded && state.apps.isNotEmpty) {
            return FloatingActionButton(
              onPressed: () => _showAddAppDialog(context),
              tooltip: 'Add App',
              child: const Icon(Icons.add),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showAddAppDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddAppDialog(),
    );
  }
}
