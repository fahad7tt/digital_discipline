// ignore_for_file: avoid_print
import 'package:digital_discipline/intent.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/services/notification_service.dart';
import 'core/utils/app_di.dart';
import 'features/digital_app/data/models/digital_app_model.dart';
import 'features/reflection/data/models/reflection_model.dart';
import 'features/usage_logging/data/models/usage_log_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Core background services needed for immediate UI rendering
  await Hive.initFlutter();
  Hive.registerAdapter(DigitalAppModelAdapter());
  Hive.registerAdapter(AppUsageModelAdapter());
  Hive.registerAdapter(ReflectionModelAdapter());

  await AppDI.init();

  runApp(const IntentApp());

  // Non-blocking background initialization
  _initializeBackgroundServices();
}

/// Tasks that don't need to block the first frame of the app
Future<void> _initializeBackgroundServices() async {
  try {
    await NotificationService().initialize();

    final todayReflection =
        await AppDI.reflectionRepository.getTodayReflection();
    final isDone = todayReflection != null;

    if (isDone) {
      await NotificationService().scheduleEveningReminder(forceNextDay: true);
    } else {
      await NotificationService().scheduleEveningReminder();
    }
  } catch (e) {
    debugPrint('⚠️ Background initialization failed: $e');
  }
}