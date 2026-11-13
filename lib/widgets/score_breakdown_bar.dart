import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ScoreBreakdownBar extends StatelessWidget {
  final double moneyScore;
  final double playerScore;
  final double totalPaid;
  final int playerPoints;

  const ScoreBreakdownBar({
    super.key,
    required this.moneyScore,
    required this.playerScore,
    required this.totalPaid,
    required this.playerPoints,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final totalWeight = (moneyScore + playerScore).clamp(0.1, 200.0);
    final moneyFlex = (moneyScore / totalWeight * 100).toInt().clamp(5, 95);
    final playerFlex = 100 - moneyFlex;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Two-segment horizontal bar
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Row(
            children: [
              Expanded(
                flex: moneyFlex,
                child: Container(
                  height: 6,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                flex: playerFlex,
                child: Container(
                  height: 6,
                  color: AppTheme.winGold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        // Numerical Labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Money ${moneyScore.toStringAsFixed(0)}% (₹${(totalPaid / 1000).toInt()}k)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppTheme.canvas : AppTheme.inkMuted,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppTheme.winGold,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Players ${playerScore.toStringAsFixed(0)}% ($playerPoints pts)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppTheme.canvas : AppTheme.inkMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
