package app.`in`.digital_discipline

import android.app.AppOpsManager
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "digital_discipline/usage"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getTodayUsage" -> result.success(getTodayUsage())
                "getWeeklyUsage" -> result.success(getWeeklyUsage()) // Added line
                "hasUsageAccess" -> result.success(hasUsageAccess())
                else -> result.notImplemented()
            }
        }
    }

    private fun hasUsageAccess(): Boolean {
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = appOps.checkOpNoThrow(
            AppOpsManager.OPSTR_GET_USAGE_STATS,
            android.os.Process.myUid(),
            packageName
        )
        return mode == AppOpsManager.MODE_ALLOWED
    }

    private fun getTodayUsage(): List<Map<String, Any>> {
        val usageStatsManager =
            getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager

        val calendar = java.util.Calendar.getInstance()
        calendar.set(java.util.Calendar.HOUR_OF_DAY, 0)
        calendar.set(java.util.Calendar.MINUTE, 0)
        calendar.set(java.util.Calendar.SECOND, 0)
        calendar.set(java.util.Calendar.MILLISECOND, 0)

        val startTime = calendar.timeInMillis
        val endTime = System.currentTimeMillis()

        // 1. Get aggregated stats using the system's bucket (includes PiP)
        val stats = usageStatsManager.queryUsageStats(
            UsageStatsManager.INTERVAL_DAILY,
            startTime,
            endTime
        )

        val totalUsage = mutableMapOf<String, Long>()
        for (usage in stats) {
            if (usage.totalTimeInForeground > 0) {
                totalUsage[usage.packageName] = usage.totalTimeInForeground
            }
        }

        // 2. Identify the currently active app to add its live session time
        // UsageStats aggregated time only updates when an app moves to background
        val events = usageStatsManager.queryEvents(startTime, endTime)
        val event = android.app.usage.UsageEvents.Event()
        var lastForegroundApp: String? = null
        var lastForegroundTime: Long = 0

        while (events.hasNextEvent()) {
            events.getNextEvent(event)
            if (event.eventType == android.app.usage.UsageEvents.Event.MOVE_TO_FOREGROUND) {
                lastForegroundApp = event.packageName
                lastForegroundTime = event.timeStamp
            } else if (event.eventType == android.app.usage.UsageEvents.Event.MOVE_TO_BACKGROUND) {
                if (event.packageName == lastForegroundApp) {
                    lastForegroundApp = null
                }
            }
        }

        // Add live duration if an app is still in the foreground
        lastForegroundApp?.let { pkg ->
            val liveDuration = endTime - lastForegroundTime
            if (liveDuration > 0) {
                totalUsage[pkg] = (totalUsage[pkg] ?: 0L) + liveDuration
            }
        }

        val pm = applicationContext.packageManager
        val result = mutableListOf<Map<String, Any>>()

        for ((packageName, durationMs) in totalUsage) {
            val minutes = (durationMs / 60000).toInt()
            if (minutes <= 0) continue

            val appName = try {
                val appInfo = pm.getApplicationInfo(
                    packageName,
                    PackageManager.MATCH_ALL
                )
                pm.getApplicationLabel(appInfo).toString()
            } catch (e: Exception) {
                packageName
            }

            result.add(
                mapOf(
                    "packageName" to packageName,
                    "appName" to appName,
                    "minutesUsed" to minutes
                    // "date" not strictly needed for getTodayUsage, but we can add if we want consistency
                )
            )
        }
        return result
    }

    private fun getWeeklyUsage(): List<Map<String, Any>> {
        val usageStatsManager =
            getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager

        val calendar = java.util.Calendar.getInstance()
        calendar.set(java.util.Calendar.HOUR_OF_DAY, 0)
        calendar.set(java.util.Calendar.MINUTE, 0)
        calendar.set(java.util.Calendar.SECOND, 0)
        calendar.set(java.util.Calendar.MILLISECOND, 0)
        calendar.add(java.util.Calendar.DAY_OF_YEAR, -6) // Today + 6 past days = 7 days

        val startTime = calendar.timeInMillis
        val endTime = System.currentTimeMillis()

        val stats = usageStatsManager.queryUsageStats(
            UsageStatsManager.INTERVAL_DAILY,
            startTime,
            endTime
        )

        return parseUsageStats(stats)
    }

    private fun parseUsageStats(stats: List<android.app.usage.UsageStats>): List<Map<String, Any>> {
        val pm = applicationContext.packageManager
        val result = mutableListOf<Map<String, Any>>()

        for (usage in stats) {
            val minutes = (usage.totalTimeInForeground / 60000).toInt()
            if (minutes <= 0) continue

            val appName = try {
                val appInfo = pm.getApplicationInfo(
                    usage.packageName,
                    PackageManager.MATCH_ALL
                )
                pm.getApplicationLabel(appInfo).toString()
            } catch (e: Exception) {
                // Log only once per package to avoid spam, or just silence for now
                usage.packageName
            }

            result.add(
                mapOf(
                    "packageName" to usage.packageName,
                    "appName" to appName,
                    "minutesUsed" to minutes,
                    "date" to usage.firstTimeStamp // Include timestamp for bucketing
                )
            )
        }
        return result
    }
}
