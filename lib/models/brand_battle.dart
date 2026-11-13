class BrandBattle {
  final String id;
  final String brandAId;
  final String brandBId;
  final String title;
  final String category;
  final int brandAPlayerScore;
  final int brandBPlayerScore;
  final Duration endsIn;
  final String prizeText;

  const BrandBattle({
    required this.id,
    required this.brandAId,
    required this.brandBId,
    required this.title,
    required this.category,
    required this.brandAPlayerScore,
    required this.brandBPlayerScore,
    required this.endsIn,
    required this.prizeText,
  });

  int get totalPoints => brandAPlayerScore + brandBPlayerScore;
  double get brandAPercentage => totalPoints > 0 ? (brandAPlayerScore / totalPoints) * 100 : 50.0;
  double get brandBPercentage => totalPoints > 0 ? (brandBPlayerScore / totalPoints) * 100 : 50.0;
}
