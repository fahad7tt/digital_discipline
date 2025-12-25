import 'package:flutter/material.dart';
import '../../domain/entities/research_insight.dart';
import '../../../../core/widgets/modern_card.dart';

class TodaysInsightCard extends StatelessWidget {
  final ResearchInsight insight;

  const TodaysInsightCard({required this.insight, super.key});

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      color: Theme.of(context).colorScheme.surface,
      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.amber,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Daily Wisdom',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            insight.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.menu_book_rounded,
                  size: 14, color: Theme.of(context).colorScheme.outline),
              const SizedBox(width: 8),
              Text(
                '${insight.source} (${insight.year})',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
