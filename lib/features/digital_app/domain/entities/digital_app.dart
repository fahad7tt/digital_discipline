import 'package:equatable/equatable.dart';

class DigitalApp extends Equatable {
  final String id;
  final String name;
  final int dailyLimitMinutes;
  final DateTime createdAt;

  const DigitalApp({
    required this.id,
    required this.name,
    required this.dailyLimitMinutes,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, name, dailyLimitMinutes];
}
