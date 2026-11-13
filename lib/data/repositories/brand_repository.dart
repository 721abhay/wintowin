import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/supabase_config.dart';
import '../../models/brand.dart';
import '../../models/product.dart';

abstract class BrandRepository {
  Future<List<Brand>> getBrands();
  Future<Brand?> getBrandById(String id);
  Future<List<Product>> getProductsForBrand(String brandId);
  Future<Map<String, dynamic>> boostBrandRank({
    required String brandId,
    required double amount,
  });
}

class SupabaseBrandRepository implements BrandRepository {
  final SupabaseClient? _client = SupabaseConfig.client;

  @override
  Future<List<Brand>> getBrands() async {
    final client = _client;
    if (client != null) {
      try {
        final data = await client
            .from('brands')
            .select('*, brand_ranks(*)')
            .eq('status', 'active');

        if (data.isNotEmpty) {
          return (data as List<dynamic>).map((row) {
            final rowMap = Map<String, dynamic>.from(row as Map);
            if (rowMap['brand_ranks'] != null &&
                (rowMap['brand_ranks'] as List).isNotEmpty) {
              final rankData = (rowMap['brand_ranks'] as List).first as Map;
              rowMap['total_paid_inr'] = rankData['total_paid_inr'];
              rowMap['weekly_player_points'] = rankData['weekly_player_points'];
            }
            return Brand.fromJson(rowMap);
          }).toList();
        }
      } catch (e) {
        debugPrint('[BrandRepo] Fetch brands error: $e');
      }
    }

    // Default Seed Brands
    return const [
      Brand(
        id: 'brand_nike',
        name: 'Nike Sportswear',
        tagline: 'Just Do It. Premium athletic performance gear.',
        category: 'Sportswear & Footwear',
        icon: Icons.directions_run_rounded,
        brandColor: Color(0xFF111827),
        totalPaidAmount: 520000.0,
        playerPoints: 48200,
        websiteUrl: 'https://www.nike.com',
        supportersCount: 14200,
      ),
      Brand(
        id: 'brand_adidas',
        name: 'Adidas Originals',
        tagline: 'Impossible Is Nothing. Iconic streetwear & sport.',
        category: 'Sportswear & Footwear',
        icon: Icons.sports_basketball_rounded,
        brandColor: Color(0xFF0369A1),
        totalPaidAmount: 495000.0,
        playerPoints: 46100,
        websiteUrl: 'https://www.adidas.com',
        supportersCount: 12850,
      ),
      Brand(
        id: 'brand_boat',
        name: 'boAt Lifestyle',
        tagline: 'Plug Into Nirvana. India\'s audio giant.',
        category: 'Consumer Electronics',
        icon: Icons.headphones_rounded,
        brandColor: Color(0xFFDC2626),
        totalPaidAmount: 410000.0,
        playerPoints: 39500,
        websiteUrl: 'https://www.boat-lifestyle.com',
        supportersCount: 10920,
      ),
      Brand(
        id: 'brand_puma',
        name: 'Puma Velocity',
        tagline: 'Forever Faster. Speed and urban agility.',
        category: 'Sportswear',
        icon: Icons.flash_on_rounded,
        brandColor: Color(0xFFD97706),
        totalPaidAmount: 360000.0,
        playerPoints: 33400,
        websiteUrl: 'https://in.puma.com',
        supportersCount: 8740,
      ),
      Brand(
        id: 'brand_noise',
        name: 'Noise Wearables',
        tagline: 'Listen to the Noise Within. Smart fitness tech.',
        category: 'Wearables & Audio',
        icon: Icons.watch_rounded,
        brandColor: Color(0xFF7C3AED),
        totalPaidAmount: 310000.0,
        playerPoints: 29800,
        websiteUrl: 'https://www.gonoise.com',
        supportersCount: 7650,
      ),
    ];
  }

  @override
  Future<Brand?> getBrandById(String id) async {
    final brands = await getBrands();
    try {
      return brands.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Product>> getProductsForBrand(String brandId) async {
    final client = _client;
    if (client != null) {
      try {
        final data = await client
            .from('products')
            .select()
            .eq('brand_id', brandId)
            .eq('is_active', true);

        if (data.isNotEmpty) {
          return (data as List<dynamic>)
              .map((row) => Product.fromJson(Map<String, dynamic>.from(row as Map)))
              .toList();
        }
      } catch (e) {
        debugPrint('[BrandRepo] Fetch products error: $e');
      }
    }

    return [];
  }

  @override
  Future<Map<String, dynamic>> boostBrandRank({
    required String brandId,
    required double amount,
  }) async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client.functions.invoke(
          'create-payment-order',
          body: {
            'brandId': brandId,
            'amountInr': amount,
          },
        );
        return Map<String, dynamic>.from(response.data as Map);
      } catch (e) {
        debugPrint('[BrandRepo] Boost rank edge function error: $e');
      }
    }

    // Mock response simulating Razorpay order creation
    return {
      'order_id': 'order_mock_${DateTime.now().millisecondsSinceEpoch}',
      'amount': amount,
      'currency': 'INR',
      'key_id': 'rzp_test_mock',
    };
  }
}
