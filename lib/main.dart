import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/app_state.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'services/widget_service.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage service first
  await StorageService.init();

  // Initialize notification service
  await NotificationService.initialize();

  // Initialize widget service
  await WidgetService.initialize();
  // Update widget with a random verse on app start
  await WidgetService.updateWidgetWithRandomVerse();

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  runApp(const BibleWidgetsApp());
}

class BibleWidgetsApp extends StatefulWidget {
  const BibleWidgetsApp({super.key});

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
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
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
