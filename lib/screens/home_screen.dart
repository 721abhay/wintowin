import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../widgets/platform_badge.dart';
import '../widgets/stat_card.dart';
import '../widgets/adaptive_dialog.dart';

class HomeScreen extends StatelessWidget {
  final AppState appState;
  final Function(int) onNavigate;

  const HomeScreen({
    super.key,
    required this.appState,
    required this.onNavigate,
  });

  void _showAddFeatureDialog(BuildContext context) {
    final titleController = TextEditingController();
    final subtitleController = TextEditingController();
    String selectedCategory = 'Core';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add App Module',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Module / Feature Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: subtitleController,
                decoration: InputDecoration(
                  labelText: 'Description / Purpose',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () {
                  if (titleController.text.trim().isNotEmpty) {
                    appState.addItem(
                      title: titleController.text.trim(),
                      subtitle: subtitleController.text.trim().isEmpty
                          ? 'Custom cross-platform component'
                          : subtitleController.text.trim(),
                      category: selectedCategory,
                      iconData: Icons.extension_rounded,
                    );
                    Navigator.of(ctx).pop();
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Add to Project'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('WinToWin Mobile'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(child: PlatformBadge()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'iOS & Android Ready',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(Icons.bolt, color: Colors.amberAccent, size: 24),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Cross-Platform App Engine',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Compiled natively for iOS & Android with Material 3 and Cupertino fidelity.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showAddFeatureDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF4F46E5),
                      minimumSize: const Size(140, 42),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Feature Module'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Performance & Readiness Stats
            Text(
              'Performance & Readiness',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.35,
              children: [
                const StatCard(
                  title: 'Native FPS',
                  value: '120 FPS',
                  subtitle: 'Impeller Engine',
                  icon: Icons.speed_rounded,
                  accentColor: Color(0xFF10B981),
                ),
                StatCard(
                  title: 'Progress',
                  value: '${(appState.completionProgress * 100).toInt()}%',
                  subtitle: '${appState.completedCount}/${appState.totalCount} Complete',
                  icon: Icons.checklist_rounded,
                  accentColor: const Color(0xFF6366F1),
                ),
                const StatCard(
                  title: 'Android Target',
                  value: 'API 36',
                  subtitle: 'Material 3 Ready',
                  icon: Icons.android_rounded,
                  accentColor: Color(0xFF06B6D4),
                ),
                const StatCard(
                  title: 'iOS Target',
                  value: 'iOS 15-18+',
                  subtitle: 'Cupertino Fidelity',
                  icon: Icons.apple_rounded,
                  accentColor: Color(0xFFEC4899),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Feature Roadmap / Task List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Core Modules & Roadmap',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                TextButton(
                  onPressed: () => onNavigate(1),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: appState.items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = appState.items[index];
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (item.isCompleted ? const Color(0xFF10B981) : const Color(0xFF4F46E5))
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item.iconData,
                        color: item.isCompleted ? const Color(0xFF10B981) : const Color(0xFF4F46E5),
                        size: 20,
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                        color: item.isCompleted
                            ? (isDark ? Colors.grey[500] : Colors.grey[600])
                            : null,
                      ),
                    ),
                    subtitle: Text(
                      item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                    trailing: Checkbox(
                      value: item.isCompleted,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      activeColor: const Color(0xFF10B981),
                      onChanged: (_) => appState.toggleItemCompletion(item.id),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Quick Info Callout
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFF4F46E5), size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Ready to run on physical device or simulator. Type `flutter run` in your terminal.',
                      style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showAdaptiveCustomDialog(
                        context: context,
                        title: 'Build & Deploy Instructions',
                        content:
                            '• Android: Run `flutter build apk` or `flutter build appbundle`\n• iOS: Run `flutter build ipa` on macOS or use cloud CI/CD\n• Test: Run `flutter run` in terminal with any phone connected.',
                      );
                    },
                    child: const Text('Details'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
