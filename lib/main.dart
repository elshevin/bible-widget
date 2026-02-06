import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:home_widget/home_widget.dart';
import 'theme/app_theme.dart';
import 'providers/app_state.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'services/widget_service.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';
import 'data/content_data.dart';

// Global key to access app state from widget callback
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage service first
  await StorageService.init();

  // Initialize notification service
  await NotificationService.initialize();

  // Initialize widget service
  await WidgetService.initialize();

  // Check if app was launched from widget click
  final launchUri = await HomeWidget.initiallyLaunchedFromHomeWidget();
  final launchedFromWidget = launchUri != null;

  // Extract verse ID from launch URI if available
  // URI format: biblewidgets://verse?id=xxx
  String? launchVerseId;
  if (launchUri != null) {
    launchVerseId = launchUri.queryParameters['id'];
    print('App launched from widget with URI: $launchUri');
    print('Extracted verse ID: $launchVerseId');
  }

  // Load saved theme and sync to widget BEFORE updating verse content
  // This ensures widget always has correct theme colors
  final savedThemeId = await StorageService.loadThemeId();
  await WidgetService.updateWidgetTheme(savedThemeId);

  // Only update widget with random verse if NOT launched from widget
  // This preserves the content user clicked on
  if (!launchedFromWidget) {
    await WidgetService.updateWidgetWithRandomVerse();
  }

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  runApp(BibleWidgetsApp(
    launchedFromWidget: launchedFromWidget,
    launchVerseId: launchVerseId,
  ));
}

class BibleWidgetsApp extends StatefulWidget {
  final bool launchedFromWidget;
  final String? launchVerseId;

  const BibleWidgetsApp({
    super.key,
    this.launchedFromWidget = false,
    this.launchVerseId,
  });

  @override
  State<BibleWidgetsApp> createState() => _BibleWidgetsAppState();
}

class _BibleWidgetsAppState extends State<BibleWidgetsApp> {
  late AppState _appState;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _appState = AppState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _appState.initialize();

    // If launched from widget, sync the displayed verse
    if (widget.launchedFromWidget) {
      await _syncWidgetContent(widget.launchVerseId);
    }

    // Sync current verse and theme to widget on app start
    // This ensures widget always shows what's in the app
    final currentVerse = _appState.currentVerse;
    if (currentVerse != null) {
      await WidgetService.forceRefreshWidget(
        _appState.currentTheme.id,
        currentVerse.text,
        currentVerse.reference,
        currentVerse.id,
      );
    } else {
      // Just update theme if no verse
      await WidgetService.updateWidgetTheme(_appState.currentTheme.id);
    }

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  /// Sync widget content to app - find and display the verse shown on widget
  /// [launchVerseId] - verse ID from the launch URL (if available)
  Future<void> _syncWidgetContent(String? launchVerseId) async {
    try {
      // Get widget data - try launch ID first, then fall back to stored data
      String? verseId = launchVerseId;
      String? widgetText;

      if (verseId == null || verseId.isEmpty) {
        verseId = await HomeWidget.getWidgetData<String>('widget_verse_id');
      }
      widgetText = await HomeWidget.getWidgetData<String>('widget_verse_text');

      print('Widget sync: launchVerseId=$launchVerseId, storedVerseId=$verseId');
      print('Widget sync: text=${widgetText?.substring(0, min(30, widgetText?.length ?? 0))}...');

      // First search in feedContent by ID
      if (verseId != null && verseId.isNotEmpty) {
        final feedContent = _appState.feedContent;
        for (int i = 0; i < feedContent.length; i++) {
          if (feedContent[i].id == verseId) {
            _appState.setFeedIndex(i);
            print('Found verse by ID in feed: $verseId at index $i');
            return;
          }
        }
      }

      // If not found by ID, search by text in feedContent
      if (widgetText != null && widgetText.isNotEmpty) {
        final feedContent = _appState.feedContent;
        for (int i = 0; i < feedContent.length; i++) {
          if (feedContent[i].text == widgetText) {
            _appState.setFeedIndex(i);
            print('Found verse by text in feed at index $i');
            return;
          }
        }
      }

      // If still not found, search in ALL verses and add to feed
      if (verseId != null && verseId.isNotEmpty) {
        // Search in all verses from ContentData
        for (final verse in ContentData.verses) {
          if (verse.id == verseId) {
            // Found the verse - insert it at the beginning of feed
            _appState.insertVerseAtFront(verse);
            print('Found verse in all content, inserted at front: $verseId');
            return;
          }
        }
      }

      print('Widget sync: Could not find matching verse');
    } catch (e) {
      print('Error syncing widget content: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      // Show splash screen while loading
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const Scaffold(
          backgroundColor: Color(0xFF1A1A2E),
          body: Center(
            child: CircularProgressIndicator(
              color: Color(0xFFD4A574),
            ),
          ),
        ),
      );
    }

    return ChangeNotifierProvider.value(
      value: _appState,
      child: Consumer<AppState>(
        builder: (context, appState, _) {
          return MaterialApp(
            title: 'Bible Widgets',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.theme,
            home: appState.hasCompletedOnboarding
                ? const HomeScreen()
                : const WelcomeScreen(),
          );
        },
      ),
    );
  }
}
