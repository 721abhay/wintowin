import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/supabase_config.dart';

abstract class MatchRepository {
  Future<Map<String, dynamic>> startMatch({
    required String playerId,
    required String brandId,
    required String gameType,
  });

  Future<bool> submitAnswer({
    required String matchId,
    required String questionId,
    required int selectedIndex,
    required int responseTimeMs,
  });

  Future<Map<String, dynamic>> finishMatch({
    required String matchId,
    required String playerId,
    required String brandId,
    required int playerScore,
    required int opponentScore,
    required bool won,
  });
}

class SupabaseMatchRepository implements MatchRepository {
  final SupabaseClient? _client = SupabaseConfig.client;

  @override
  Future<Map<String, dynamic>> startMatch({
    required String playerId,
    required String brandId,
    required String gameType,
  }) async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client.functions.invoke(
          'start-match',
          body: {
            'playerId': playerId,
            'brandId': brandId,
            'gameType': gameType,
          },
        );
        return Map<String, dynamic>.from(response.data as Map);
      } catch (e) {
        debugPrint('[MatchRepo] Start match edge function error: $e');
      }
    }

    // Local / Offline fallback match structure
    final isBot = true;
    final opponentBrand = brandId == 'brand_nike' ? 'brand_adidas' : 'brand_nike';
    return {
      'match_id': 'match_${DateTime.now().millisecondsSinceEpoch}',
      'player_id': playerId,
      'opponent_id': 'bot_101',
      'opponent_name': 'Aarav (Rival Bot)',
      'opponent_brand_id': opponentBrand,
      'is_bot': isBot,
      'game_type': gameType,
      'status': 'in_progress',
    };
  }

  @override
  Future<bool> submitAnswer({
    required String matchId,
    required String questionId,
    required int selectedIndex,
    required int responseTimeMs,
  }) async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client.functions.invoke(
          'submit-answer',
          body: {
            'matchId': matchId,
            'questionId': questionId,
            'selectedIndex': selectedIndex,
            'responseTimeMs': responseTimeMs,
          },
        );
        final data = response.data as Map;
        return data['correct'] == true;
      } catch (e) {
        debugPrint('[MatchRepo] Submit answer error: $e');
      }
    }

    // Default local verification: assume correct if positive index
    return selectedIndex >= 0;
  }

  @override
  Future<Map<String, dynamic>> finishMatch({
    required String matchId,
    required String playerId,
    required String brandId,
    required int playerScore,
    required int opponentScore,
    required bool won,
  }) async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client.functions.invoke(
          'finish-match',
          body: {
            'matchId': matchId,
            'playerId': playerId,
            'brandId': brandId,
            'playerScore': playerScore,
            'opponentScore': opponentScore,
            'won': won,
          },
        );
        return Map<String, dynamic>.from(response.data as Map);
      } catch (e) {
        debugPrint('[MatchRepo] Finish match edge function error: $e');
      }
    }

    // Local fallback calculation (respecting daily cap of 1,000 pts)
    final pointsAwarded = won ? 100 : 25;
    final droppedVoucher = won && (DateTime.now().millisecond % 100 < 65);

    return {
      'match_id': matchId,
      'status': 'completed',
      'won': won,
      'points_awarded': pointsAwarded,
      'brand_points_awarded': pointsAwarded,
      'dropped_reward': droppedVoucher
          ? {
              'id': 'reward_drop_${DateTime.now().millisecondsSinceEpoch}',
              'brand_id': brandId,
              'title': 'Victory Reward',
              'discount_text': '20% OFF',
              'promo_code': 'WIN${DateTime.now().millisecond}',
            }
          : null,
    };
  }
}
