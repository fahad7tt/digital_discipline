import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/digital_app_bloc.dart';
import '../widgets/add_app_dialog.dart';
import '../../../../core/widgets/modern_card.dart';
import '../../../../core/utils/time_formatter.dart';

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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.auto_awesome_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Start Your Focused Journey',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Select the app that distracts you the most. We\'ll help you build a more intentional relationship with it.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                    const SizedBox(height: 30),
                    FilledButton.icon(
                      onPressed: () => _showAddAppDialog(context),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Add My First Intention'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3️⃣ DATA STATE - Show list of apps
          if (state is DigitalAppLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.apps.length,
              itemBuilder: (context, index) {
                return _AppIntentionCard(app: state.apps[index]);
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
              heroTag: 'hero_add_app',
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

class _AppIntentionCard extends StatelessWidget {
  final dynamic
      app; // Using dynamic here to match the local app model if needed, or specify DigitalAppModel

  const _AppIntentionCard({required this.app});

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.phone_iphone_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            title: Text(
              app.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onTertiary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            subtitle: Text(
              'Daily Limit: ${TimeFormatter.formatDuration(app.dailyLimitMinutes)}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            trailing: PopupMenuButton<String>(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              icon: const Icon(Icons.more_vert_rounded),
              onSelected: (value) {
                if (value == 'edit') {
                  showDialog(
                    context: context,
                    builder: (_) => AddAppDialog(existingApp: app),
                  );
                } else if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Remove Intention'),
                      content: Text('Stop tracking "${app.name}"?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(ctx).colorScheme.errorContainer,
                            foregroundColor: Theme.of(ctx).colorScheme.error,
                            elevation: 0,
                          ),
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
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 20),
                      SizedBox(width: 12),
                      Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline_rounded,
                          size: 20, color: Theme.of(context).colorScheme.error),
                      const SizedBox(width: 12),
                      Text('Delete',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
