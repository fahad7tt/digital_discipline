import 'package:flutter/material.dart';

class ReflectionPrompt extends StatelessWidget {
  const ReflectionPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: ListTile(
        title: const Text('Daily Reflection'),
        subtitle: const Text('How did today feel?'),
        trailing: const Icon(Icons.edit),
        onTap: () {
          // Navigate to reflection page
        },
      ),
    );
  }
}
