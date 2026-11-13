import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/reward.dart';
import '../services/wintowin_state.dart';
import '../widgets/adaptive_dialog.dart';

class RewardsScreen extends StatefulWidget {
  final WinToWinState state;

  const RewardsScreen({super.key, required this.state});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  void _claimPhysicalRewardDialog(BuildContext context, Reward reward) {
    final addressController = TextEditingController();
    final cityController = TextEditingController();
    final pinController = TextEditingController();

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
                    'Claim Physical Product',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Fulfilled and shipped directly by ${reward.brandName}. WinToWin passes your shipping address safely to the brand.',
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'House / Flat / Street Address',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: cityController,
                      decoration: InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: pinController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'PIN Code',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  if (addressController.text.trim().isNotEmpty) {
                    final fullAddress =
                        '${addressController.text.trim()}, ${cityController.text.trim()} - ${pinController.text.trim()}';
                    widget.state.claimPhysicalReward(
                      rewardId: reward.id,
                      shippingAddress: fullAddress,
                    );
                    Navigator.of(ctx).pop();
                    showAdaptiveCustomDialog(
                      context: context,
                      title: 'Claim Submitted to ${reward.brandName}!',
                      content:
                          'Your shipping details were sent to ${reward.brandName}. You will receive courier tracking updates directly in this tab once dispatched.',
                    );
                  }
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Confirm Shipping Address'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _copyPromoCode(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voucher code "$code" copied to clipboard!'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final rewards = widget.state.rewards;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards Wallet'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Wallet Header Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF334155)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TOTAL REWARDS WON',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${rewards.length} Prizes',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '100% Free • Funded by Brands',
                      style: TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white12,
                  child: Icon(Icons.wallet_giftcard_rounded, color: Colors.amber, size: 32),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Active Vouchers & Won Products',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rewards.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final reward = rewards[index];
              final isPhysical = reward.type == RewardType.physicalProduct;

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isPhysical
                                  ? const Color(0xFFEC4899).withValues(alpha: 0.12)
                                  : const Color(0xFF4F46E5).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              isPhysical ? 'PHYSICAL PRODUCT' : 'DIGITAL VOUCHER',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isPhysical ? const Color(0xFFEC4899) : const Color(0xFF4F46E5),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              reward.brandName,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        reward.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reward.description,
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 14),

                      // Code or Physical Status Row
                      if (!isPhysical && reward.promoCode != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Promo Code', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                  Text(
                                    reward.promoCode!,
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              FilledButton.tonalIcon(
                                onPressed: () => _copyPromoCode(context, reward.promoCode!),
                                icon: const Icon(Icons.copy_rounded, size: 14),
                                label: const Text('Copy'),
                                style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        // Physical Status
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.local_shipping_rounded, size: 18, color: Color(0xFF10B981)),
                                  const SizedBox(width: 8),
                                  Text(
                                    reward.deliveryStatus ?? 'Unclaimed',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                ],
                              ),
                              if (reward.trackingNumber != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Tracking: ${reward.trackingNumber}',
                                  style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (!reward.isClaimed) ...[
                          const SizedBox(height: 10),
                          FilledButton.icon(
                            onPressed: () => _claimPhysicalRewardDialog(context, reward),
                            icon: const Icon(Icons.home_rounded, size: 16),
                            label: const Text('Enter Shipping Address to Claim'),
                            style: FilledButton.styleFrom(
                              minimumSize: const Size(double.infinity, 44),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
