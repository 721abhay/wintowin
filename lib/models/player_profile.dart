class PlayerProfile {
  final String id;
  final String name;
  final String phoneNumber;
  final String supportedBrandId;
  final DateTime? lastBrandSwitchDate;
  final int dailyPointsEarned;
  final int dailyPointCap;
  final int totalWins;
  final int totalMatches;
  final int streakDays;

  const PlayerProfile({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.supportedBrandId,
    this.lastBrandSwitchDate,
    this.dailyPointsEarned = 350,
    this.dailyPointCap = 1000,
    this.totalWins = 18,
    this.totalMatches = 24,
    this.streakDays = 5,
  });

  double get winRate => totalMatches > 0 ? (totalWins / totalMatches) * 100 : 0.0;
  bool get hasReachedDailyCap => dailyPointsEarned >= dailyPointCap;
  int get remainingDailyPoints => (dailyPointCap - dailyPointsEarned).clamp(0, dailyPointCap);

  PlayerProfile copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? supportedBrandId,
    DateTime? lastBrandSwitchDate,
    int? dailyPointsEarned,
    int? dailyPointCap,
    int? totalWins,
    int? totalMatches,
    int? streakDays,
  }) {
    return PlayerProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      supportedBrandId: supportedBrandId ?? this.supportedBrandId,
      lastBrandSwitchDate: lastBrandSwitchDate ?? this.lastBrandSwitchDate,
      dailyPointsEarned: dailyPointsEarned ?? this.dailyPointsEarned,
      dailyPointCap: dailyPointCap ?? this.dailyPointCap,
      totalWins: totalWins ?? this.totalWins,
      totalMatches: totalMatches ?? this.totalMatches,
      streakDays: streakDays ?? this.streakDays,
    );
  }
}
