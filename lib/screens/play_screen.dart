import 'package:flutter/material.dart';
import '../services/wintowin_state.dart';
import '../widgets/adaptive_dialog.dart';
import 'games/matchmaking_screen.dart';

class PlayScreen extends StatelessWidget {
  final WinToWinState state;

  const PlayScreen({super.key, required this.state});

  void _launchGame(BuildContext context, String gameType) {
    if (state.player.hasReachedDailyCap) {
      showAdaptiveCustomDialog(
        context: context,
        title: 'Daily Point Cap Reached',
        content: 'You have earned the maximum 1,000 points for today to ensure fair play. You can still practice, but points won\'t count until midnight reset.',
        confirmText: 'Play Anyway',
        cancelText: 'Cancel',
        onConfirm: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MatchmakingScreen(state: state, gameType: gameType),
            ),
          );
        },
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MatchmakingScreen(state: state, gameType: gameType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final myBrand = state.playerBrand;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Arena'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Supporter Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: myBrand.brandColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: myBrand.brandColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: myBrand.brandColor,
                    child: Icon(myBrand.icon, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'You are fighting for ${myBrand.name}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: myBrand.brandColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Every win pushes your brand higher on the Leaderboard!',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Available 1v1 Battle Modes',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 12),

            // Game 1: 1v1 Brand Quiz Duel
            _buildGameCard(
              context,
              title: '1v1 Brand Trivia Duel',
              subtitle: '5 rapid-fire questions about brands, products, and culture. Speed grants bonus points!',
              badgeText: 'POPULAR',
              badgeColor: const Color(0xFF10B981),
              icon: Icons.psychology_rounded,
              gradient: const [Color(0xFF4F46E5), Color(0xFF7C3AED)],
              durationText: '1 - 2 mins',
              rewardChanceText: '65% Voucher Drop Chance',
              onTap: () => _launchGame(context, 'quiz'),
            ),

            const SizedBox(height: 16),

            // Game 2: 1v1 Reaction Tap Duel
            _buildGameCard(
              context,
              title: '1v1 Reflex Reaction Duel',
              subtitle: 'Wait for the screen to turn GREEN and tap faster than your rival. Best of 3 rounds!',
              badgeText: 'FASTEST',
              badgeColor: const Color(0xFFF59E0B),
              icon: Icons.flash_on_rounded,
              gradient: const [Color(0xFF0284C7), Color(0xFF0F766E)],
              durationText: '45 seconds',
              rewardChanceText: '70% Voucher Drop Chance',
              onTap: () => _launchGame(context, 'reaction'),
            ),

            const SizedBox(height: 24),

            // Upcoming Game: Team Territory Map Capture (PRD Phase 3)
            Text(
              'Coming Soon (Phase 2 & 3)',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.map_rounded, size: 28),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Territory Map Capture',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Zone & city-limited group battles. Teams capture area sectors for their brand.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
    required IconData icon,
    required List<Color> gradient,
    required String durationText,
    required String rewardChanceText,
    required VoidCallback onTap,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [gradient.first.withValues(alpha: 0.15), gradient.last.withValues(alpha: 0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
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
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badgeText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 14),
                      const SizedBox(width: 4),
                      Text(durationText, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: gradient),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.redeem_rounded, size: 16, color: Color(0xFFF59E0B)),
                      const SizedBox(width: 6),
                      Text(
                        rewardChanceText,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF59E0B),
                        ),
                      ),
                    ],
                  ),
                  FilledButton.icon(
                    onPressed: onTap,
                    icon: const Icon(Icons.play_arrow_rounded, size: 18),
                    label: const Text('Play 1v1'),
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
