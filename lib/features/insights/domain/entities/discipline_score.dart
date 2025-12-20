class DisciplineScore {
  final DateTime date;
  final bool limitRespected;
  final bool loggedHonestly;

  DisciplineScore({
    required this.date,
    required this.limitRespected,
    required this.loggedHonestly,
  });

  int get score {
    if (loggedHonestly && limitRespected) return 100;
    if (loggedHonestly) return 70;
    return 30;
  }
}
