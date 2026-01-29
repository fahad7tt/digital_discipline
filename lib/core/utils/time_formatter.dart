class TimeFormatter {
  static String formatDuration(int totalMinutes) {
    if (totalMinutes < 60) {
      return '$totalMinutes${totalMinutes == 1 ? 'min' : 'mins'}';
    }
    final int hours = totalMinutes ~/ 60;
    final int minutes = totalMinutes % 60;

    if (minutes == 0) {
      return hours == 1 ? '1hr' : '${hours}hrs';
    }

    return '$hours${hours == 1 ? 'hr' : 'hrs'} $minutes${minutes == 1 ? 'min' : 'mins'}';
  }
}
