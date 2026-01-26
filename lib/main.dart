import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/app_state.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'services/widget_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

class BibleWidgetsApp extends StatelessWidget {
  const BibleWidgetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState()..initialize(),
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
