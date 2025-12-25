// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../reflection/domain/entities/daily_reflection.dart';
import '../../../reflection/presentation/bloc/reflection_bloc.dart';
import '../../../../core/widgets/modern_card.dart';

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

        return ModernCard(
          gradientColors: isNewStreak
              ? [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ]
              : [
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  Theme.of(context).colorScheme.primary,
                ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Streak Section
              if (streak > 0) ...[
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '🔥',
                        style: TextStyle(fontSize: 28),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$streak Day Streak!',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _getStreakMessage(streak),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_shouldShowBadge(streak))
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getBadgeText(streak),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
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
                  const SizedBox(height: 20),
                  Divider(color: Colors.white.withOpacity(0.2), height: 1),
                  const SizedBox(height: 20),
                ],
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.track_changes_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Today\'s Focus',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            todaysFocus,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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
