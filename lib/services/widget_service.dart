import 'package:home_widget/home_widget.dart';
import '../data/content_data.dart';
import 'dart:math';

class WidgetService {
  static const String appGroupId = 'group.com.example.biblewidgets';
  static const String iOSWidgetName = 'BibleWidget';
  static const String androidWidgetName = 'BibleWidgetProvider';

  /// Initialize the widget service
  static Future<void> initialize() async {
    await HomeWidget.setAppGroupId(appGroupId);
  }

  /// Update the widget with a random verse
  static Future<void> updateWidgetWithRandomVerse() async {
    final verses = ContentData.verses;
    final randomVerse = verses[Random().nextInt(verses.length)];

    await HomeWidget.saveWidgetData<String>(
      'widget_verse_text',
      randomVerse.text,
    );
    await HomeWidget.saveWidgetData<String>(
      'widget_verse_reference',
      randomVerse.reference ?? '',
    );

    await updateWidget();
  }

  /// Update the widget with a specific verse
  static Future<void> updateWidgetWithVerse(String text, String? reference) async {
    await HomeWidget.saveWidgetData<String>('widget_verse_text', text);
    await HomeWidget.saveWidgetData<String>(
      'widget_verse_reference',
      reference ?? '',
    );

    await updateWidget();
  }

  /// Trigger widget update
  static Future<void> updateWidget() async {
    try {
      await HomeWidget.updateWidget(
        name: androidWidgetName,
        iOSName: iOSWidgetName,
      );
    } catch (e) {
      print('Error updating widget: $e');
    }
  }

  /// Register callback for widget interactions
  static Future<void> registerInteractivityCallback(
    Future<void> Function(Uri?) callback,
  ) async {
    await HomeWidget.registerInteractivityCallback(callback);
  }
}
