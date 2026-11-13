import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformBadge extends StatelessWidget {
  const PlatformBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final platform = defaultTargetPlatform;
    String label;
    IconData icon;
    Color color;

    switch (platform) {
      case TargetPlatform.iOS:
        label = 'Apple iOS';
        icon = Icons.apple;
        color = const Color(0xFF007AFF);
        break;
      case TargetPlatform.android:
        label = 'Google Android';
        icon = Icons.android;
        color = const Color(0xFF3DDC84);
        break;
      case TargetPlatform.macOS:
        label = 'Apple macOS';
        icon = Icons.laptop_mac;
        color = const Color(0xFF5856D6);
        break;
      case TargetPlatform.windows:
        label = 'Microsoft Windows';
        icon = Icons.desktop_windows;
        color = const Color(0xFF0078D4);
        break;
      default:
        label = 'Cross-Platform';
        icon = Icons.devices;
        color = const Color(0xFF4F46E5);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
