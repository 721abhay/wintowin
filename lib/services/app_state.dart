import 'package:flutter/material.dart';
import '../models/feature_item.dart';

class AppState extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _notificationsEnabled = true;
  bool _biometricsEnabled = false;

  final List<FeatureItem> _items = [
    FeatureItem(
      id: '1',
      title: 'iOS & Android Native Engine',
      subtitle: 'Compiles to 60/120 FPS native ARM code on both mobile platforms.',
      category: 'Core',
      iconData: Icons.phone_android,
      isCompleted: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    FeatureItem(
      id: '2',
      title: 'Adaptive Material 3 & Cupertino',
      subtitle: 'Dynamic typography, color scheme, and platform-specific dialogs.',
      category: 'UI/UX',
      iconData: Icons.style,
      isCompleted: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    FeatureItem(
      id: '3',
      title: 'State Management & Offline Ready',
      subtitle: 'Reactive state tracking with instant responsive UI updates.',
      category: 'Architecture',
      iconData: Icons.sync,
      isCompleted: false,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    FeatureItem(
      id: '4',
      title: 'Cross-Platform Build Pipelines',
      subtitle: 'Ready for Google Play Store (AAB) and Apple App Store (IPA).',
      category: 'DevOps',
      iconData: Icons.cloud_done,
      isCompleted: false,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  ThemeMode get themeMode => _themeMode;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get biometricsEnabled => _biometricsEnabled;
  List<FeatureItem> get items => List.unmodifiable(_items);

  int get completedCount => _items.where((item) => item.isCompleted).length;
  int get totalCount => _items.length;
  double get completionProgress => totalCount > 0 ? completedCount / totalCount : 0.0;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  void toggleBiometrics(bool value) {
    _biometricsEnabled = value;
    notifyListeners();
  }

  void toggleItemCompletion(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      final current = _items[index];
      _items[index] = current.copyWith(isCompleted: !current.isCompleted);
      notifyListeners();
    }
  }

  void addItem({
    required String title,
    required String subtitle,
    required String category,
    required IconData iconData,
  }) {
    final newItem = FeatureItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      subtitle: subtitle,
      category: category,
      iconData: iconData,
      isCompleted: false,
      timestamp: DateTime.now(),
    );
    _items.insert(0, newItem);
    notifyListeners();
  }

  void deleteItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}

