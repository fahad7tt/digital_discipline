import 'package:flutter/material.dart';
import '../../domain/entities/insight_rule.dart';

class ContextualInsightCard extends StatelessWidget {
  final InsightRule insight;

  const ContextualInsightCard({required this.insight, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon(
                //   Icons.lightbulb,
                //   color: Colors.blue[600],
                //   size: 20,
                // ),
                // const SizedBox(width: 8),
                Text(
                  '💡 Reflection',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              insight.insightText,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
