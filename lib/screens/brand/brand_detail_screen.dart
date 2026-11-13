import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/brand.dart';
import '../../services/wintowin_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/adaptive_dialog.dart';
import '../../widgets/score_breakdown_bar.dart';

class BrandDetailScreen extends StatelessWidget {
  final Brand brand;
  final WinToWinState state;

  const BrandDetailScreen({
    super.key,
    required this.brand,
    required this.state,
  });

  Future<void> _openStore(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (context.mounted) {
        showAdaptiveCustomDialog(
          context: context,
          title: 'Direct Brand Link',
          content: 'Visit $url in your browser to view official products and sales.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final rankedList = state.rankedBrands;
    final currentRank = rankedList.indexWhere((b) => b.id == brand.id) + 1;
    final isRankOne = currentRank == 1;

    final maxPaid = state.maxPaidAmount;
    final maxPoints = state.maxPlayerPoints;

    final double moneyScore = maxPaid > 0 ? (brand.totalPaidAmount / maxPaid) * 100 : 0.0;
    final double playScore = maxPoints > 0 ? (brand.playerPoints / maxPoints) * 100 : 0.0;
    final double combinedScore = brand.calculateCombinedScore(maxPaid, maxPoints);

    final isMyBrand = state.playerBrand.id == brand.id;

    // Filter products & rewards for this brand
    final brandProducts = state.products.where((p) => p.brandId == brand.id).toList();
    final brandRewards = state.rewards.where((r) => r.brandId == brand.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(brand.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Brand Profile Card (With 4dp stripe - DESIGN.md Section 3.3 & 13)
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 4,
                    width: double.infinity,
                    color: brand.brandColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: brand.brandColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(brand.icon, color: Colors.white, size: 28),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        brand.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                      const SizedBox(width: 6),
                                      const Icon(Icons.verified_rounded, size: 16, color: AppTheme.primary),
                                    ],
                                  ),
                                  Text(
                                    brand.category,
                                    style: const TextStyle(fontSize: 12, color: AppTheme.inkMuted),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: isRankOne ? AppTheme.winGold : AppTheme.line,
                                  child: Text(
                                    '#$currentRank',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 13,
                                      color: isRankOne ? AppTheme.onGold : AppTheme.ink,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${combinedScore.toStringAsFixed(1)} pts',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          brand.tagline,
                          style: const TextStyle(fontSize: 14, height: 1.4),
                        ),
                        const SizedBox(height: 18),

                        // Score Breakdown Component
                        ScoreBreakdownBar(
                          moneyScore: moneyScore,
                          playerScore: playScore,
                          totalPaid: brand.totalPaidAmount,
                          playerPoints: brand.playerPoints,
                        ),

                        const SizedBox(height: 20),

                        // Supporter Status Action
                        if (isMyBrand)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppTheme.primary),
                            ),
                            child: const Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle_rounded, color: AppTheme.primary, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                    'You Are Actively Supporting This Brand',
                                    style: TextStyle(
                                      color: AppTheme.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          FilledButton.icon(
                            onPressed: () {
                              final success = state.switchSupportedBrand(brand.id);
                              if (success) {
                                showAdaptiveCustomDialog(
                                  context: context,
                                  title: 'Supported Brand Changed',
                                  content: 'You are now fighting for ${brand.name}!',
                                );
                              } else {
                                showAdaptiveCustomDialog(
                                  context: context,
                                  title: 'Cooldown Active',
                                  content:
                                      'Brand switches are limited to once every 7 days to preserve leaderboard fairness.',
                                );
                              }
                            },
                            icon: const Icon(Icons.favorite_rounded, size: 18),
                            label: Text('Support ${brand.name.split(" ").first} in 1v1 Games'),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Products Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Products from Brand',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                TextButton(
                  onPressed: () => _openStore(context, brand.websiteUrl),
                  child: const Text('Open Store'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (brandProducts.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      'More trending products from ${brand.name} coming soon.',
                      style: const TextStyle(color: AppTheme.inkMuted, fontSize: 13),
                    ),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: brandProducts.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final prod = brandProducts[index];
                  return Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          prod.imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 60,
                            height: 60,
                            color: brand.brandColor,
                            child: Icon(brand.icon, color: Colors.white, size: 24),
                          ),
                        ),
                      ),
                      title: Text(prod.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text(
                        '₹${prod.discountPrice.toInt()} (₹${prod.originalPrice.toInt()})',
                        style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
                      ),
                      trailing: FilledButton.tonal(
                        onPressed: () => _openStore(context, prod.storeUrl),
                        style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
                        child: const Text('Shop'),
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 24),

            // Rewards Offered Section
            const Text(
              'Rewards Offered by Brand',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            const SizedBox(height: 8),

            if (brandRewards.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      'Win 1v1 matches for ${brand.name} to unlock rewards!',
                      style: const TextStyle(color: AppTheme.inkMuted, fontSize: 13),
                    ),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: brandRewards.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final rew = brandRewards[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.redeem_rounded, color: AppTheme.primary),
                      title: Text(rew.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text(rew.description, style: const TextStyle(fontSize: 12)),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          rew.discountValue ?? 'Voucher',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primary),
                        ),
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
