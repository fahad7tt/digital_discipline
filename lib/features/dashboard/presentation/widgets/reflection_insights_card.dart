import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../reflection/presentation/bloc/reflection_bloc.dart';
import '../../../usage_logging/domain/repositories/usage_log_repo.dart';

import '../../../../core/widgets/modern_card.dart';

class ReflectionInsightsCard extends StatelessWidget {
  const ReflectionInsightsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _generateInsight(context),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }

        final insight = snapshot.data as Map<String, dynamic>;

        return ModernCard(
          color: Theme.of(context)
              .colorScheme
              .secondaryContainer
              .withValues(alpha: 0.5),
          border: Border.all(
              color: Theme.of(context)
                  .colorScheme
                  .secondary
                  .withValues(alpha: 0.1)),
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
                          .secondary
                          .withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.psychology_rounded,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Personal Insight',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                insight['message'] as String,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>?> _generateInsight(BuildContext context) async {
    try {
      final reflectionRepo = context.read<ReflectionBloc>().repository;
      final usageRepo = RepositoryProvider.of<UsageRepository>(context);

      final reflections = await reflectionRepo.getLastNDaysReflections(7);
      if (reflections.length < 3) return null; // Need at least 3 days of data

      // Calculate average mood
      final avgMood = reflections.fold<double>(0, (sum, r) => sum + r.mood) /
          reflections.length;

      // Get today's usage
      final todayUsage = await usageRepo.getTodayUsage();
      final totalMinutes =
          todayUsage.fold<int>(0, (sum, u) => sum + u.minutesUsed);

      // Mood vs Screen Time Correlation
      if (avgMood >= 4 && totalMinutes < 120) {
        return {
          'message':
              'You feel ${_getMoodText(avgMood.round())} on days with <2hr screen time! 😊',
        };
      } else if (avgMood <= 2 && totalMinutes > 180) {
        return {
          'message':
              'High screen time (${(totalMinutes / 60).toStringAsFixed(1)}hr) may be affecting your mood. Consider taking breaks! 🌿',
        };
      }

      // Gratitude Pattern Analysis
      final gratitudeThemes = _analyzeGratitudeThemes(reflections);
      if (gratitudeThemes.isNotEmpty) {
        return {
          'message':
              'You often express gratitude for "${gratitudeThemes.first}" - keep noticing the good! 🙏',
        };
      }

      // Intention Consistency
      final intentionThemes = _analyzeIntentionThemes(reflections);
      if (intentionThemes.isNotEmpty) {
        return {
          'message':
              'Your focus on "${intentionThemes.first}" shows commitment to growth! 🎯',
        };
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  List<String> _analyzeGratitudeThemes(List reflections) {
    final themes = <String, int>{};

    for (var reflection in reflections) {
      final gratitude = reflection.gratitude.toLowerCase();

      if (gratitude.contains('family') || gratitude.contains('loved ones')) {
        themes['family'] = (themes['family'] ?? 0) + 1;
      }
      if (gratitude.contains('health')) {
        themes['health'] = (themes['health'] ?? 0) + 1;
      }
      if (gratitude.contains('work') || gratitude.contains('productive')) {
        themes['work'] = (themes['work'] ?? 0) + 1;
      }
      if (gratitude.contains('learning')) {
        themes['learning'] = (themes['learning'] ?? 0) + 1;
      }
    }

    final sorted = themes.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.map((e) => e.key).toList();
  }

  List<String> _analyzeIntentionThemes(List reflections) {
    final themes = <String, int>{};

    for (var reflection in reflections) {
      final intention = reflection.tomorrowIntention.toLowerCase();

      if (intention.contains('focus') || intention.contains('deep work')) {
        themes['deep work'] = (themes['deep work'] ?? 0) + 1;
      }
      if (intention.contains('social media') || intention.contains('limit')) {
        themes['limiting distractions'] =
            (themes['limiting distractions'] ?? 0) + 1;
      }
      if (intention.contains('present') || intention.contains('mindful')) {
        themes['mindfulness'] = (themes['mindfulness'] ?? 0) + 1;
      }
    }

    final sorted = themes.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.map((e) => e.key).toList();
  }

  String _getMoodText(int mood) {
    switch (mood) {
      case 5:
        return 'great';
      case 4:
        return 'good';
      case 3:
        return 'okay';
      case 2:
        return 'low';
      case 1:
        return 'down';
      default:
        return 'neutral';
    }
  }
}
