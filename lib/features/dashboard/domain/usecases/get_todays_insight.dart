import '../entities/research_insight.dart';

class GetTodaysInsight {
  // Curated, research-backed insights about digital discipline
  static final List<ResearchInsight> _insights = [
    ResearchInsight(
      title: 'Attention Residue',
      description:
          'Even brief notifications reduce focus for several minutes after. Silencing your phone improves concentration.',
      source: 'Ward et al.',
      year: 2017,
    ),
    ResearchInsight(
      title: 'Task Switching Cost',
      description:
          'Switching between apps creates a 25-minute attention tax. Deep work requires uninterrupted time blocks.',
      source: 'Rosen et al.',
      year: 2013,
    ),
    ResearchInsight(
      title: 'Dopamine & Habit Loops',
      description:
          'Social media triggers dopamine hits. Recognizing your "why" (boredom, anxiety?) is the first step to change.',
      source: 'Eyal',
      year: 2019,
    ),
    ResearchInsight(
      title: 'Sleep & Blue Light',
      description:
          'Evening screen time suppresses melatonin. 1 hour before bed without devices improves sleep quality.',
      source: 'Chang et al.',
      year: 2015,
    ),
    ResearchInsight(
      title: 'Decision Fatigue',
      description:
          'Each "just one more scroll" depletes willpower. Setting boundaries upfront requires less daily discipline.',
      source: 'Baumeister et al.',
      year: 2011,
    ),
    ResearchInsight(
      title: 'FOMO & Anxiety',
      description:
          'Fear of missing out increases anxiety. Regular "check-in" times reduce constant checking urges.',
      source: 'Przybylski et al.',
      year: 2013,
    ),
    ResearchInsight(
      title: 'Novelty Seeking',
      description:
          'Apps are designed to trigger novelty. Knowing this helps you make conscious choices, not automatic ones.',
      source: 'Alter',
      year: 2017,
    ),
    ResearchInsight(
      title: 'Cognitive Load & Performance',
      description:
          'Background notifications reduce test performance by 25%. One thing at a time = better results.',
      source: 'Ophir et al.',
      year: 2009,
    ),
    ResearchInsight(
      title: 'Digital Wellbeing',
      description:
          'Intentional phone use correlates with better mood and life satisfaction. You\'re building a skill.',
      source: 'Twenge & Campbell',
      year: 2019,
    ),
    ResearchInsight(
      title: 'Default Mode Network',
      description:
          'Boredom activates creativity. Constant stimulation prevents your mind from wandering and dreaming.',
      source: 'Killingsworth & Gilbert',
      year: 2010,
    ),
  ];

  ResearchInsight call() {
    // Get today's index based on date (consistent daily rotation)
    final today = DateTime.now();
    final dayOfYear = today.difference(DateTime(today.year)).inDays;
    final index = dayOfYear % _insights.length;
    return _insights[index];
  }
}
