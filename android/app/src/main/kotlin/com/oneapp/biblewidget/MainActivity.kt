package com.oneapp.biblewidget

import android.content.ComponentName
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.biblewidgets/app_icon"

    private val iconAliases = mapOf(
        "default" to ".MainActivityDefault",
        "navy_stars" to ".MainActivityNavyStars",
        "cream_olive" to ".MainActivityCreamOlive",
        "gold_luxe" to ".MainActivityGoldLuxe",
        "white_wave" to ".MainActivityWhiteWave",
        "teal_pink" to ".MainActivityTealPink",
        "ocean_clouds" to ".MainActivityOceanClouds",
        "night_gold" to ".MainActivityNightGold",
        "sunset_coral" to ".MainActivitySunsetCoral",
        "royal_purple" to ".MainActivityRoyalPurple"
    )

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "setAppIcon" -> {
                    val iconName = call.argument<String>("iconName") ?: "default"
                    setAppIcon(iconName)
                    result.success(true)
                }
                "getCurrentIcon" -> {
                    result.success(getCurrentIcon())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun setAppIcon(iconName: String) {
        val packageManager = packageManager
        val packageName = packageName

        // Disable all aliases first
        iconAliases.values.forEach { alias ->
            packageManager.setComponentEnabledSetting(
                ComponentName(packageName, "$packageName$alias"),
                PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                PackageManager.DONT_KILL_APP
            )
        }

        // Enable the selected alias
        val selectedAlias = iconAliases[iconName] ?: iconAliases["default"]!!
        packageManager.setComponentEnabledSetting(
            ComponentName(packageName, "$packageName$selectedAlias"),
            PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
            PackageManager.DONT_KILL_APP
        )
    }

    private fun getCurrentIcon(): String {
        val packageManager = packageManager
        val packageName = packageName

        for ((name, alias) in iconAliases) {
            val componentName = ComponentName(packageName, "$packageName$alias")
            val state = packageManager.getComponentEnabledSetting(componentName)
            if (state == PackageManager.COMPONENT_ENABLED_STATE_ENABLED ||
                (state == PackageManager.COMPONENT_ENABLED_STATE_DEFAULT && name == "default")) {
                return name
            }
        }
        return "default"
    }
}
