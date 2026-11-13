import 'package:flutter/material.dart';
import '../../models/brand.dart';
import '../../models/reward.dart';
import '../../services/wintowin_state.dart';

class GameResultScreen extends StatelessWidget {
  final WinToWinState state;
  final bool isWon;
  final int playerScore;
  final int opponentScore;
  final String opponentName;
  final Brand opponentBrand;
  final int playerPointsAwarded;
  final int brandPointsAwarded;
  final Reward? droppedReward;
  final String gameTitle;

  const GameResultScreen({
    super.key,
    required this.state,
    required this.isWon,
    required this.playerScore,
    required this.opponentScore,
    required this.opponentName,
    required this.opponentBrand,
    required this.playerPointsAwarded,
    required this.brandPointsAwarded,
    this.droppedReward,
    required this.gameTitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final myBrand = state.playerBrand;

    final primaryBannerColor = isWon ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    return Scaffold(
      appBar: AppBar(
        title: Text(gameTitle),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Victory or Defeat Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryBannerColor, primaryBannerColor.withValues(alpha: 0.85)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: primaryBannerColor.withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    isWon ? Icons.emoji_events_rounded : Icons.sports_score_rounded,
                    color: Colors.white,
                    size: 64,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isWon ? 'VICTORY!' : 'NICE TRY!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isWon
                        ? 'You dominated the duel and boosted ${myBrand.name}!'
                        : 'Close match against $opponentName!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Score: $playerScore  —  $opponentScore',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Points Contribution Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'POINTS CONTRIBUTED',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              '+$playerPointsAwarded',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: isWon ? const Color(0xFF10B981) : theme.colorScheme.primary,
                              ),
                            ),
                            const Text(
                              'Player Points',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Container(height: 40, width: 1, color: isDark ? Colors.white12 : Colors.black12),
                        Column(
                          children: [
                            Text(
                              '+$brandPointsAwarded',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: myBrand.brandColor,
                              ),
                            ),
                            Text(
                              'For ${myBrand.name}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: state.player.dailyPointsEarned / state.player.dailyPointCap,
                      borderRadius: BorderRadius.circular(6),
                      minHeight: 8,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Daily Cap: ${state.player.dailyPointsEarned} / ${state.player.dailyPointCap} pts',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Reward Drop Card (if any dropped)
            if (droppedReward != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.redeem_rounded, color: Color(0xFFD97706), size: 30),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '🎁 REWARD UNLOCKED!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            droppedReward!.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Added to your Rewards Wallet',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Action Buttons
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).pop(); // Back to Play screen
              },
              icon: const Icon(Icons.replay_rounded),
              label: const Text('Play Another Match'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Return to Home'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

