import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import '../data/content_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'dart:math';

class WidgetService {
  static const String appGroupId = 'group.com.oneapp.bibleWidget';
  static const String iOSWidgetName = 'BibleWidget';
  static const String androidWidgetName = 'BibleWidgetProvider';

  /// Initialize the widget service
  static Future<void> initialize() async {
    try {
      await HomeWidget.setAppGroupId(appGroupId);
      if (kDebugMode) print('WidgetService: initialized with appGroupId: $appGroupId');
    } catch (e) {
      if (kDebugMode) print('WidgetService: initialization error: $e');
    }
  }

  /// Update the widget with a random verse
  static Future<void> updateWidgetWithRandomVerse() async {
    try {
      final verses = ContentData.verses;
      final randomVerse = verses[Random().nextInt(verses.length)];

      if (kDebugMode) print('WidgetService: saving verse - ${randomVerse.reference}');

      await HomeWidget.saveWidgetData<String>(
        'widget_verse_text',
        randomVerse.text,
      );
      await HomeWidget.saveWidgetData<String>(
        'widget_verse_reference',
        _getDisplayReference(randomVerse),
      );
      // Save verse ID for deep link navigation
      await HomeWidget.saveWidgetData<String>(
        'widget_verse_id',
        randomVerse.id,
      );

      await updateWidget();
      if (kDebugMode) print('WidgetService: widget updated successfully');
    } catch (e) {
      if (kDebugMode) print('WidgetService: updateWidgetWithRandomVerse error: $e');
    }
  }

  /// Update the widget with a specific verse
  static Future<void> updateWidgetWithVerse(String text, String? reference, {String? verseId}) async {
    try {
      await HomeWidget.saveWidgetData<String>('widget_verse_text', text);
      await HomeWidget.saveWidgetData<String>(
        'widget_verse_reference',
        reference ?? '',
      );
      // Save verse ID for deep link navigation
      if (verseId != null) {
        await HomeWidget.saveWidgetData<String>('widget_verse_id', verseId);
      }

      await updateWidget();
    } catch (e) {
      if (kDebugMode) print('WidgetService: updateWidgetWithVerse error: $e');
    }
  }

  /// Update the widget theme colors and background image
  static Future<void> updateWidgetTheme(String themeId) async {
    try {
      final theme = VisualThemes.getById(themeId);
      final colors = theme.gradientColors;

      final startColor = _colorToHex(colors.first);
      final endColor = _colorToHex(colors.last);
      final textColor = _colorToHex(theme.textColor);

      if (kDebugMode) print('WidgetService: Updating theme to $themeId');
      if (kDebugMode) print('WidgetService: startColor=$startColor, endColor=$endColor');
      if (kDebugMode) print('WidgetService: backgroundImage=${theme.backgroundImage}');

      // Save gradient colors as hex strings
      await HomeWidget.saveWidgetData<String>(
        'widget_start_color',
        startColor,
      );
      await HomeWidget.saveWidgetData<String>(
        'widget_end_color',
        endColor,
      );
      await HomeWidget.saveWidgetData<String>(
        'widget_text_color',
        textColor,
      );

      // Render background image to App Group shared container for iOS widget
      await _copyBackgroundForWidget(theme.backgroundImage);

      // Force widget refresh
      await updateWidget();
      if (kDebugMode) print('WidgetService: theme updated successfully to $themeId');
    } catch (e) {
      if (kDebugMode) print('WidgetService: updateWidgetTheme error: $e');
    }
  }

  /// Get display reference for widget - fallback to topic label if no Bible reference
  static String _getDisplayReference(Verse verse) {
    if (verse.reference != null && verse.reference!.isNotEmpty) {
      return verse.reference!;
    }
    // For non-Bible quotes, show a topic-based label
    if (verse.topics.contains('prayers') || verse.topics.contains('prayer')) {
      return '— Prayer';
    }
    if (verse.topics.contains('quotes')) {
      return '— Inspirational';
    }
    return '— Daily Wisdom';
  }

  static String _colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  /// Render background image and save to shared container for widget
  /// Uses HomeWidget.renderFlutterWidget which saves to:
  /// - iOS: App Group container (accessible by widget extension)
  /// - Android: Internal storage (accessible via SharedPreferences path)
  static Future<void> _copyBackgroundForWidget(String? assetPath) async {
    if (assetPath == null) return;

    try {
      if (kDebugMode) print('WidgetService: Rendering background for widget: $assetPath');

      // Load the image first to ensure it's fully loaded before rendering
      final ByteData data = await rootBundle.load(assetPath);
      final ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ui.Image image = frameInfo.image;

      if (kDebugMode) print('WidgetService: Image loaded: ${image.width}x${image.height}');

      // Use renderFlutterWidget with RawImage which doesn't need async loading
      // This works on both iOS and Android
      await HomeWidget.renderFlutterWidget(
        RawImage(
          image: image,
          fit: BoxFit.cover,
          width: 400,
          height: 400,
        ),
        key: 'widget_background_image',
        logicalSize: const Size(400, 400),
        pixelRatio: 2.0, // For retina/high-density displays
      );

      if (kDebugMode) print('WidgetService: Background rendered to shared container');
    } catch (e) {
      if (kDebugMode) print('WidgetService: _copyBackgroundForWidget error: $e');
    }
  }

  /// Trigger widget update - forces iOS WidgetKit to reload timelines
  static Future<void> updateWidget() async {
    try {
      // This calls WidgetCenter.shared.reloadTimelines on iOS
      // and AppWidgetManager.notifyAppWidgetViewDataChanged on Android
      final result = await HomeWidget.updateWidget(
        name: androidWidgetName,
        iOSName: iOSWidgetName,
      );
      if (kDebugMode) print('WidgetService: updateWidget result = $result');
    } catch (e) {
      if (kDebugMode) print('WidgetService: updateWidget error: $e');
    }
  }

  /// Register callback for widget interactions
  static Future<void> registerInteractivityCallback(
    Future<void> Function(Uri?) callback,
  ) async {
    try {
      await HomeWidget.registerInteractivityCallback(callback);
    } catch (e) {
      if (kDebugMode) print('WidgetService: registerInteractivityCallback error: $e');
    }
  }

  /// Save widget settings (text size, refresh frequency, content type) to shared UserDefaults
  static Future<void> saveWidgetSettings(WidgetSettings settings) async {
    try {
      await HomeWidget.saveWidgetData<double>(
        'widget_text_size',
        settings.textSize.fontSize,
      );
      await HomeWidget.saveWidgetData<int>(
        'widget_refresh_minutes',
        settings.refreshFrequency.duration.inMinutes,
      );
      await HomeWidget.saveWidgetData<String>(
        'widget_content_type',
        settings.contentType.name,
      );
      if (kDebugMode) print('WidgetService: saved widget settings - textSize=${settings.textSize.fontSize}, refresh=${settings.refreshFrequency.duration.inMinutes}min, content=${settings.contentType.name}');
    } catch (e) {
      if (kDebugMode) print('WidgetService: saveWidgetSettings error: $e');
    }
  }

  /// Update widget with a verse filtered by content type
  static Future<void> updateWidgetWithFilteredVerse(
    WidgetContentType contentType,
    List<String> favoriteVerseIds,
    List<String> followedTopicNames,
  ) async {
    try {
      final allVerses = ContentData.getAllContent();
      List<Verse> filteredVerses;

      switch (contentType) {
        case WidgetContentType.favorites:
          filteredVerses = allVerses.where((v) => favoriteVerseIds.contains(v.id)).toList();
          break;
        case WidgetContentType.bibleVerses:
          filteredVerses = allVerses.where((v) => v.reference != null && v.reference!.isNotEmpty).toList();
          break;
        case WidgetContentType.prayers:
          filteredVerses = allVerses.where((v) =>
            v.topics.any((t) => t.toLowerCase().contains('prayer'))
          ).toList();
          break;
        case WidgetContentType.followedTopics:
          if (followedTopicNames.isNotEmpty) {
            filteredVerses = allVerses.where((v) =>
              v.topics.any((t) => followedTopicNames.any((ft) => t.toLowerCase().contains(ft.toLowerCase())))
            ).toList();
          } else {
            filteredVerses = allVerses;
          }
          break;
        case WidgetContentType.general:
          filteredVerses = allVerses;
      }

      // Fallback to all verses if filtered list is empty
      if (filteredVerses.isEmpty) {
        filteredVerses = allVerses;
      }

      final randomVerse = filteredVerses[Random().nextInt(filteredVerses.length)];

      await HomeWidget.saveWidgetData<String>('widget_verse_text', randomVerse.text);
      await HomeWidget.saveWidgetData<String>('widget_verse_reference', _getDisplayReference(randomVerse));
      await HomeWidget.saveWidgetData<String>('widget_verse_id', randomVerse.id);

      await updateWidget();
      if (kDebugMode) print('WidgetService: updated with filtered verse (${contentType.name}): ${randomVerse.reference}');
    } catch (e) {
      if (kDebugMode) print('WidgetService: updateWidgetWithFilteredVerse error: $e');
    }
  }

  /// Force refresh all widget data (theme + verse) - useful when returning to app
  static Future<void> forceRefreshWidget(String themeId, String text, String? reference, String? verseId) async {
    try {
      // Update theme
      final theme = VisualThemes.getById(themeId);
      final colors = theme.gradientColors;

      final startColor = _colorToHex(colors.first);
      final endColor = _colorToHex(colors.last);
      final textColor = _colorToHex(theme.textColor);

      if (kDebugMode) print('WidgetService: forceRefresh - theme=$themeId, verse=$verseId');
      if (kDebugMode) print('WidgetService: forceRefresh - colors: $startColor -> $endColor');
      if (kDebugMode) print('WidgetService: forceRefresh - backgroundImage=${theme.backgroundImage}');

      // Save all data in sequence
      await HomeWidget.saveWidgetData<String>('widget_start_color', startColor);
      await HomeWidget.saveWidgetData<String>('widget_end_color', endColor);
      await HomeWidget.saveWidgetData<String>('widget_text_color', textColor);
      await HomeWidget.saveWidgetData<String>('widget_verse_text', text);
      await HomeWidget.saveWidgetData<String>('widget_verse_reference', reference ?? '');
      await HomeWidget.saveWidgetData<String>('widget_verse_id', verseId ?? '');

      // Render background image to App Group shared container for iOS widget
      await _copyBackgroundForWidget(theme.backgroundImage);

      // Force update
      await updateWidget();
      if (kDebugMode) print('WidgetService: forceRefresh complete');
    } catch (e) {
      if (kDebugMode) print('WidgetService: forceRefreshWidget error: $e');
    }
  }
}
