import 'package:flutter/material.dart';
import '../widgets/app_summary.dart';
import '../widgets/reflection_prompt.dart';
import '../widgets/today_status_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Intent')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TodayStatusCard(),
            const SizedBox(height: 16),
            AppSummary(),
            const SizedBox(height: 16),
            ReflectionPrompt(),
          ],
        ),
      ),
    );
  }
}
