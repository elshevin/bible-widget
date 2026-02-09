package com.oneapp.biblewidget

import android.content.ComponentName
import android.content.pm.PackageManager
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.biblewidgets/app_icon"
    private val TAG = "BibleWidgetIcon"

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
                    try {
                        val iconName = call.argument<String>("iconName") ?: "default"
                        Log.d(TAG, "Setting app icon to: $iconName")
                        setAppIcon(iconName)
                        result.success(true)
                    } catch (e: Exception) {
                        Log.e(TAG, "Error setting app icon: ${e.message}")
                        result.error("ICON_ERROR", e.message, null)
                    }
                }
                "getCurrentIcon" -> {
                    try {
                        val currentIcon = getCurrentIcon()
                        Log.d(TAG, "Current icon: $currentIcon")
                        result.success(currentIcon)
                    } catch (e: Exception) {
                        Log.e(TAG, "Error getting current icon: ${e.message}")
                        result.error("ICON_ERROR", e.message, null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun setAppIcon(iconName: String) {
        val pm = packageManager
        val pkgName = packageName

        Log.d(TAG, "Package name: $pkgName")
        Log.d(TAG, "Available aliases: ${iconAliases.keys}")

        // First, enable the new icon
        val selectedAlias = iconAliases[iconName] ?: iconAliases["default"]!!
        Log.d(TAG, "Enabling alias: $pkgName$selectedAlias")

        pm.setComponentEnabledSetting(
            ComponentName(pkgName, "$pkgName$selectedAlias"),
            PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
            PackageManager.DONT_KILL_APP
        )

        // Then disable all other aliases
        iconAliases.forEach { (name, alias) ->
            if (name != iconName) {
                Log.d(TAG, "Disabling alias: $pkgName$alias")
                pm.setComponentEnabledSetting(
                    ComponentName(pkgName, "$pkgName$alias"),
                    PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                    PackageManager.DONT_KILL_APP
                )
            }
        }

        Log.d(TAG, "Icon change completed for: $iconName")
    }

    private fun getCurrentIcon(): String {
        val pm = packageManager
        val pkgName = packageName

        for ((name, alias) in iconAliases) {
            val componentName = ComponentName(pkgName, "$pkgName$alias")
            val state = pm.getComponentEnabledSetting(componentName)
            Log.d(TAG, "Alias $name ($alias) state: $state")

            if (state == PackageManager.COMPONENT_ENABLED_STATE_ENABLED) {
                return name
            }
            // Check if default is in default state (not explicitly set)
            if (name == "default" && state == PackageManager.COMPONENT_ENABLED_STATE_DEFAULT) {
                return name
            }
        }
        return "default"
    }
}
