import 'package:flutter/material.dart';
import '../models/brand.dart';
import '../services/wintowin_state.dart';
import '../theme/app_theme.dart';
import '../widgets/adaptive_dialog.dart';
import '../widgets/score_breakdown_bar.dart';
import 'brand/brand_detail_screen.dart';

class LeaderboardScreen extends StatefulWidget {
  final WinToWinState state;

  const LeaderboardScreen({super.key, required this.state});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int _selectedTab = 0; // 0 = Brands, 1 = Players

  void _showBoostBrandDialog(BuildContext context, Brand brand, double minAmountToOvertake) {
    final amountController = TextEditingController(
      text: minAmountToOvertake > 0 ? (minAmountToOvertake + 5000).toInt().toString() : '25000',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: brand.brandColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(brand.icon, size: 18, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Boost ${brand.name}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Brand payment through Razorpay / Stripe to climb the Brand Leaderboard. Rank is 50% Money + 50% Gameplay.',
                style: TextStyle(fontSize: 13, color: AppTheme.inkMuted),
              ),
              const SizedBox(height: 16),
              if (minAmountToOvertake > 0)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.winGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.winGold),
                  ),
                  child: Text(
                    '⚡ Min. ₹${minAmountToOvertake.toInt()} needed to overtake the brand above.',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.onGold),
                  ),
                ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Boost Amount (₹ INR)',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () {
                  final entered = double.tryParse(amountController.text.trim()) ?? 0.0;
                  if (entered > 0) {
                    widget.state.boostBrandPayment(
                      brandId: brand.id,
                      additionalAmount: entered,
                    );
                    Navigator.of(ctx).pop();
                    showAdaptiveCustomDialog(
                      context: context,
                      title: 'Payment Successful (Razorpay)',
                      content:
                          '₹${entered.toInt()} payment processed for ${brand.name}.\nMoney score increased and brand leaderboard recalculated instantly!',
                    );
                  }
                },
                icon: const Icon(Icons.payments_rounded),
                label: const Text('Simulate Razorpay Payment'),
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

    final rankedBrands = widget.state.rankedBrands;
    final maxPaid = widget.state.maxPaidAmount;
    final maxPoints = widget.state.maxPlayerPoints;
    final topPlayers = widget.state.topPlayers;
    final myBrand = widget.state.playerBrand;

    final myBrandRank = rankedBrands.indexWhere((b) => b.id == myBrand.id) + 1;
    final myBrandScore = myBrand.calculateCombinedScore(maxPaid, maxPoints);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Leaderboards'),
      ),
      body: Column(
        children: [
          // Segmented Switcher (Brands vs Players)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<int>(
                segments: const [
                  ButtonSegment<int>(
                    value: 0,
                    label: Text('Brand Rankings'),
                    icon: Icon(Icons.business_rounded, size: 18),
                  ),
                  ButtonSegment<int>(
                    value: 1,
                    label: Text('Top Supporters'),
                    icon: Icon(Icons.leaderboard_rounded, size: 18),
                  ),
                ],
                selected: {_selectedTab},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    _selectedTab = newSelection.first;
                  });
                },
              ),
            ),
          ),

          // Brands Leaderboard Tab
          if (_selectedTab == 0) ...[
            // Formula Information Box (DESIGN.md Section 1 & 6.4)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.line),
              ),
              child: const Row(
                children: [
                  Icon(Icons.balance_rounded, size: 18, color: AppTheme.primary),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Rank Score = 50% Money Score + 50% Gameplay Points. Fixed layout for all brands.',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 80), // Padding for sticky bottom row
                itemCount: rankedBrands.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final brand = rankedBrands[index];
                  final rank = index + 1;
                  final combinedScore = brand.calculateCombinedScore(maxPaid, maxPoints);

                  final double moneyScore = maxPaid > 0 ? (brand.totalPaidAmount / maxPaid) * 100 : 0.0;
                  final double playScore = maxPoints > 0 ? (brand.playerPoints / maxPoints) * 100 : 0.0;

                  // Overtake calculation
                  double amountToOvertake = 0.0;
                  if (index > 0) {
                    final brandAbove = rankedBrands[index - 1];
                    amountToOvertake = (brandAbove.totalPaidAmount - brand.totalPaidAmount) + 5000;
                  }

                  // Rank Badge (DESIGN.md Section 6.3)
                  // Gold fill for rank 1, line fill with ink text for others
                  final isRankOne = rank == 1;

                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BrandDetailScreen(brand: brand, state: widget.state),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 4 dp stripe on that brand's card header (DESIGN.md Section 3.3)
                          Container(
                            height: 4,
                            width: double.infinity,
                            color: brand.brandColor,
                          ),

                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // Rank badge (Circle with rank number)
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: isRankOne ? AppTheme.winGold : AppTheme.line,
                                    child: Text(
                                      '#$rank',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13,
                                        color: isRankOne ? AppTheme.onGold : AppTheme.ink,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Brand logo chip background only (DESIGN.md Section 3.3)
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: brand.brandColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(brand.icon, color: Colors.white, size: 18),
                                  ),
                                  const SizedBox(width: 12),

                                  // Brand Name & Supporter count
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

                                  // Combined Score (Tabular figures)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        combinedScore.toStringAsFixed(1),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 20,
                                          fontFeatures: [FontFeature.tabularFigures()],
                                          color: AppTheme.primary,
                                        ),
                                      ),
                                      const Text(
                                        'Final Score',
                                        style: TextStyle(fontSize: 11, color: AppTheme.inkMuted),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              // Reusable Score Breakdown Bar (DESIGN.md Section 6.4)
                              ScoreBreakdownBar(
                                moneyScore: moneyScore,
                                playerScore: playScore,
                                totalPaid: brand.totalPaidAmount,
                                playerPoints: brand.playerPoints,
                              ),

                              const SizedBox(height: 12),

                              // Overtake notice or Top Leader badge
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  if (rank == 1)
                                    const Text(
                                      '👑 Defending #1 Leader',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.warning,
                                      ),
                                    )
                                  else
                                    Text(
                                      'Needs ₹${amountToOvertake.toInt()} to pass #${rank - 1}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.danger,
                                      ),
                                    ),
                                  FilledButton.tonal(
                                    onPressed: () => _showBoostBrandDialog(context, brand, amountToOvertake),
                                    style: FilledButton.styleFrom(
                                      visualDensity: VisualDensity.compact,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Boost (Brand Pay)'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
                },
              ),
            ),

            // Sticky "Your Brand" Row at bottom (DESIGN.md Section 13)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.ink : AppTheme.surface,
                border: const Border(top: BorderSide(color: AppTheme.line, width: 1.5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    offset: const Offset(0, -3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: myBrand.brandColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(myBrand.icon, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Your Brand: ${myBrand.name}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Text(
                          'Rank #$myBrandRank • Score ${myBrandScore.toStringAsFixed(1)}',
                          style: const TextStyle(fontSize: 11, color: AppTheme.inkMuted),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/play');
                    },
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: const Text('Play for Brand'),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Players Leaderboard Tab
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: topPlayers.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final player = topPlayers[index];
                  final isMe = player.name.contains('(You)');

                  return Card(
                    color: isMe ? AppTheme.primary.withValues(alpha: 0.08) : null,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: player.avatarColor,
                        child: Text(
                          player.avatarInitials,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Row(
                        children: [
                          Text(
                            player.name,
                            style: TextStyle(
                              fontWeight: isMe ? FontWeight.w900 : FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          if (isMe) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'YOU',
                                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Icon(player.brandIcon, size: 14),
                          const SizedBox(width: 4),
                          Text('${player.brandName} Supporter • ${player.wins} Wins'),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '#${player.rank}',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              color: player.rank == 1 ? AppTheme.winGold : null,
                            ),
                          ),
                          Text(
                            '${player.points} pts',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
