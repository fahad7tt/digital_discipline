package com.example.digital_discipline

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    private val CHANNEL = "digital_discipline/usage"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getTodayUsage") {
                    result.success(getUsageStats())
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun getUsageStats(): Map<String, Int> {
        val usageStatsManager =
            getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager

        val calendar = Calendar.getInstance()
        calendar.set(Calendar.HOUR_OF_DAY, 0)
        calendar.set(Calendar.MINUTE, 0)
        calendar.set(Calendar.SECOND, 0)

        val start = calendar.timeInMillis
        val end = System.currentTimeMillis()

        val stats = usageStatsManager.queryUsageStats(
            UsageStatsManager.INTERVAL_DAILY,
            start,
            end
        )

        val usageMap = mutableMapOf<String, Int>()

        for (usage in stats) {
            val minutes = (usage.totalTimeInForeground / 60000).toInt()
            if (minutes > 0) {
                usageMap[usage.packageName] = minutes
            }
        }

        return usageMap
    }
}

