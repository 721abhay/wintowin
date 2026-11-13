import 'package:flutter/material.dart';
import '../../models/brand.dart';
import '../../services/wintowin_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/adaptive_dialog.dart';
import '../main_navigation_screen.dart';

class ChooseBrandScreen extends StatelessWidget {
  final WinToWinState state;

  const ChooseBrandScreen({super.key, required this.state});

  void _confirmSelection(BuildContext context, Brand brand) {
    showAdaptiveCustomDialog(
      context: context,
      title: 'Support ${brand.name}?',
      content:
          'You are choosing to back ${brand.name}. Every 1v1 match win pushes them up the Brand Leaderboard.\n\nNote: You can switch brands later, with a 7-day cooldown.',
      confirmText: 'Confirm & Play',
      cancelText: 'Back',
      onConfirm: () {
        state.switchSupportedBrand(brand.id);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => MainNavigationScreen(state: state),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final brands = state.rankedBrands;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Your Brand'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose a Brand to Back',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.5),
              ),
              const SizedBox(height: 4),
              const Text(
                'Play 1v1 duels for your brand. Higher brand rank unlocks more prizes for supporters.',
                style: TextStyle(fontSize: 13, color: AppTheme.inkMuted),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: brands.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final brand = brands[index];
                    final rank = index + 1;
                    final isRankOne = rank == 1;

                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 4 dp stripe on card header
                          Container(height: 4, width: double.infinity, color: brand.brandColor),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: isRankOne ? AppTheme.winGold : AppTheme.line,
                                  child: Text(
                                    '#$rank',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                      color: isRankOne ? AppTheme.onGold : AppTheme.ink,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: brand.brandColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(brand.icon, color: Colors.white, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        brand.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      Text(
                                        '${brand.supportersCount} Supporters',
                                        style: const TextStyle(fontSize: 12, color: AppTheme.inkMuted),
                                      ),
                                    ],
                                  ),
                                ),
                                FilledButton(
                                  onPressed: () => _confirmSelection(context, brand),
                                  style: FilledButton.styleFrom(
                                    visualDensity: VisualDensity.compact,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('Support'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
