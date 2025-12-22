package com.example.digital_discipline

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

    // ✅ THIS IS THE FIX
    private fun getTodayUsage(): List<Map<String, Any>> {
        val usageStatsManager =
            getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager

        val endTime = System.currentTimeMillis()
        val startTime = endTime - 24 * 60 * 60 * 1000

        val stats = usageStatsManager.queryUsageStats(
            UsageStatsManager.INTERVAL_DAILY,
            startTime,
            endTime
        )

        val pm = applicationContext.packageManager
        val result = mutableListOf<Map<String, Any>>()

        android.util.Log.d("USAGE_DEBUG", "---- USAGE STATS START ----")

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
                android.util.Log.e(
                    "USAGE_DEBUG",
                    "Failed to resolve app name for ${usage.packageName}",
                    e
                )
                usage.packageName
            }

            android.util.Log.d(
                "USAGE_DEBUG",
                "App: $appName (${usage.packageName}) → $minutes min"
            )

            result.add(
                mapOf(
                    "packageName" to usage.packageName,
                    "appName" to appName,
                    "minutesUsed" to minutes
                )
            )
        }

        android.util.Log.d("USAGE_DEBUG", "---- USAGE STATS END ----")
        return result
    }
}
