package com.oneapp.biblewidget

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import android.app.PendingIntent
import android.content.Intent
import android.util.Log
import android.graphics.Color
import android.graphics.drawable.GradientDrawable
import android.graphics.Bitmap
import android.graphics.Canvas

class BibleWidgetProvider : AppWidgetProvider() {

    companion object {
        private const val TAG = "BibleWidgetProvider"

        // Try multiple SharedPreferences names for compatibility
        private val PREFS_NAMES = listOf(
            "FlutterSharedPreferences",
            "home_widget_preferences",
            "HomeWidgetPreferences"
        )

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

            var verseText: String? = null
            var verseReference: String? = null
            var startColor: String? = null
            var endColor: String? = null
            var textColor: String? = null

            // Try to find data from different SharedPreferences
            for (prefsName in PREFS_NAMES) {
                val prefs: SharedPreferences = context.getSharedPreferences(prefsName, Context.MODE_PRIVATE)

                // Try different key formats
                val keyFormats = listOf(
                    listOf("widget_verse_text", "widget_verse_reference", "widget_start_color", "widget_end_color", "widget_text_color"),
                    listOf("flutter.widget_verse_text", "flutter.widget_verse_reference", "flutter.widget_start_color", "flutter.widget_end_color", "flutter.widget_text_color")
                )

                for (keys in keyFormats) {
                    val text = prefs.getString(keys[0], null)
                    val ref = prefs.getString(keys[1], null)
                    val start = prefs.getString(keys[2], null)
                    val end = prefs.getString(keys[3], null)
                    val txtColor = prefs.getString(keys[4], null)

                    if (text != null && text.isNotEmpty()) {
                        verseText = text
                        verseReference = ref ?: ""
                        startColor = start
                        endColor = end
                        textColor = txtColor
                        Log.d(TAG, "Found data in $prefsName with keys: ${keys[0]}")
                        Log.d(TAG, "Colors - start: $start, end: $end, text: $txtColor")
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
            val intent = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_container, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
            Log.d(TAG, "Widget updated successfully with colors")
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
