import 'package:flutter/material.dart';
import '../services/wintowin_state.dart';
import '../widgets/adaptive_dialog.dart';

class ProfileScreen extends StatelessWidget {
  final WinToWinState state;

  const ProfileScreen({super.key, required this.state});

  void _showSwitchBrandDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pick a Brand to Support',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Notice: You can only switch brands once every 7 days to prevent hopping to whichever brand is winning.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.rankedBrands.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final brand = state.rankedBrands[index];
                  final isCurrent = brand.id == state.playerBrand.id;

                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isCurrent ? themeColor(context) : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    tileColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                    leading: CircleAvatar(
                      backgroundColor: brand.brandColor,
                      child: Icon(brand.icon, color: Colors.white, size: 18),
                    ),
                    title: Text(brand.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${brand.supportersCount} Supporters • Rank #${index + 1}'),
                    trailing: isCurrent
                        ? const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981))
                        : const Icon(Icons.chevron_right),
                    onTap: isCurrent
                        ? null
                        : () {
                            Navigator.of(ctx).pop();
                            final success = state.switchSupportedBrand(brand.id);
                            if (!success) {
                              showAdaptiveCustomDialog(
                                context: context,
                                title: 'Cooldown Active',
                                content:
                                    'You recently switched your brand. To keep brand leaderboards fair, you can switch again after your 7-day cooldown expires.',
                              );
                            } else {
                              showAdaptiveCustomDialog(
                                context: context,
                                title: 'Brand Switched!',
                                content:
                                    'You are now fighting for ${brand.name}! Every 1v1 match win will push ${brand.name} up the leaderboard.',
                              );
                            }
                          },
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Color themeColor(BuildContext context) => Theme.of(context).colorScheme.primary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final player = state.player;
    final myBrand = state.playerBrand;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Profile Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: theme.colorScheme.primary,
                    child: Text(
                      player.name.split(" ").map((w) => w[0]).take(2).join(),
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          player.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          player.phoneNumber,
                          style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Verified Player Account',
                            style: TextStyle(color: Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Supported Brand Section
          Text(
            'MY SUPPORTED BRAND',
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
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: myBrand.brandColor,
                    child: Icon(myBrand.icon, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          myBrand.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          'Rank #${state.rankedBrands.indexWhere((b) => b.id == myBrand.id) + 1} on Leaderboard',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: () => _showSwitchBrandDialog(context),
                    style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
                    child: const Text('Switch'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Match Statistics
          Text(
            'MATCH PERFORMANCE',
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatColumn('Wins', '${player.totalWins}', const Color(0xFF10B981)),
                  _buildStatColumn('Matches', '${player.totalMatches}', theme.colorScheme.primary),
                  _buildStatColumn('Win Rate', '${player.winRate.toStringAsFixed(0)}%', const Color(0xFF0284C7)),
                  _buildStatColumn('Streak', '${player.streakDays} Days', const Color(0xFFF59E0B)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Daily Point Cap Tracker (Anti-Cheat & Fairness PRD Section 5.9)
          Text(
            'FAIR PLAY & DAILY CAP',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Daily Point Cap',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        '${player.dailyPointsEarned} / ${player.dailyPointCap} pts',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: player.dailyPointsEarned / player.dailyPointCap,
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'WinToWin limits daily gameplay points to 1,000 per user to prevent bot farms and ensure fair competition for all brands.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Appearance Settings
          Text(
            'APP THEME',
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
              child: SizedBox(
                width: double.infinity,
                child: SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.system,
                      label: Text('System'),
                      icon: Icon(Icons.brightness_auto_rounded, size: 16),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.light,
                      label: Text('Light'),
                      icon: Icon(Icons.light_mode_rounded, size: 16),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.dark,
                      label: Text('Dark'),
                      icon: Icon(Icons.dark_mode_rounded, size: 16),
                    ),
                  ],
                  selected: {state.themeMode},
                  onSelectionChanged: (newSelection) {
                    state.setThemeMode(newSelection.first);
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // About & Fair Play Policy
          Card(
            child: ListTile(
              leading: const Icon(Icons.verified_user_rounded, color: Color(0xFF10B981)),
              title: const Text('WinToWin Fair Play Guarantee'),
              subtitle: const Text('Free to play forever • No pay-to-win for players'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showAdaptiveCustomDialog(
                  context: context,
                  title: 'WinToWin Guarantee',
                  content:
                      '1. Players never pay any money to play or win prizes.\n2. Brands fund all prize pools and pay for leaderboard rank.\n3. Brand ranks are 50% paid investment + 50% player game performance.\n4. All delivery & fulfillment is handled directly by verified brands.',
                );
              },
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
