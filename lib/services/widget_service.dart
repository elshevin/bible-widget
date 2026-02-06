import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import '../data/content_data.dart';
import '../theme/app_theme.dart';
import 'dart:math';

class WidgetService {
  static const String appGroupId = 'group.com.oneapp.bibleWidgets';
  static const String iOSWidgetName = 'BibleWidget';
  static const String androidWidgetName = 'BibleWidgetProvider';

  /// Initialize the widget service
  static Future<void> initialize() async {
    try {
      await HomeWidget.setAppGroupId(appGroupId);
      print('WidgetService: initialized with appGroupId: $appGroupId');
    } catch (e) {
      print('WidgetService: initialization error: $e');
    }
  }

  /// Update the widget with a random verse
  static Future<void> updateWidgetWithRandomVerse() async {
    try {
      final verses = ContentData.verses;
      final randomVerse = verses[Random().nextInt(verses.length)];

      print('WidgetService: saving verse - ${randomVerse.reference}');

      await HomeWidget.saveWidgetData<String>(
        'widget_verse_text',
        randomVerse.text,
      );
      await HomeWidget.saveWidgetData<String>(
        'widget_verse_reference',
        randomVerse.reference ?? '',
      );
      // Save verse ID for deep link navigation
      await HomeWidget.saveWidgetData<String>(
        'widget_verse_id',
        randomVerse.id,
      );

      await updateWidget();
      print('WidgetService: widget updated successfully');
    } catch (e) {
      print('WidgetService: updateWidgetWithRandomVerse error: $e');
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
      print('WidgetService: updateWidgetWithVerse error: $e');
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

      print('WidgetService: Updating theme to $themeId');
      print('WidgetService: startColor=$startColor, endColor=$endColor');
      print('WidgetService: backgroundImage=${theme.backgroundImage}');

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
      print('WidgetService: theme updated successfully to $themeId');
    } catch (e) {
      print('WidgetService: updateWidgetTheme error: $e');
    }
  }

  static String _colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  /// Render background image and save to App Group shared container for iOS widget
  /// Uses HomeWidget.renderFlutterWidget to save to the shared container
  /// that both the main app and widget extension can access
  static Future<void> _copyBackgroundForWidget(String? assetPath) async {
    if (assetPath == null) return;

    try {
      // iOS only - Android uses different approach
      if (!Platform.isIOS) return;

      print('WidgetService: Rendering background for widget: $assetPath');

      // Load the image first to ensure it's fully loaded before rendering
      final ByteData data = await rootBundle.load(assetPath);
      final ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ui.Image image = frameInfo.image;

      print('WidgetService: Image loaded: ${image.width}x${image.height}');

      // Use renderFlutterWidget with RawImage which doesn't need async loading
      await HomeWidget.renderFlutterWidget(
        RawImage(
          image: image,
          fit: BoxFit.cover,
          width: 400,
          height: 400,
        ),
        key: 'widget_background_image',
        logicalSize: const Size(400, 400),
        pixelRatio: 2.0, // For retina display
      );

      print('WidgetService: Background rendered to App Group container');
    } catch (e) {
      print('WidgetService: _copyBackgroundForWidget error: $e');
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
      print('WidgetService: updateWidget result = $result');
    } catch (e) {
      print('WidgetService: updateWidget error: $e');
    }
  }

  /// Register callback for widget interactions
  static Future<void> registerInteractivityCallback(
    Future<void> Function(Uri?) callback,
  ) async {
    try {
      await HomeWidget.registerInteractivityCallback(callback);
    } catch (e) {
      print('WidgetService: registerInteractivityCallback error: $e');
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

      print('WidgetService: forceRefresh - theme=$themeId, verse=$verseId');
      print('WidgetService: forceRefresh - colors: $startColor -> $endColor');
      print('WidgetService: forceRefresh - backgroundImage=${theme.backgroundImage}');

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
      print('WidgetService: forceRefresh complete');
    } catch (e) {
      print('WidgetService: forceRefreshWidget error: $e');
    }
  }
}
