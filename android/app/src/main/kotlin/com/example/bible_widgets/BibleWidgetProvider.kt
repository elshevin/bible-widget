package com.example.bible_widgets

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import android.app.PendingIntent
import android.content.Intent

class BibleWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }

    companion object {
        private const val PREFS_NAME = "FlutterSharedPreferences"

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
            val prefs: SharedPreferences = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

            // Try to get verse from SharedPreferences (set by Flutter)
            val verseText = prefs.getString("flutter.widget_verse_text", null)
            val verseReference = prefs.getString("flutter.widget_verse_reference", null)

            val (text, reference) = if (verseText != null && verseReference != null) {
                Pair(verseText, verseReference)
            } else {
                // Use random default verse
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
        }
    }
}
