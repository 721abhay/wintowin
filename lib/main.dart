import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/supabase_config.dart';
import 'services/wintowin_state.dart';
import 'theme/app_theme.dart';
import 'screens/main_navigation_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase (with graceful offline fallback)
  await SupabaseConfig.initialize();

  // Crisp system overlay for iOS and Android
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
  final WinToWinState _state = WinToWinState();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _state,
      builder: (context, _) {
        return MaterialApp(
          title: 'WinToWin',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _state.themeMode,
          home: MainNavigationScreen(state: _state),
        );
      },
    );
  }
}
