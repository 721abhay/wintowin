import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../widgets/adaptive_dialog.dart';

class SettingsScreen extends StatelessWidget {
  final AppState appState;

  const SettingsScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Configuration'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Section: Appearance
          Text(
            'APPEARANCE',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Color Theme',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Switch between light, dark, or system matching theme.',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<ThemeMode>(
                      segments: const [
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.system,
                          label: Text('System'),
                          icon: Icon(Icons.brightness_auto_rounded, size: 18),
                        ),
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.light,
                          label: Text('Light'),
                          icon: Icon(Icons.light_mode_rounded, size: 18),
                        ),
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.dark,
                          label: Text('Dark'),
                          icon: Icon(Icons.dark_mode_rounded, size: 18),
                        ),
                      ],
                      selected: {appState.themeMode},
                      onSelectionChanged: (newSelection) {
                        appState.setThemeMode(newSelection.first);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Section: Preferences
          Text(
            'PREFERENCES',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_active_rounded),
                  title: const Text('Push Notifications'),
                  subtitle: const Text('Alerts and background updates'),
                  value: appState.notificationsEnabled,
                  onChanged: (val) => appState.toggleNotifications(val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.fingerprint_rounded),
                  title: const Text('Biometric Login'),
                  subtitle: const Text('FaceID / Fingerprint security'),
                  value: appState.biometricsEnabled,
                  onChanged: (val) => appState.toggleBiometrics(val),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Section: Platform & Diagnostics
          Text(
            'PLATFORM DIAGNOSTICS',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.devices_other_rounded),
                  title: const Text('Active Runtime Target'),
                  trailing: Text(
                    defaultTargetPlatform.name.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.flutter_dash),
                  title: Text('Flutter Framework'),
                  trailing: Text(
                    'v3.38+ (Material 3)',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.code_rounded),
                  title: Text('Dart SDK'),
                  trailing: Text(
                    'v3.10+ Null Safe',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.layers_rounded),
                  title: Text('Rendering Pipeline'),
                  trailing: Text(
                    'Impeller / Skia',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Section: About
          Text(
            'ABOUT',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: const Text('About WinToWin App'),
              subtitle: const Text('v1.0.0 (Build 1) • Cross-Platform Mobile'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showAdaptiveCustomDialog(
                  context: context,
                  title: 'WinToWin Mobile App',
                  content:
                      'Designed for universal execution across iOS and Android.\n\n• Package: com.example.wintowin\n• Architecture: Clean Flutter with Material 3 & Cupertino integration\n• Platforms: iOS 12+ & Android 5.0+ (API 21-36)',
                );
              },
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
