import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../reflection/presentation/bloc/reflection_bloc.dart';
import '../../../reflection/presentation/screens/reflection_screen.dart';
import '../../../reflection/presentation/screens/weekly_reflection_screen.dart';

import '../../../../core/widgets/modern_card.dart';

class ReflectionPrompt extends StatelessWidget {
  const ReflectionPrompt({super.key});

  bool _isWithinAllowedTime() {
    final now = DateTime.now();
    final hour = now.hour;
    // Allow between 8 PM (20:00) and 12 AM (23:59)
    return hour >= 20 && hour < 24;
  }

  String _getTimeUntilAvailable() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour < 20) {
      // Before 8 PM today
      final hoursUntil = 20 - hour;
      return 'Available in $hoursUntil hrs';
    } else {
      // After midnight, available at 8 PM tomorrow
      final hoursUntil = 24 - hour + 20;
      return 'Available in $hoursUntil hrs';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReflectionBloc, ReflectionState>(
      builder: (context, state) {
        final hasReflection = state is ReflectionLoaded && state.hasReflection;
        final reflection = hasReflection ? state.reflection : null;

        // Ensure the reflection is actually for TODAY
        final isReflectionForToday = reflection?.isToday() ?? false;
        final effectiveHasReflection = hasReflection && isReflectionForToday;

        final isAllowed = _isWithinAllowedTime();

        return ModernCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Reflection',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontSize: 18,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            effectiveHasReflection
                                ? 'Completed ${reflection?.moodEmoji ?? ''}'
                                : (isAllowed
                                    ? 'How did today feel?'
                                    : _getTimeUntilAvailable()),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.calendar_month_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<ReflectionBloc>(),
                              child: const WeeklyReflectionScreen(),
                            ),
                          ),
                        );
                      },
                      tooltip: 'View Weekly Summary',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: effectiveHasReflection
                    ? null
                    : (!isAllowed
                        ? () {}
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<ReflectionBloc>(),
                                  child: const ReflectionScreen(),
                                ),
                              ),
                            );
                          }),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: effectiveHasReflection
                        ? Colors.green.withOpacity(0.1)
                        : (isAllowed
                            ? Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.05)
                            : Theme.of(context).colorScheme.surface),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: effectiveHasReflection
                          ? Colors.green.withOpacity(0.2)
                          : (isAllowed
                              ? Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1)
                              : Theme.of(context).colorScheme.outlineVariant),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        effectiveHasReflection
                            ? Icons.check_circle_rounded
                            : (isAllowed
                                ? Icons.add_circle_outline_rounded
                                : Icons.lock_outline_rounded),
                        color: effectiveHasReflection
                            ? Colors.green
                            : (isAllowed
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        effectiveHasReflection
                            ? 'All done for today!'
                            : (isAllowed
                                ? 'Start Reflection'
                                : 'Locked until 8 PM'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: effectiveHasReflection
                              ? Colors.green[700]
                              : (isAllowed
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey[700]),
                        ),
                      ),
                      const Spacer(),
                      if (isAllowed && !effectiveHasReflection)
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 16),
                child: Text(
                  'Availability: 8 PM - 12 AM',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
