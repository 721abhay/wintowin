import 'package:flutter/material.dart';

class LeaderboardPlayer {
  final int rank;
  final String name;
  final String avatarInitials;
  final Color avatarColor;
  final String brandName;
  final IconData brandIcon;
  final int points;
  final int wins;

  const LeaderboardPlayer({
    required this.rank,
    required this.name,
    required this.avatarInitials,
    required this.avatarColor,
    required this.brandName,
    required this.brandIcon,
    required this.points,
    required this.wins,
  });
}
