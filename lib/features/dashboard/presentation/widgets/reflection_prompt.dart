import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../reflection/presentation/bloc/reflection_bloc.dart';
import '../../../reflection/presentation/screens/reflection_screen.dart';
import '../../../reflection/presentation/screens/weekly_reflection_screen.dart';

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
      return 'Available in ${hoursUntil}h';
    } else {
      // After midnight, available at 8 PM tomorrow
      final hoursUntil = 24 - hour + 20;
      return 'Available in ${hoursUntil}h';
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              child: Text(
                'Daily reflection is available between 8 PM - 12 AM',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ),
            Card(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: ListTile(
                leading: Icon(
                  effectiveHasReflection
                      ? Icons.check_circle
                      : (isAllowed ? Icons.edit_note : Icons.lock_clock),
                  color: effectiveHasReflection
                      ? Colors.green
                      : (isAllowed ? null : Colors.grey),
                ),
                title: const Text('Daily Reflection'),
                subtitle: Text(
                  effectiveHasReflection
                      ? 'Completed ${reflection?.moodEmoji ?? ''}'
                      : (isAllowed
                          ? 'How did today feel?'
                          : '${_getTimeUntilAvailable()} (8 PM - 12 AM)'),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasReflection)
                      IconButton(
                        icon: const Icon(Icons.calendar_month),
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
                    const Icon(Icons.chevron_right),
                  ],
                ),
                onTap: effectiveHasReflection
                    ? null // Disable tap when already completed
                    : (!isAllowed
                        ? () {
                            // Show dialog when tapped outside allowed time
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Reflection Time'),
                                content: Text(
                                  'Daily reflection is available between 8 PM and 12 AM.\n\n${_getTimeUntilAvailable()}',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
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
              ),
            ),
          ],
        );
      },
    );
  }
}
