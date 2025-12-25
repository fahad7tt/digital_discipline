import 'package:flutter/material.dart';
import '../../../../core/widgets/modern_card.dart';

class TrendNote extends StatelessWidget {
  final bool isImproving;

  const TrendNote({super.key, required this.isImproving});

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      color: isImproving
          ? Colors.green.withOpacity(0.05)
          : Theme.of(context).colorScheme.surface,
      border: Border.all(
        color: isImproving
            ? Colors.green.withOpacity(0.2)
            : Theme.of(context).colorScheme.outlineVariant,
      ),
      child: Row(
        children: [
          Icon(
            isImproving
                ? Icons.trending_down_rounded
                : Icons.trending_flat_rounded,
            color: isImproving ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isImproving
                  ? 'Your usage is trending down compared to last week.'
                  : 'Your usage is steady. Awareness comes before change.',
              style: TextStyle(
                fontSize: 13,
                color: isImproving ? Colors.green[800] : Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
