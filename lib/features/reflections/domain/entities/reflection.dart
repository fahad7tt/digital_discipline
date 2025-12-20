import 'package:equatable/equatable.dart';

class Reflection extends Equatable {
  final String id;
  final DateTime date;
  final String mood;
  final String note;

  const Reflection({
    required this.id,
    required this.date,
    required this.mood,
    required this.note,
  });

  @override
  List<Object?> get props => [id, date, mood, note];
}
