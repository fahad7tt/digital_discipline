import '../entities/discipline_score.dart';

class CalculateDailyDiscipline {
  DisciplineScore call({
    required DateTime date,
    required int dailyLimitMinutes,
    required int actualUsedMinutes,
  }) {
    return DisciplineScore(
      date: date,
      loggedHonestly: true, // automatic tracking → always honest
      limitRespected: actualUsedMinutes <= dailyLimitMinutes,
    );
  }
}
