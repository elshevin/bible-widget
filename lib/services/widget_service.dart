import 'package:home_widget/home_widget.dart';
import '../data/content_data.dart';
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
