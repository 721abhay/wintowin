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
}

