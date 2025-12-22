package com.example.digital_discipline

import android.app.AppOpsManager
import android.app.usage.UsageStatsManager
import android.content.Context
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Calendar

class MainActivity : FlutterActivity() {

    private val CHANNEL = "digital_discipline/usage"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getTodayUsage" -> {
                    result.success(getTodayUsage())
                }
                "hasUsageAccess" -> {
                    result.success(hasUsageAccess())
                }
                else -> {
                    result.notImplemented()
                }
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

    private fun getTodayUsage(): Map<String, Int> {
    val usageStatsManager =
        getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager

    val endTime = System.currentTimeMillis()
    val startTime = endTime - 24 * 60 * 60 * 1000  // rolling 24h window

    val stats = usageStatsManager.queryUsageStats(
        UsageStatsManager.INTERVAL_DAILY,
        startTime,
        endTime
    )

    val usageMap = mutableMapOf<String, Int>()

    android.util.Log.d("USAGE_DEBUG", "---- USAGE STATS START ----")
    android.util.Log.d("USAGE_DEBUG", "Stats count: ${stats.size}")

    for (usage in stats) {
        val minutes = (usage.totalTimeInForeground / 60000).toInt()

        android.util.Log.d(
            "USAGE_DEBUG",
            "App: ${usage.packageName}, foreground(ms): ${usage.totalTimeInForeground}, minutes: $minutes"
        )

        if (minutes > 0) {
            usageMap[usage.packageName] = minutes
        }
    }

    android.util.Log.d("USAGE_DEBUG", "Final usage map: $usageMap")
    android.util.Log.d("USAGE_DEBUG", "---- USAGE STATS END ----")

    return usageMap
}
}
