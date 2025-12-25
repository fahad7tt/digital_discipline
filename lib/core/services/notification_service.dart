// ignore_for_file: avoid_print

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata')); // IST

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  Future<void> scheduleEveningReminder({bool forceNextDay = false}) async {
    await _notifications.zonedSchedule(
      0, // Notification ID
      'Evening Reflection',
      'Take a moment to reflect on your day and plan for tomorrow.',
      _nextInstanceOf9PM(forceNextDay: forceNextDay),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reflection',
          'Daily Reflection Reminder',
          channelDescription: 'Reminds you to complete your daily reflection',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Test method - sends notification immediately
  Future<void> sendTestNotification() async {
    await _notifications.show(
      999, // Different ID for test
      'Digital Discipline',
      'Notifications are configured successfully.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test Notifications',
          channelDescription: 'Test notification channel',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> cancelEveningReminder() async {
    await _notifications.cancel(0);
  }

  tz.TZDateTime _nextInstanceOf9PM({bool forceNextDay = false}) {
    final now = tz.TZDateTime.now(tz.local);

    // Schedule for 9:00 PM IST
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      21, // 9 PM
      0, // 0 minutes
    );

    if (forceNextDay || scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    print('🔔 Notification scheduled for: $scheduledDate');
    return scheduledDate;
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - navigate to reflection screen
    // This will be handled by the app's navigation logic
  }
}
