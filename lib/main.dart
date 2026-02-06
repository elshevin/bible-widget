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

  runApp(BibleWidgetsApp(launchedFromWidget: launchedFromWidget));
}

class BibleWidgetsApp extends StatefulWidget {
  final bool launchedFromWidget;

  const BibleWidgetsApp({super.key, this.launchedFromWidget = false});

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
      await _syncWidgetContent();
    }

    // Sync theme to widget on app start
    await WidgetService.updateWidgetTheme(_appState.currentTheme.id);

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  /// Sync widget content to app - find and display the verse shown on widget
  Future<void> _syncWidgetContent() async {
    try {
      // First try to find by verse ID (most accurate)
      final verseId = await HomeWidget.getWidgetData<String>('widget_verse_id');
      if (verseId != null && verseId.isNotEmpty) {
        final feedContent = _appState.feedContent;
        for (int i = 0; i < feedContent.length; i++) {
          if (feedContent[i].id == verseId) {
            _appState.setFeedIndex(i);
            print('Found verse by ID: $verseId at index $i');
            return;
          }
        }
      }

      // Fallback: find by text match
      final widgetText = await HomeWidget.getWidgetData<String>('widget_verse_text');
      if (widgetText != null && widgetText.isNotEmpty) {
        final feedContent = _appState.feedContent;
        for (int i = 0; i < feedContent.length; i++) {
          if (feedContent[i].text == widgetText) {
            _appState.setFeedIndex(i);
            print('Found verse by text match at index $i');
            break;
          }
        }
      }
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
