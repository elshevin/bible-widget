import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import '../data/content_data.dart';
import '../theme/app_theme.dart';
import 'dart:math';

class WidgetService {
  static const String appGroupId = 'group.com.example.biblewidgets';
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

      await updateWidget();
      print('WidgetService: widget updated successfully');
    } catch (e) {
      print('WidgetService: updateWidgetWithRandomVerse error: $e');
    }
  }

  /// Update the widget with a specific verse
  static Future<void> updateWidgetWithVerse(String text, String? reference) async {
    try {
      await HomeWidget.saveWidgetData<String>('widget_verse_text', text);
      await HomeWidget.saveWidgetData<String>(
        'widget_verse_reference',
        reference ?? '',
      );

      await updateWidget();
    } catch (e) {
      print('WidgetService: updateWidgetWithVerse error: $e');
    }
  }

  /// Update the widget theme colors
  static Future<void> updateWidgetTheme(String themeId) async {
    try {
      final theme = VisualThemes.getById(themeId);
      final colors = theme.gradientColors;

      // Save gradient colors as hex strings
      await HomeWidget.saveWidgetData<String>(
        'widget_start_color',
        _colorToHex(colors.first),
      );
      await HomeWidget.saveWidgetData<String>(
        'widget_end_color',
        _colorToHex(colors.last),
      );
      await HomeWidget.saveWidgetData<String>(
        'widget_text_color',
        _colorToHex(theme.textColor),
      );

      await updateWidget();
      print('WidgetService: theme updated to $themeId');
    } catch (e) {
      print('WidgetService: updateWidgetTheme error: $e');
    }
  }

  static String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  /// Trigger widget update
  static Future<void> updateWidget() async {
    try {
      await HomeWidget.updateWidget(
        name: androidWidgetName,
        iOSName: iOSWidgetName,
      );
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
}
