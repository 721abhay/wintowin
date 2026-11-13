import 'package:flutter_test/flutter_test.dart';
import 'package:wintowin/models/brand.dart';
import 'package:wintowin/services/wintowin_state.dart';
import 'package:flutter/material.dart';

void main() {
  group('Brand Ranking & Score Calculation (50/50 Formula)', () {
    test('Calculates combined score correctly according to PRD & ARCHITECTURE', () {
      const brand = Brand(
        id: 'brand_test',
        name: 'Test Brand',
        tagline: 'Test Tagline',
        category: 'Test Category',
        icon: Icons.store,
        brandColor: Colors.black,
        totalPaidAmount: 500000.0,
        playerPoints: 50000,
        websiteUrl: 'https://test.com',
        supportersCount: 1000,
      );

      // Max paid is 1,000,000 -> Money Score = (500,000 / 1,000,000) * 100 = 50.0
      // Max points is 100,000 -> Play Score = (50,000 / 100,000) * 100 = 50.0
      // Combined = 0.5 * 50 + 0.5 * 50 = 50.0
      final combined = brand.calculateCombinedScore(1000000.0, 100000);
      expect(combined, 50.0);
    });

    test('Highest spender and highest gameplay supporter achieves 100.0 score', () {
      const topBrand = Brand(
        id: 'brand_leader',
        name: 'Leader',
        tagline: 'Leader',
        category: 'Leader',
        icon: Icons.store,
        brandColor: Colors.black,
        totalPaidAmount: 520000.0,
        playerPoints: 48200,
        websiteUrl: 'https://test.com',
        supportersCount: 14000,
      );

      final combined = topBrand.calculateCombinedScore(520000.0, 48200);
      expect(combined, 100.0);
    });
  });

  group('Player Daily Point Cap & Anti-Cheat Constraints', () {
    test('Player cannot exceed 1,000 daily points cap', () {
      final state = WinToWinState();

      // Win 10 matches (+100 pts each)
      for (int i = 0; i < 15; i++) {
        state.recordMatchWin(
          playerPointsAwarded: 100,
          brandPointsAwarded: 100,
        );
      }

      // Must be capped at exactly 1000 pts
      expect(state.player.dailyPointsEarned, 1000);
      expect(state.player.hasReachedDailyCap, true);
      expect(state.player.remainingDailyPoints, 0);
    });

    test('Brand switch enforces 7-day cooldown', () {
      final state = WinToWinState();

      // First switch succeeds
      final firstSwitch = state.switchSupportedBrand('brand_adidas');
      expect(firstSwitch, true);
      expect(state.player.supportedBrandId, 'brand_adidas');

      // Immediate second switch must fail due to 7-day cooldown
      final secondSwitch = state.switchSupportedBrand('brand_boat');
      expect(secondSwitch, false);
      expect(state.player.supportedBrandId, 'brand_adidas');
    });
  });
}
