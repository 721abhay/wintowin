import 'package:flutter/material.dart';

class Brand {
  final String id;
  final String name;
  final String tagline;
  final String category;
  final IconData icon;
  final Color brandColor;
  final double totalPaidAmount; // in INR (₹)
  final int playerPoints;
  final String websiteUrl;
  final int supportersCount;
  final String logoUrl;

  const Brand({
    required this.id,
    required this.name,
    required this.tagline,
    required this.category,
    required this.icon,
    required this.brandColor,
    required this.totalPaidAmount,
    required this.playerPoints,
    required this.websiteUrl,
    required this.supportersCount,
    this.logoUrl = '',
  });

  // Calculate 50% Money Score + 50% Player Score
  // Money Score = (paid / maxPaid) * 100
  // Player Score = (points / maxPoints) * 100
  // Combined = 0.5 * Money + 0.5 * Player
  double calculateCombinedScore(double maxPaid, int maxPoints) {
    final double moneyScore = maxPaid > 0 ? (totalPaidAmount / maxPaid) * 100 : 0.0;
    final double playScore = maxPoints > 0 ? (playerPoints / maxPoints) * 100 : 0.0;
    return (0.5 * moneyScore) + (0.5 * playScore);
  }

  Brand copyWith({
    String? id,
    String? name,
    String? tagline,
    String? category,
    IconData? icon,
    Color? brandColor,
    double? totalPaidAmount,
    int? playerPoints,
    String? websiteUrl,
    int? supportersCount,
    String? logoUrl,
  }) {
    return Brand(
      id: id ?? this.id,
      name: name ?? this.name,
      tagline: tagline ?? this.tagline,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      brandColor: brandColor ?? this.brandColor,
      totalPaidAmount: totalPaidAmount ?? this.totalPaidAmount,
      playerPoints: playerPoints ?? this.playerPoints,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      supportersCount: supportersCount ?? this.supportersCount,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }

  factory Brand.fromJson(Map<String, dynamic> json) {
    Color parseColor(String? hex) {
      if (hex == null || hex.isEmpty) return const Color(0xFF14161C);
      final clean = hex.replaceAll('#', '');
      if (clean.length == 6) {
        return Color(int.parse('0xFF$clean'));
      }
      return const Color(0xFF14161C);
    }

    return Brand(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      tagline: json['tagline'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      icon: Icons.storefront_rounded,
      brandColor: parseColor(json['primary_color'] as String?),
      totalPaidAmount: (json['total_paid_inr'] as num?)?.toDouble() ?? 0.0,
      playerPoints: (json['weekly_player_points'] as num?)?.toInt() ?? 0,
      websiteUrl: json['website_url'] as String? ?? '',
      supportersCount: (json['supporters_count'] as num?)?.toInt() ?? 0,
      logoUrl: json['logo_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tagline': tagline,
      'category': category,
      'primary_color': '#${brandColor.toARGB32().toRadixString(16).substring(2)}',
      'total_paid_inr': totalPaidAmount,
      'weekly_player_points': playerPoints,
      'website_url': websiteUrl,
      'supporters_count': supportersCount,
      'logo_url': logoUrl,
    };
  }
}

