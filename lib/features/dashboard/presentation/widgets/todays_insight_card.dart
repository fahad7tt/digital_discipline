import 'package:flutter/material.dart';
import '../../domain/entities/research_insight.dart';

class TodaysInsightCard extends StatelessWidget {
  final ResearchInsight insight;

  const TodaysInsightCard({required this.insight, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Colors.amber[600],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Did you know?',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              insight.description,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${insight.source} (${insight.year})',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
