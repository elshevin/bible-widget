package com.example.bible_widgets

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import android.app.PendingIntent
import android.content.Intent
import android.util.Log

class BibleWidgetProvider : AppWidgetProvider() {

    companion object {
        private const val TAG = "BibleWidgetProvider"

        // Try multiple SharedPreferences names for compatibility
        private val PREFS_NAMES = listOf(
            "FlutterSharedPreferences",
            "home_widget_preferences",
            "HomeWidgetPreferences"
        )

        // Default verses for the widget
        private val defaultVerses = listOf(
            Pair("For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future.", "Jeremiah 29:11"),
            Pair("Trust in the Lord with all your heart and lean not on your own understanding.", "Proverbs 3:5"),
            Pair("I can do all this through him who gives me strength.", "Philippians 4:13"),
            Pair("The Lord is my shepherd, I lack nothing.", "Psalm 23:1"),
            Pair("Be strong and courageous. Do not be afraid; do not be discouraged, for the Lord your God will be with you wherever you go.", "Joshua 1:9"),
            Pair("Peace I leave with you; my peace I give you.", "John 14:27"),
            Pair("Cast all your anxiety on him because he cares for you.", "1 Peter 5:7"),
            Pair("And we know that in all things God works for the good of those who love him.", "Romans 8:28")
        )

        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            Log.d(TAG, "updateAppWidget called for widgetId: $appWidgetId")

            var verseText: String? = null
            var verseReference: String? = null

            // Try to find verse data from different SharedPreferences
            for (prefsName in PREFS_NAMES) {
                val prefs: SharedPreferences = context.getSharedPreferences(prefsName, Context.MODE_PRIVATE)

                // Try different key formats
                val keyFormats = listOf(
                    "widget_verse_text" to "widget_verse_reference",
                    "flutter.widget_verse_text" to "flutter.widget_verse_reference"
                )

                for ((textKey, refKey) in keyFormats) {
                    val text = prefs.getString(textKey, null)
                    val ref = prefs.getString(refKey, null)

                    if (text != null && text.isNotEmpty()) {
                        verseText = text
                        verseReference = ref ?: ""
                        Log.d(TAG, "Found verse in $prefsName with key $textKey: ${text.take(50)}...")
                        break
                    }
                }

                if (verseText != null) break
            }

            // Use default verse if no data found
            val (text, reference) = if (verseText != null) {
                Pair(verseText, verseReference ?: "")
            } else {
                Log.d(TAG, "No verse found in SharedPreferences, using default")
                defaultVerses.random()
            }

            val views = RemoteViews(context.packageName, R.layout.bible_widget)
            views.setTextViewText(R.id.widget_verse_text, text)
            views.setTextViewText(R.id.widget_verse_reference, reference)

            // Create intent to open app when widget is clicked
            val intent = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_container, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
            Log.d(TAG, "Widget updated successfully")
        }
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        Log.d(TAG, "onUpdate called for ${appWidgetIds.size} widgets")
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        Log.d(TAG, "onEnabled: First widget created")
    }

    override fun onDisabled(context: Context) {
        Log.d(TAG, "onDisabled: Last widget removed")
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        Log.d(TAG, "onReceive: ${intent.action}")
    }
}
