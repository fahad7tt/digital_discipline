import 'package:flutter/material.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insights')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('This Week', style: TextStyle(fontSize: 18)),
            SizedBox(height: 12),
            Text('• Most common trigger: Boredom'),
            Text('• Average daily usage: 42 minutes'),
            Text('• Best day: Wednesday'),
          ],
        ),
      ),
    );
  }
}
