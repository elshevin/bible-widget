package com.oneapp.biblewidget

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import android.net.Uri
import android.content.Intent
import android.util.Log
import android.graphics.Color
import android.graphics.drawable.GradientDrawable
import android.graphics.Bitmap
import android.graphics.Canvas
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin

class BibleWidgetProvider : AppWidgetProvider() {

    companion object {
        private const val TAG = "BibleWidgetProvider"

        // Default theme colors (golden water theme)
        private const val DEFAULT_START_COLOR = "#2C1810"
        private const val DEFAULT_END_COLOR = "#2C1810"
        private const val DEFAULT_CENTER_COLOR = "#8B6914"
        private const val DEFAULT_TEXT_COLOR = "#FFFFFF"

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

        private fun createGradientBitmap(width: Int, height: Int, startColor: Int, endColor: Int): Bitmap {
            val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
            val canvas = Canvas(bitmap)
            val gradient = GradientDrawable(
                GradientDrawable.Orientation.TOP_BOTTOM,
                intArrayOf(startColor, endColor)
            )
            gradient.cornerRadius = 24f
            gradient.setBounds(0, 0, width, height)
            gradient.draw(canvas)
            return bitmap
        }

        private fun parseColor(colorStr: String?, defaultColor: String): Int {
            return try {
                Color.parseColor(colorStr ?: defaultColor)
            } catch (e: Exception) {
                Color.parseColor(defaultColor)
            }
        }

        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            Log.d(TAG, "updateAppWidget called for widgetId: $appWidgetId")

            // Use HomeWidgetPlugin.getData() to get the correct SharedPreferences
            val prefs: SharedPreferences = HomeWidgetPlugin.getData(context)

            // Read widget data directly (home_widget uses no prefix)
            val verseText = prefs.getString("widget_verse_text", null)
            val verseReference = prefs.getString("widget_verse_reference", null)
            val startColor = prefs.getString("widget_start_color", null)
            val endColor = prefs.getString("widget_end_color", null)
            val textColor = prefs.getString("widget_text_color", null)
            val verseId = prefs.getString("widget_verse_id", null)

            Log.d(TAG, "Read data - text: ${verseText?.take(30)}...")
            Log.d(TAG, "Read data - verseId: $verseId")
            Log.d(TAG, "Read data - colors: start=$startColor, end=$endColor")

            // Use default verse if no data found
            val (text, reference) = if (verseText != null && verseText.isNotEmpty()) {
                Pair(verseText, verseReference ?: "")
            } else {
                Log.d(TAG, "No verse found in SharedPreferences, using default")
                defaultVerses.random()
            }

            val views = RemoteViews(context.packageName, R.layout.bible_widget)
            views.setTextViewText(R.id.widget_verse_text, text)
            views.setTextViewText(R.id.widget_verse_reference, reference)

            // Apply theme colors
            val parsedStartColor = parseColor(startColor, DEFAULT_START_COLOR)
            val parsedEndColor = parseColor(endColor, DEFAULT_END_COLOR)
            val parsedTextColor = parseColor(textColor, DEFAULT_TEXT_COLOR)

            // Create gradient bitmap for background
            val backgroundBitmap = createGradientBitmap(400, 400, parsedStartColor, parsedEndColor)
            views.setImageViewBitmap(R.id.widget_background, backgroundBitmap)

            // Set text colors
            views.setTextColor(R.id.widget_verse_text, parsedTextColor)
            views.setTextColor(R.id.widget_verse_reference, (parsedTextColor and 0x00FFFFFF) or 0xCC000000.toInt())

            // Create intent to open app when widget is clicked
            // Use HomeWidgetLaunchIntent to enable initiallyLaunchedFromHomeWidget() detection
            // URI must include homeWidget=true for home_widget plugin to recognize it
            val pendingIntent = if (verseId != null && verseId.isNotEmpty()) {
                val uri = Uri.parse("biblewidgets://verse?id=$verseId&homeWidget=true")
                Log.d(TAG, "Creating launch intent with URI: $uri")
                HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, uri)
            } else {
                // Fallback: just open the app without specific verse
                val uri = Uri.parse("biblewidgets://home?homeWidget=true")
                Log.d(TAG, "Creating fallback launch intent with URI: $uri")
                HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, uri)
            }
            views.setOnClickPendingIntent(R.id.widget_container, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
            Log.d(TAG, "Widget updated successfully with colors and deep link URI: $uri")
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
