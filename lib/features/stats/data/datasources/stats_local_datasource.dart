import '../models/stats_model.dart';

abstract class StatsLocalDatasource {
  List<StatsModel> getStats();
}

class StatsLocalDatasourceImpl implements StatsLocalDatasource {
  @override
  List<StatsModel> getStats() {
    return [
      StatsModel(
        id: 'usage_30',
        title: 'Fragmented Attention',
        description:
            'Studies show that even 30 minutes of continuous social app usage can reduce deep focus for hours.',
        minUsageMinutes: 30,
      ),
      StatsModel(
        id: 'usage_60',
        title: 'Dopamine Fatigue',
        description:
            'After 60 minutes, dopamine sensitivity drops, making it harder to feel satisfaction from real-life tasks.',
        minUsageMinutes: 60,
      ),
      StatsModel(
        id: 'usage_120',
        title: 'Mental Exhaustion',
        description:
            'Prolonged usage beyond 2 hours correlates with anxiety, restlessness, and poor sleep quality.',
        minUsageMinutes: 120,
      ),
    ];
  }
}
