import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../reflection/domain/entities/daily_reflection.dart';
import '../../../reflection/presentation/bloc/reflection_bloc.dart';

class YesterdayIntentionCard extends StatelessWidget {
  const YesterdayIntentionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DailyReflection?>(
      future:
          context.read<ReflectionBloc>().repository.getYesterdayReflection(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }

        final yesterdayReflection = snapshot.data!;

        return Card(
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Yesterday\'s Intention',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  yesterdayReflection.tomorrowIntention,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontStyle: FontStyle.italic,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'How did it go?',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer
                            .withValues(alpha: 0.7),
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
