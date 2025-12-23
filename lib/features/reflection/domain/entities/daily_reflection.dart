class DailyReflection {
  final String id;
  final DateTime date;
  final int mood; // 1-5 rating
  final String reflectionAnswer;
  final String gratitude;
  final String tomorrowIntention;

  DailyReflection({
    required this.id,
    required this.date,
    required this.mood,
    required this.reflectionAnswer,
    required this.gratitude,
    required this.tomorrowIntention,
  });

  // Helper to check if reflection is for today
  bool isToday() {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Get mood emoji
  String get moodEmoji {
    switch (mood) {
      case 1:
        return '😔';
      case 2:
        return '😕';
      case 3:
        return '😐';
      case 4:
        return '🙂';
      case 5:
        return '😊';
      default:
        return '😐';
    }
  }
}
