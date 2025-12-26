import 'package:flutter/material.dart';
import '../../domain/entities/insight_rule.dart';

import '../../../../core/widgets/modern_card.dart';

class ContextualInsightCard extends StatelessWidget {
  final InsightRule insight;

  const ContextualInsightCard({required this.insight, super.key});

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      color:
          Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
      border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lightbulb_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Insight',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            insight.insightText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
