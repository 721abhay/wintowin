import 'package:flutter/material.dart';
import '../widgets/adaptive_dialog.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final Map<String, bool> _checklist = {
    'Configure app bundle identifier (com.example.wintowin)': true,
    'Set up App Icons for iOS & Android': true,
    'Configure launch screen & splash': true,
    'Add Internet permission to AndroidManifest.xml': true,
    'Verify iOS Info.plist orientations & settings': true,
    'Generate Android Keystore for release signing': false,
    'Create Apple Developer Provisioning Profile & Certificate': false,
    'Test on physical Android device (flutter run)': false,
    'Test on iOS Simulator or Device': false,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completedCount = _checklist.values.where((v) => v).length;
    final totalCount = _checklist.length;
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Release Readiness'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Overview Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Store Readiness Score',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.5),
                      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$completedCount of $totalCount preparation steps completed.',
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Checklist Section
            Text(
              'Deployment Checklist',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),

            Card(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _checklist.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final key = _checklist.keys.elementAt(index);
                  final isDone = _checklist[key] ?? false;

                  return CheckboxListTile(
                    value: isDone,
                    title: Text(
                      key,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        decoration: isDone ? TextDecoration.lineThrough : null,
                        color: isDone ? Colors.grey : null,
                      ),
                    ),
                    activeColor: const Color(0xFF10B981),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (val) {
                      setState(() {
                        _checklist[key] = val ?? false;
                      });
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // CLI Commands Guide Card
            Text(
              'Terminal Build Commands',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),

            _buildCommandTile(
              context,
              platform: 'Android APK (Testing)',
              command: 'flutter build apk --split-per-abi',
              description: 'Generates optimized release APKs for ARM64 and ARMv7 devices.',
            ),
            const SizedBox(height: 10),
            _buildCommandTile(
              context,
              platform: 'Android AAB (Play Store)',
              command: 'flutter build appbundle',
              description: 'Generates Google Play Android App Bundle with dynamic asset delivery.',
            ),
            const SizedBox(height: 10),
            _buildCommandTile(
              context,
              platform: 'iOS IPA (App Store / TestFlight)',
              command: 'flutter build ipa',
              description: 'Generates signed Xcode archive & IPA payload for TestFlight submission.',
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCommandTile(
    BuildContext context, {
    required String platform,
    required String command,
    required String description,
  }) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  platform,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline, size: 18),
                  onPressed: () {
                    showAdaptiveCustomDialog(
                      context: context,
                      title: platform,
                      content: '$description\n\nCommand:\n$command',
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                command,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
              ),
            ),
            const SizedBox(height: 6),
            Text(description, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
