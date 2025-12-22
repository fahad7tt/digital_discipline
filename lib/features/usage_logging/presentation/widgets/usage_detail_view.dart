import 'package:flutter/material.dart';

class UsageDetailView extends StatelessWidget {
  final int minutes;

  const UsageDetailView({super.key, required this.minutes});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '$minutes minutes spent',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          const Text(
            'Usage is tracked automatically.\nThis is not a goal, just awareness.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
