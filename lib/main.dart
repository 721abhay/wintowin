import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure system overlay style looks crisp on both iOS and Android status bars
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(const WinToWinApp());
}

class WinToWinApp extends StatefulWidget {
  const WinToWinApp({super.key});

  @override
  State<WinToWinApp> createState() => _WinToWinAppState();
}

class _WinToWinAppState extends State<WinToWinApp> {
  final AppState _appState = AppState();

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (context, _) {
        return MaterialApp(
          title: 'WinToWin Mobile',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _appState.themeMode,
          home: MainNavigationScreen(appState: _appState),
        );
      },
    );
  }
}
