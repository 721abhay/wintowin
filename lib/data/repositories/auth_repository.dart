import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/supabase_config.dart';
import '../../models/player_profile.dart';

abstract class AuthRepository {
  Future<void> sendOtp(String phoneNumber);
  Future<PlayerProfile?> verifyOtp({
    required String phoneNumber,
    required String token,
  });
  Future<void> signOut();
  PlayerProfile? getCurrentUser();
  Future<void> updateSupportedBrand(String userId, String brandId);
}

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient? _client = SupabaseConfig.client;

  @override
  Future<void> sendOtp(String phoneNumber) async {
    final client = _client;
    if (client != null) {
      try {
        await client.auth.signInWithOtp(phone: phoneNumber);
        return;
      } catch (e) {
        debugPrint('[AuthRepo] Supabase OTP send error: $e');
      }
    }
    // Offline / Mock fallback
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  Future<PlayerProfile?> verifyOtp({
    required String phoneNumber,
    required String token,
  }) async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client.auth.verifyOTP(
          phone: phoneNumber,
          token: token,
          type: OtpType.sms,
        );
        final user = response.user;
        if (user != null) {
          final profileData = await client
              .from('users')
              .select()
              .eq('id', user.id)
              .maybeSingle();

          if (profileData != null) {
            return PlayerProfile.fromJson(profileData);
          } else {
            // New user registration
            final newProfile = {
              'id': user.id,
              'phone': phoneNumber,
              'full_name': 'Player_${phoneNumber.substring(phoneNumber.length - 4)}',
              'supported_brand_id': 'brand_nike',
              'daily_points_today': 0,
            };
            await client.from('users').insert(newProfile);
            return PlayerProfile.fromJson(newProfile);
          }
        }
      } catch (e) {
        debugPrint('[AuthRepo] Supabase verify OTP error: $e');
      }
    }

    // Mock fallback player
    await Future.delayed(const Duration(milliseconds: 500));
    return PlayerProfile(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Player_${phoneNumber.replaceAll(RegExp(r'[^0-9]'), '').substring(phoneNumber.length.clamp(0, 4))}',
      phoneNumber: phoneNumber,
      supportedBrandId: 'brand_nike',
      dailyPointsEarned: 350,
      dailyPointCap: 1000,
      totalWins: 18,
      totalMatches: 24,
      streakDays: 5,
    );
  }

  @override
  Future<void> signOut() async {
    final client = _client;
    if (client != null) {
      try {
        await client.auth.signOut();
      } catch (e) {
        debugPrint('[AuthRepo] Sign out error: $e');
      }
    }
  }

  @override
  PlayerProfile? getCurrentUser() {
    final client = _client;
    final user = client?.auth.currentUser;
    if (user != null) {
      return PlayerProfile(
        id: user.id,
        name: user.userMetadata?['full_name'] as String? ?? 'Player',
        phoneNumber: user.phone ?? '',
        supportedBrandId: 'brand_nike',
      );
    }
    return null;
  }

  @override
  Future<void> updateSupportedBrand(String userId, String brandId) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('users').update({
          'supported_brand_id': brandId,
          'brand_joined_at': DateTime.now().toIso8601String(),
        }).eq('id', userId);
      } catch (e) {
        debugPrint('[AuthRepo] Update supported brand error: $e');
      }
    }
  }
}
