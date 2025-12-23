// import 'package:hive/hive.dart';
// import '../models/usage_log_model.dart';

// abstract class UsageLogLocalDataSource {
//   Future<List<UsageLogModel>> getLogsForApp(String focusAppId);
//   Future<void> addLog(UsageLogModel log);
//   Future<void> deleteLog(String id);
// }

// class UsageLogLocalDataSourceImpl implements UsageLogLocalDataSource {
//   final Box<UsageLogModel> box;

//   UsageLogLocalDataSourceImpl(this.box);

//   @override
//   Future<void> addLog(UsageLogModel log) async {
//     await box.put(log.id, log);
//   }

//   @override
//   Future<void> deleteLog(String id) async {
//     await box.delete(id);
//   }

//   @override
//   Future<List<UsageLogModel>> getLogsForApp(String focusAppId) async {
//     return box.values.where((log) => log.focusAppId == focusAppId).toList();
//   }
// }

import 'package:flutter/services.dart';

class AndroidUsageDataSource {
  static const _channel = MethodChannel('digital_discipline/usage');

  Future<bool> hasUsageAccess() async {
    final result = await _channel.invokeMethod<bool>('hasUsageAccess');
    return result ?? false;
  }

  Future<List<Map<String, dynamic>>> getTodayUsage() async {
    final result = await _channel.invokeMethod('getTodayUsage');

    if (result is List) {
      return result.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } else if (result is Map) {
      // Fallback for older native implementation
      return result.entries.map((entry) {
        return {
          'packageName': entry.key.toString(),
          'appName': entry.key.toString(),
          'minutesUsed': entry.value as int,
        };
      }).toList();
    }

    return [];
  }

  Future<List<Map<String, dynamic>>> getWeeklyUsage() async {
    final result = await _channel.invokeMethod('getWeeklyUsage');

    if (result is List) {
      return result.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } else if (result is Map) {
      // Fallback for older native implementation
      return result.entries.map((entry) {
        return {
          'packageName': entry.key.toString(),
          'appName': entry.key.toString(),
          'minutesUsed': entry.value as int,
        };
      }).toList();
    }
    return [];
  }
}
