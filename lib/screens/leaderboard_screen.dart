import 'package:flutter/material.dart';
import '../models/brand.dart';
import '../services/wintowin_state.dart';
import '../widgets/adaptive_dialog.dart';

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
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: brand.brandColor,
                        child: Icon(brand.icon, size: 16, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Boost ${brand.name.split(" ").first} Rank',
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
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 16),
              if (minAmountToOvertake > 0)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    '⚡ Min. ₹${minAmountToOvertake.toInt()} needed to overtake the brand above.',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFB45309)),
                  ),
                ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Boost Amount (₹ INR)',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
            // Formula Information Box (PRD Section 7)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.balance_rounded, size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Rank Score = 50% Money Score + 50% Gameplay Points. 100% Public & Fair.',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: rankedBrands.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final brand = rankedBrands[index];
                  final rank = index + 1;
                  final combinedScore = brand.calculateCombinedScore(maxPaid, maxPoints);

                  // Calculate amount needed to pass the brand above (PRD Section 5.4)
                  double amountToOvertake = 0.0;
                  if (index > 0) {
                    final brandAbove = rankedBrands[index - 1];
                    amountToOvertake = (brandAbove.totalPaidAmount - brand.totalPaidAmount) + 5000;
                  }

                  Color rankBadgeColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
                  Color rankTextColor = isDark ? Colors.white : Colors.black87;

                  if (rank == 1) {
                    rankBadgeColor = const Color(0xFFF59E0B);
                    rankTextColor = Colors.black87;
                  } else if (rank == 2) {
                    rankBadgeColor = const Color(0xFF94A3B8);
                    rankTextColor = Colors.black87;
                  } else if (rank == 3) {
                    rankBadgeColor = const Color(0xFFB45309);
                    rankTextColor = Colors.white;
                  }

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Rank Number
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: rankBadgeColor,
                                child: Text(
                                  '#$rank',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                    color: rankTextColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Brand Icon & Name
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: brand.brandColor,
                                child: Icon(brand.icon, color: Colors.white, size: 18),
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
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),

                              // Combined Rank Score
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    combinedScore.toStringAsFixed(1),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  const Text(
                                    'Score',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // Transparent Score Breakdown (PRD Section 7)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Paid: ₹${(brand.totalPaidAmount / 1000).toInt()}k',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                                Container(height: 12, width: 1, color: isDark ? Colors.white24 : Colors.black26),
                                Text(
                                  'Player Points: ${brand.playerPoints}',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Overtake notice or Top Leader badge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (rank == 1)
                                const Text(
                                  '👑 Defending #1 Champion',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFF59E0B)),
                                )
                              else
                                Text(
                                  'Needs ₹${amountToOvertake.toInt()} to pass #${rank - 1}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.error,
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
                  );
                },
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
                    color: isMe ? theme.colorScheme.primaryContainer.withValues(alpha: 0.4) : null,
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
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text('YOU', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
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
                              color: player.rank <= 3 ? const Color(0xFFF59E0B) : null,
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

