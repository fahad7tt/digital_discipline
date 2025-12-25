// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../reflection/domain/entities/daily_reflection.dart';
import '../../../reflection/presentation/bloc/reflection_bloc.dart';

class ReflectionStreakCard extends StatelessWidget {
  const ReflectionStreakCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getStreakAndFocus(context),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data!;
        final streak = data['streak'] as int;
        final todaysFocus = data['focus'] as String?;

        if (streak == 0 && todaysFocus == null) {
          return const SizedBox.shrink();
        }

        final isNewStreak = streak >= 3;

        return Card(
          color: isNewStreak
              ? Theme.of(context).colorScheme.tertiaryContainer
              : Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Streak Section
                if (streak > 0) ...[
                  Row(
                    children: [
                      Text(
                        '🔥',
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$streak Day Streak!',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getStreakMessage(streak),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      if (_shouldShowBadge(streak))
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getBadgeText(streak),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],

                // Today's Focus Section
                if (todaysFocus != null) ...[
                  if (streak > 0) ...[
                    const SizedBox(height: 16),
                    Divider(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimaryContainer
                            .withOpacity(0.2)),
                    const SizedBox(height: 12),
                  ],
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🎯',
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today\'s Focus',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              todaysFocus,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> _getStreakAndFocus(BuildContext context) async {
    final repo = context.read<ReflectionBloc>().repository;

    final streak = await repo.calculateStreak();
    DailyReflection? yesterdayReflection;

    try {
      yesterdayReflection = await repo.getYesterdayReflection();
      print(
          'DEBUG: Yesterday reflection found: ${yesterdayReflection != null}');
      if (yesterdayReflection != null) {
        print(
            'DEBUG: Tomorrow intention: ${yesterdayReflection.tomorrowIntention}');
      }
    } catch (e) {
      print('DEBUG: Error getting yesterday reflection: $e');
    }

    // The "tomorrowIntention" from yesterday's reflection is TODAY's focus
    final todaysFocus = yesterdayReflection?.tomorrowIntention;

    return {
      'streak': streak,
      'focus': todaysFocus,
    };
  }

  String _getStreakMessage(int streak) {
    if (streak >= 30) return 'Incredible consistency! 🌟';
    if (streak >= 14) return 'Two weeks strong! 💪';
    if (streak >= 7) return 'One week milestone! 🎯';
    if (streak >= 3) return 'Building momentum! 🚀';
    return 'Keep it up!';
  }

  bool _shouldShowBadge(int streak) {
    return streak == 3 || streak == 7 || streak == 14 || streak == 30;
  }

  String _getBadgeText(int streak) {
    if (streak == 30) return '🏆 LEGEND';
    if (streak == 14) return '⭐ COMMITTED';
    if (streak == 7) return '🎯 FOCUSED';
    if (streak == 3) return '🚀 STARTED';
    return '';
  }
}
