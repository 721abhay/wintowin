import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/wintowin_state.dart';
import '../widgets/adaptive_dialog.dart';
import 'games/matchmaking_screen.dart';

class HomeScreen extends StatelessWidget {
  final WinToWinState state;
  final Function(int) onNavigate;

  const HomeScreen({
    super.key,
    required this.state,
    required this.onNavigate,
  });

  Future<void> _launchBrandUrl(BuildContext context, String urlString) async {
    final uri = Uri.parse(urlString);
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        showAdaptiveCustomDialog(
          context: context,
          title: 'Opening Brand Store',
          content: 'Opening $urlString in your browser. All purchases & delivery are fulfilled directly by the brand.',
        );
      }
    } catch (_) {
      if (context.mounted) {
        showAdaptiveCustomDialog(
          context: context,
          title: 'Direct Store Link',
          content: 'Visit $urlString directly to purchase and claim special supporter perks.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final topBrand = state.topBrand;
    final myBrand = state.playerBrand;
    final battles = state.battles;
    final trendingProducts = state.products;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.bolt, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Text('WinToWin', style: TextStyle(fontWeight: FontWeight.w900)),
          ],
        ),
        actions: [
          // Current Supported Brand Pill
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: myBrand.brandColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: myBrand.brandColor.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(myBrand.icon, size: 14, color: myBrand.brandColor),
                const SizedBox(width: 6),
                Text(
                  myBrand.name.split(" ").first,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: myBrand.brandColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. #1 Top Brand Banner (PRD Section 5.2)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    topBrand.brandColor,
                    topBrand.brandColor.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: topBrand.brandColor.withValues(alpha: 0.3),
                    blurRadius: 18,
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
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.workspace_premium_rounded, size: 16, color: Colors.black87),
                            SizedBox(width: 4),
                            Text(
                              'RANK #1 LEADER',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${topBrand.supportersCount} Supporters',
                        style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.white,
                        child: Icon(topBrand.icon, color: topBrand.brandColor, size: 30),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              topBrand.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                            ),
                            Text(
                              topBrand.tagline,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => onNavigate(1), // Go to Play
                          icon: const Icon(Icons.sports_esports_rounded, size: 18),
                          label: const Text('Play for Brand'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () => onNavigate(2), // Go to Leaderboard
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white70),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('View Board'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 2. Daily Player Cap & Supporter Status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'YOUR SUPPORTER POINTS',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: myBrand.brandColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Supporting ${myBrand.name.split(" ").first}',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: myBrand.brandColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${state.player.dailyPointsEarned} / ${state.player.dailyPointCap} pts',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                        Text(
                          '${state.player.remainingDailyPoints} pts left today',
                          style: TextStyle(
                            fontSize: 12,
                            color: state.player.hasReachedDailyCap ? Colors.red : const Color(0xFF10B981),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: state.player.dailyPointsEarned / state.player.dailyPointCap,
                        minHeight: 8,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 3. Live Brand Battles (PRD Section 5.2)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Live Brand Battles',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
                TextButton(
                  onPressed: () => onNavigate(1), // Go to Play
                  child: const Text('Join Clash'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: battles.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final battle = battles[index];
                final brandA = state.getBrandById(battle.brandAId)!;
                final brandB = state.getBrandById(battle.brandBId)!;

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
                              battle.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Ends in ${battle.endsIn.inHours}h ${battle.endsIn.inMinutes % 60}m',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Clash Bar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: brandA.brandColor,
                                  child: Icon(brandA.icon, size: 14, color: Colors.white),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${brandA.name.split(" ").first} (${battle.brandAPercentage.toStringAsFixed(0)}%)',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '(${battle.brandBPercentage.toStringAsFixed(0)}%) ${brandB.name.split(" ").first}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                const SizedBox(width: 8),
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: brandB.brandColor,
                                  child: Icon(brandB.icon, size: 14, color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Row(
                            children: [
                              Expanded(
                                flex: battle.brandAPlayerScore,
                                child: Container(height: 8, color: brandA.brandColor),
                              ),
                              Expanded(
                                flex: battle.brandBPlayerScore,
                                child: Container(height: 8, color: brandB.brandColor),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.card_giftcard_rounded, size: 16, color: theme.colorScheme.primary),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                battle.prizeText,
                                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                            FilledButton.tonal(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => MatchmakingScreen(state: state, gameType: 'quiz'),
                                  ),
                                );
                              },
                              style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
                              child: const Text('Play Clash'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // 4. Trending Products from #1 Brand (PRD Section 5.6)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trending from ${topBrand.name}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      'Direct brand fulfillment & delivery',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => _launchBrandUrl(context, topBrand.websiteUrl),
                  child: const Text('Visit Site'),
                ),
              ],
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 240,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: trendingProducts.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final prod = trendingProducts[index];

                  return SizedBox(
                    width: 200,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 100,
                            width: double.infinity,
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                            child: Image.network(
                              prod.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Center(
                                child: Icon(topBrand.icon, size: 36, color: topBrand.brandColor),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  prod.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Text(
                                      '₹${prod.discountPrice.toInt()}',
                                      style: TextStyle(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '₹${prod.originalPrice.toInt()}',
                                      style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: isDark ? Colors.grey[500] : Colors.grey[600],
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton.icon(
                                    onPressed: () => _launchBrandUrl(context, prod.storeUrl),
                                    icon: const Icon(Icons.open_in_new_rounded, size: 14),
                                    label: const Text('Shop on Site', style: TextStyle(fontSize: 12)),
                                    style: FilledButton.styleFrom(
                                      visualDensity: VisualDensity.compact,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                  ),
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

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
