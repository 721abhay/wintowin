import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/supabase_config.dart';
import '../../models/reward.dart';

abstract class RewardsRepository {
  Future<List<Reward>> getUserRewards(String userId);
  Future<Reward> claimReward(String rewardId);
  Future<void> claimPhysicalReward({
    required String rewardId,
    required String fullName,
    required String shippingAddress,
    required String pinCode,
    required String phone,
  });
  Future<String> trackProductClick({
    required String productId,
    required String brandId,
    required String userId,
    required String originalUrl,
  });
}

class SupabaseRewardsRepository implements RewardsRepository {
  final SupabaseClient? _client = SupabaseConfig.client;

  @override
  Future<List<Reward>> getUserRewards(String userId) async {
    final client = _client;
    if (client != null) {
      try {
        final data = await client
            .from('reward_wallet')
            .select('*, rewards(*)')
            .eq('user_id', userId);

        if (data.isNotEmpty) {
          return (data as List<dynamic>).map((row) {
            final rowMap = Map<String, dynamic>.from(row as Map);
            final rewardDetails = rowMap['rewards'] != null
                ? Map<String, dynamic>.from(rowMap['rewards'] as Map)
                : <String, dynamic>{};

            final combined = {
              ...rewardDetails,
              'id': rowMap['id'],
              'status': rowMap['status'],
              'shipping_address': rowMap['shipping_address'],
              'tracking_number': rowMap['tracking_number'],
              'delivery_status': rowMap['delivery_status'],
            };
            return Reward.fromJson(combined);
          }).toList();
        }
      } catch (e) {
        debugPrint('[RewardsRepo] Fetch user rewards error: $e');
      }
    }

    // Default Seed Rewards
    return [
      Reward(
        id: 'rew_1',
        brandId: 'brand_nike',
        brandName: 'Nike Sportswear',
        title: '₹1,500 Off Running Shoes',
        description: 'Valid on purchases above ₹5,000 at official Nike store.',
        type: RewardType.voucher,
        promoCode: 'NIKEWIN1500',
        discountValue: '₹1,500 OFF',
        expiryDate: DateTime.now().add(const Duration(days: 14)),
        isClaimed: false,
      ),
      Reward(
        id: 'rew_2',
        brandId: 'brand_boat',
        brandName: 'boAt Lifestyle',
        title: '30% Off Airdopes TWS',
        description: 'Exclusive gamer discount on all audio gear.',
        type: RewardType.voucher,
        promoCode: 'BOATPLAY30',
        discountValue: '30% OFF',
        expiryDate: DateTime.now().add(const Duration(days: 7)),
        isClaimed: true,
      ),
      Reward(
        id: 'rew_3',
        brandId: 'brand_puma',
        brandName: 'Puma Velocity',
        title: 'Velocity Gym Duffel Bag',
        description: 'Physical product reward sent directly by Puma.',
        type: RewardType.physicalProduct,
        expiryDate: DateTime.now().add(const Duration(days: 21)),
        isClaimed: true,
        shippingAddress: 'Flat 402, Green Valley Apts, Indiranagar, Bengaluru, KA 560038',
        trackingNumber: 'DTDC-BLR-892144',
        deliveryStatus: 'Out for Delivery',
      ),
      Reward(
        id: 'rew_4',
        brandId: 'brand_adidas',
        brandName: 'Adidas Originals',
        title: '₹2,000 Off Motorsport Collection',
        description: 'Applicable on high-performance sneakers and apparel.',
        type: RewardType.voucher,
        promoCode: 'ADIWIN2000',
        discountValue: '₹2,000 OFF',
        expiryDate: DateTime.now().add(const Duration(days: 3)),
        isClaimed: false,
      ),
    ];
  }

  @override
  Future<Reward> claimReward(String rewardId) async {
    final client = _client;
    if (client != null) {
      try {
        await client
            .from('reward_wallet')
            .update({'status': 'claimed'})
            .eq('id', rewardId);
      } catch (e) {
        debugPrint('[RewardsRepo] Claim reward error: $e');
      }
    }
    // Return updated reward representation
    final rewards = await getUserRewards('current_user');
    return rewards.firstWhere(
      (r) => r.id == rewardId,
      orElse: () => Reward(
        id: rewardId,
        brandId: 'brand_nike',
        brandName: 'Nike',
        title: 'Claimed Reward',
        description: 'Claimed',
        type: RewardType.voucher,
        expiryDate: DateTime.now(),
        isClaimed: true,
      ),
    );
  }

  @override
  Future<void> claimPhysicalReward({
    required String rewardId,
    required String fullName,
    required String shippingAddress,
    required String pinCode,
    required String phone,
  }) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('reward_wallet').update({
          'status': 'claimed',
          'shipping_name': fullName,
          'shipping_address': '$shippingAddress, PIN: $pinCode, Ph: $phone',
          'claimed_at': DateTime.now().toIso8601String(),
          'delivery_status': 'Processing with Brand',
        }).eq('id', rewardId);
      } catch (e) {
        debugPrint('[RewardsRepo] Claim physical reward error: $e');
      }
    }
  }

  @override
  Future<String> trackProductClick({
    required String productId,
    required String brandId,
    required String userId,
    required String originalUrl,
  }) async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client.functions.invoke(
          'track-click',
          body: {
            'productId': productId,
            'brandId': brandId,
            'userId': userId,
          },
        );
        final data = response.data as Map?;
        if (data != null && data['targetUrl'] != null) {
          return data['targetUrl'] as String;
        }
      } catch (e) {
        debugPrint('[RewardsRepo] Track click error: $e');
      }
    }
    return originalUrl;
  }
}
