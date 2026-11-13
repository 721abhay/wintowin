import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/hardware_service.dart';
import '../widgets/adaptive_dialog.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _features = [
    {
      'id': 'camera',
      'title': 'Camera & Media Capture',
      'category': 'Hardware',
      'icon': Icons.camera_alt_rounded,
      'color': const Color(0xFF6366F1),
      'description': 'Access photo gallery and native camera streams on iOS and Android.',
      'package': 'image_picker',
      'canTest': true,
    },
    {
      'id': 'biometrics',
      'title': 'Biometric Authentication',
      'category': 'Security',
      'icon': Icons.fingerprint_rounded,
      'color': const Color(0xFF10B981),
      'description': 'Face ID/Touch ID on iOS; Fingerprint/BiometricPrompt on Android.',
      'package': 'local_auth',
      'canTest': true,
    },
    {
      'id': 'location',
      'title': 'Geolocation & GPS',
      'category': 'Hardware',
      'icon': Icons.location_on_rounded,
      'color': const Color(0xFFEC4899),
      'description': 'CoreLocation on iOS and FusedLocationProviderClient on Android.',
      'package': 'geolocator',
      'canTest': true,
    },
    {
      'id': 'storage',
      'title': 'Local Preferences & Cache',
      'category': 'Data',
      'icon': Icons.save_rounded,
      'color': const Color(0xFF06B6D4),
      'description': 'NSUserDefaults on iOS and SharedPreferences on Android.',
      'package': 'shared_preferences',
      'canTest': true,
    },
    {
      'id': 'database',
      'title': 'Relational SQLite Database',
      'category': 'Data',
      'icon': Icons.storage_rounded,
      'color': const Color(0xFF3B82F6),
      'description': 'High-performance relational SQLite tables and SQL queries.',
      'package': 'sqflite',
      'canTest': true,
    },
    {
      'id': 'network',
      'title': 'Network & REST HTTP',
      'category': 'Cloud',
      'icon': Icons.http_rounded,
      'color': const Color(0xFF14B8A6),
      'description': 'Fast HTTP client with connection pooling and JSON encoding.',
      'package': 'http',
      'canTest': true,
    },
    {
      'id': 'push',
      'title': 'Push Notifications',
      'category': 'Cloud',
      'icon': Icons.notifications_active_rounded,
      'color': const Color(0xFFF59E0B),
      'description': 'Apple APNs and Firebase Cloud Messaging (FCM) background handler.',
      'package': 'firebase_messaging',
      'canTest': false,
    },
  ];

  Future<void> _handleTestFeature(Map<String, dynamic> item) async {
    final id = item['id'] as String;

    if (id == 'biometrics') {
      final success = await HardwareService.instance.authenticateBiometric(
        reason: 'Verify biometric security on your phone',
      );
      if (mounted) {
        showAdaptiveCustomDialog(
          context: context,
          title: success ? 'Biometric Success!' : 'Biometric Notice',
          content: success
              ? 'Biometric sensor recognized you successfully!'
              : 'Biometrics unavailable or prompt was cancelled.',
        );
      }
    } else if (id == 'location') {
      final pos = await HardwareService.instance.getCurrentPosition();
      if (mounted) {
        showAdaptiveCustomDialog(
          context: context,
          title: pos != null ? 'GPS Position Acquired' : 'GPS Permission Denied',
          content: pos != null
              ? 'Latitude: ${pos.latitude.toStringAsFixed(5)}\nLongitude: ${pos.longitude.toStringAsFixed(5)}\nAltitude: ${pos.altitude.toStringAsFixed(1)}m'
              : 'Please enable Location in your device settings to test GPS.',
        );
      }
    } else if (id == 'camera') {
      final path = await HardwareService.instance.pickImage(source: ImageSource.gallery);
      if (mounted) {
        showAdaptiveCustomDialog(
          context: context,
          title: path != null ? 'Media Selected' : 'Media Picker',
          content: path != null ? 'Selected file path:\n$path' : 'No photo selected from gallery.',
        );
      }
    } else if (id == 'storage') {
      await HardwareService.instance.saveString('last_check', DateTime.now().toIso8601String());
      final val = await HardwareService.instance.getString('last_check');
      if (mounted) {
        showAdaptiveCustomDialog(
          context: context,
          title: 'SharedPreferences Tested',
          content: 'Stored and retrieved key "last_check":\n$val',
        );
      }
    } else if (id == 'database') {
      final db = await HardwareService.instance.database;
      final tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='notes'");
      if (mounted) {
        showAdaptiveCustomDialog(
          context: context,
          title: 'SQLite Database Ready',
          content: 'Database path:\n${db.path}\n\nSchema: ${tables.isNotEmpty ? "Table 'notes' verified" : "Initialized"}',
        );
      }
    } else if (id == 'network') {
      final res = await HardwareService.instance.fetchJson('https://api.github.com');
      if (mounted) {
        showAdaptiveCustomDialog(
          context: context,
          title: 'HTTP Network Success',
          content: res != null
              ? 'Successfully fetched JSON payload from API.\nKeys: ${res.keys.take(5).join(", ")}...'
              : 'Failed to contact test endpoint. Check internet connection.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = ['All', 'Hardware', 'Security', 'Cloud', 'Data'];

    final filtered = _features.where((f) {
      final matchesCategory = _selectedCategory == 'All' || f['category'] == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          f['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          f['description'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Hardware & Modules'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search native features & capabilities...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Categories Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                );
              }).toList(),
            ),
          ),

          // Feature List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = filtered[index];
                final canTest = item['canTest'] as bool? ?? false;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: (item['color'] as Color).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                item['icon'] as IconData,
                                color: item['color'] as Color,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item['title'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.surfaceContainerHighest,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          item['category'],
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: theme.colorScheme.onSurfaceVariant,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item['description'],
                                    style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Package: ${item['package']}',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'monospace',
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (canTest)
                              FilledButton.tonalIcon(
                                onPressed: () => _handleTestFeature(item),
                                icon: const Icon(Icons.play_arrow_rounded, size: 16),
                                label: const Text('Test'),
                                style: FilledButton.styleFrom(
                                  visualDensity: VisualDensity.compact,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
