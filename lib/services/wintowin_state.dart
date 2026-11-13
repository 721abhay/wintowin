import 'package:flutter/material.dart';
import '../models/brand.dart';
import '../models/brand_battle.dart';
import '../models/product.dart';
import '../models/reward.dart';
import '../models/player_profile.dart';
import '../models/leaderboard_player.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/brand_repository.dart';
import '../data/repositories/match_repository.dart';
import '../data/repositories/rewards_repository.dart';

class WinToWinState extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  final AuthRepository _authRepo;
  final BrandRepository _brandRepo;
  final MatchRepository _matchRepo;
  final RewardsRepository _rewardsRepo;

  WinToWinState({
    AuthRepository? authRepo,
    BrandRepository? brandRepo,
    MatchRepository? matchRepo,
    RewardsRepository? rewardsRepo,
  })  : _authRepo = authRepo ?? SupabaseAuthRepository(),
        _brandRepo = brandRepo ?? SupabaseBrandRepository(),
        _matchRepo = matchRepo ?? SupabaseMatchRepository(),
        _rewardsRepo = rewardsRepo ?? SupabaseRewardsRepository() {
    refreshFromBackend();
  }

  // Active Player
  PlayerProfile _player = const PlayerProfile(
    id: 'user_721',
    name: 'Abhay Kumar',
    phoneNumber: '+91 98765 43210',
    supportedBrandId: 'brand_nike',
    dailyPointsEarned: 350,
    dailyPointCap: 1000,
    totalWins: 18,
    totalMatches: 24,
    streakDays: 5,
  );

  // Brands List
  List<Brand> _brands = [
    const Brand(
      id: 'brand_nike',
      name: 'Nike Sportswear',
      tagline: 'Just Do It. Premium athletic performance gear.',
      category: 'Sportswear & Footwear',
      icon: Icons.directions_run_rounded,
      brandColor: Color(0xFF111827),
      totalPaidAmount: 520000.0, // ₹5,20,000
      playerPoints: 48200,
      websiteUrl: 'https://www.nike.com',
      supportersCount: 14200,
    ),
    const Brand(
      id: 'brand_adidas',
      name: 'Adidas Originals',
      tagline: 'Impossible Is Nothing. Iconic streetwear & sport.',
      category: 'Sportswear & Footwear',
      icon: Icons.sports_basketball_rounded,
      brandColor: Color(0xFF0369A1),
      totalPaidAmount: 495000.0, // ₹4,95,000
      playerPoints: 46100,
      websiteUrl: 'https://www.adidas.com',
      supportersCount: 12850,
    ),
    const Brand(
      id: 'brand_boat',
      name: 'boAt Lifestyle',
      tagline: 'Plug Into Nirvana. India\'s audio giant.',
      category: 'Consumer Electronics',
      icon: Icons.headphones_rounded,
      brandColor: Color(0xFFDC2626),
      totalPaidAmount: 410000.0, // ₹4,10,000
      playerPoints: 39500,
      websiteUrl: 'https://www.boat-lifestyle.com',
      supportersCount: 10920,
    ),
    const Brand(
      id: 'brand_puma',
      name: 'Puma Velocity',
      tagline: 'Forever Faster. Speed and urban agility.',
      category: 'Sportswear',
      icon: Icons.flash_on_rounded,
      brandColor: Color(0xFFD97706),
      totalPaidAmount: 360000.0, // ₹3,60,000
      playerPoints: 33400,
      websiteUrl: 'https://in.puma.com',
      supportersCount: 8740,
    ),
    const Brand(
      id: 'brand_noise',
      name: 'Noise Wearables',
      tagline: 'Listen to the Noise Within. Smart fitness tech.',
      category: 'Wearables & Audio',
      icon: Icons.watch_rounded,
      brandColor: Color(0xFF7C3AED),
      totalPaidAmount: 310000.0, // ₹3,10,000
      playerPoints: 29800,
      websiteUrl: 'https://www.gonoise.com',
      supportersCount: 7600,
    ),
  ];

  // Live Brand Battles
  final List<BrandBattle> _battles = [
    const BrandBattle(
      id: 'battle_1',
      brandAId: 'brand_nike',
      brandBId: 'brand_adidas',
      title: 'Sneaker Supremacy Duel',
      category: 'Footwear & Streetwear',
      brandAPlayerScore: 24800,
      brandBPlayerScore: 23650,
      endsIn: Duration(hours: 14, minutes: 22),
      prizeText: 'Winning supporters unlock exclusive 30% OFF vouchers',
    ),
    const BrandBattle(
      id: 'battle_2',
      brandAId: 'brand_boat',
      brandBId: 'brand_noise',
      title: 'Sound & Fitness Clash',
      category: 'Audio & Tech',
      brandAPlayerScore: 19400,
      brandBPlayerScore: 18950,
      endsIn: Duration(hours: 8, minutes: 45),
      prizeText: 'Top 50 players win boAt Airdopes & Noise ColorFit watches',
    ),
  ];

  // Trending Products
  final List<Product> _products = [
    const Product(
      id: 'prod_1',
      brandId: 'brand_nike',
      brandName: 'Nike',
      title: 'Air Zoom Pegasus 40 Running Shoes',
      description: 'Responsive cushioning for road runners with engineered mesh upper.',
      originalPrice: 11495.0,
      discountPrice: 7995.0,
      storeUrl: 'https://www.nike.com',
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&auto=format&fit=crop&q=80',
      isTrending: true,
    ),
    const Product(
      id: 'prod_2',
      brandId: 'brand_nike',
      brandName: 'Nike',
      title: 'Dri-FIT Academy Pro Football Tracksuit',
      description: 'Sweat-wicking performance fabric with zippered ankle hems.',
      originalPrice: 5995.0,
      discountPrice: 3995.0,
      storeUrl: 'https://www.nike.com',
      imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=600&auto=format&fit=crop&q=80',
      isTrending: true,
    ),
    const Product(
      id: 'prod_3',
      brandId: 'brand_nike',
      brandName: 'Nike',
      title: 'Air Max 270 Lifestyle Sneakers',
      description: 'Legendary Max Air 270 unit delivers all-day supreme comfort.',
      originalPrice: 13995.0,
      discountPrice: 9995.0,
      storeUrl: 'https://www.nike.com',
      imageUrl: 'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=600&auto=format&fit=crop&q=80',
      isTrending: true,
    ),
  ];

  // Player Rewards / Wallet
  List<Reward> _rewards = [
    Reward(
      id: 'rew_1',
      brandId: 'brand_nike',
      brandName: 'Nike',
      title: 'Flat ₹1,500 OFF on Orders Above ₹5,000',
      description: 'Valid across all footwear and apparel on the official Nike site.',
      type: RewardType.voucher,
      promoCode: 'NIKEWIN1500',
      discountValue: '₹1,500 OFF',
      expiryDate: DateTime.now().add(const Duration(days: 12)),
      isClaimed: false,
    ),
    Reward(
      id: 'rew_2',
      brandId: 'brand_boat',
      brandName: 'boAt',
      title: 'Flat 25% Instant Discount',
      description: 'Unlock 25% off on all TWS Earbuds & Bluetooth speakers.',
      type: RewardType.voucher,
      promoCode: 'BOATPLAY25',
      discountValue: '25% OFF',
      expiryDate: DateTime.now().add(const Duration(days: 7)),
      isClaimed: false,
    ),
    Reward(
      id: 'rew_3',
      brandId: 'brand_nike',
      brandName: 'Nike',
      title: 'Nike Club Fleece Pullover Hoodie',
      description: 'Physical prize won in Weekend Tournament! Shipped by Nike.',
      type: RewardType.physicalProduct,
      expiryDate: DateTime.now().add(const Duration(days: 30)),
      isClaimed: true,
      shippingAddress: 'Flat 402, Green Valley Apts, Indiranagar, Bengaluru 560038',
      trackingNumber: 'DELHIVERY_NK98231',
      deliveryStatus: 'Out for Delivery',
    ),
  ];

  // Top Players Leaderboard
  final List<LeaderboardPlayer> _topPlayers = [
    const LeaderboardPlayer(
      rank: 1,
      name: 'Rohan Sharma',
      avatarInitials: 'RS',
      avatarColor: Color(0xFF4F46E5),
      brandName: 'Nike',
      brandIcon: Icons.directions_run_rounded,
      points: 8420,
      wins: 142,
    ),
    const LeaderboardPlayer(
      rank: 2,
      name: 'Priya Patel',
      avatarInitials: 'PP',
      avatarColor: Color(0xFF06B6D4),
      brandName: 'Adidas',
      brandIcon: Icons.sports_basketball_rounded,
      points: 7910,
      wins: 131,
    ),
    const LeaderboardPlayer(
      rank: 3,
      name: 'Abhay Kumar (You)',
      avatarInitials: 'AK',
      avatarColor: Color(0xFF10B981),
      brandName: 'Nike',
      brandIcon: Icons.directions_run_rounded,
      points: 6850,
      wins: 114,
    ),
    const LeaderboardPlayer(
      rank: 4,
      name: 'Vikram Joshi',
      avatarInitials: 'VJ',
      avatarColor: Color(0xFFF59E0B),
      brandName: 'boAt',
      brandIcon: Icons.headphones_rounded,
      points: 6240,
      wins: 98,
    ),
    const LeaderboardPlayer(
      rank: 5,
      name: 'Ananya Roy',
      avatarInitials: 'AR',
      avatarColor: Color(0xFFEC4899),
      brandName: 'Puma',
      brandIcon: Icons.flash_on_rounded,
      points: 5890,
      wins: 89,
    ),
  ];

  // Getters
  ThemeMode get themeMode => _themeMode;
  PlayerProfile get player => _player;
  List<BrandBattle> get battles => List.unmodifiable(_battles);
  List<Product> get products => List.unmodifiable(_products);
  List<Reward> get rewards => List.unmodifiable(_rewards);
  List<LeaderboardPlayer> get topPlayers => List.unmodifiable(_topPlayers);

  // Repositories
  AuthRepository get authRepo => _authRepo;
  BrandRepository get brandRepo => _brandRepo;
  MatchRepository get matchRepo => _matchRepo;
  RewardsRepository get rewardsRepo => _rewardsRepo;

  // Sync with Supabase backend
  Future<void> refreshFromBackend() async {
    try {
      final backendBrands = await _brandRepo.getBrands();
      if (backendBrands.isNotEmpty) {
        _brands = backendBrands;
      }
      final backendRewards = await _rewardsRepo.getUserRewards(_player.id);
      if (backendRewards.isNotEmpty) {
        _rewards = backendRewards;
      }
      notifyListeners();
    } catch (_) {}
  }

  // Maximum paid amount among all brands (used for Money Score normalization)
  double get maxPaidAmount {
    if (_brands.isEmpty) return 1.0;
    return _brands.map((b) => b.totalPaidAmount).reduce((a, b) => a > b ? a : b);
  }

  // Maximum player points among all brands (used for Player Score normalization)
  int get maxPlayerPoints {
    if (_brands.isEmpty) return 1;
    return _brands.map((b) => b.playerPoints).reduce((a, b) => a > b ? a : b);
  }

  // Brands sorted by Rank Score = 0.5 * Money Score + 0.5 * Player Score
  List<Brand> get rankedBrands {
    final list = List<Brand>.from(_brands);
    final maxPaid = maxPaidAmount;
    final maxPoints = maxPlayerPoints;

    list.sort((a, b) {
      final scoreA = a.calculateCombinedScore(maxPaid, maxPoints);
      final scoreB = b.calculateCombinedScore(maxPaid, maxPoints);
      return scoreB.compareTo(scoreA); // Descending
    });
    return list;
  }

  // Number 1 Brand
  Brand get topBrand => rankedBrands.first;

  // Find brand by ID
  Brand? getBrandById(String id) {
    try {
      return _brands.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  // Supported Brand for the active player
  Brand get playerBrand => getBrandById(_player.supportedBrandId) ?? topBrand;

  // Actions
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  // Switch Supported Brand with 7-day cooldown check
  bool switchSupportedBrand(String newBrandId) {
    final now = DateTime.now();
    if (_player.lastBrandSwitchDate != null) {
      final diff = now.difference(_player.lastBrandSwitchDate!).inDays;
      if (diff < 7) {
        return false; // Under cooldown
      }
    }
    _player = _player.copyWith(
      supportedBrandId: newBrandId,
      lastBrandSwitchDate: now,
    );
    notifyListeners();

    // Async backend update
    _authRepo.updateSupportedBrand(_player.id, newBrandId).catchError((_) {});
    return true;
  }

  // Record a Game Match Win
  void recordMatchWin({
    required int playerPointsAwarded,
    required int brandPointsAwarded,
    Reward? dropReward,
  }) {
    // Add points up to daily cap
    final newDailyPoints = (_player.dailyPointsEarned + playerPointsAwarded).clamp(0, _player.dailyPointCap);
    _player = _player.copyWith(
      dailyPointsEarned: newDailyPoints,
      totalWins: _player.totalWins + 1,
      totalMatches: _player.totalMatches + 1,
    );

    // Boost supported brand points
    final brandIndex = _brands.indexWhere((b) => b.id == _player.supportedBrandId);
    if (brandIndex != -1) {
      final currentBrand = _brands[brandIndex];
      _brands[brandIndex] = currentBrand.copyWith(
        playerPoints: currentBrand.playerPoints + brandPointsAwarded,
      );
    }

    // Add reward drop if unlocked
    if (dropReward != null) {
      _rewards.insert(0, dropReward);
    }

    notifyListeners();
  }

  // Record a Game Match Loss
  void recordMatchLoss({required int consolationPoints}) {
    final newDailyPoints = (_player.dailyPointsEarned + consolationPoints).clamp(0, _player.dailyPointCap);
    _player = _player.copyWith(
      dailyPointsEarned: newDailyPoints,
      totalMatches: _player.totalMatches + 1,
    );
    notifyListeners();
  }

  // Brand Outbidding / Boost simulation (Razorpay / Pay to Rank)
  void boostBrandPayment({
    required String brandId,
    required double additionalAmount,
  }) {
    final index = _brands.indexWhere((b) => b.id == brandId);
    if (index != -1) {
      final current = _brands[index];
      _brands[index] = current.copyWith(
        totalPaidAmount: current.totalPaidAmount + additionalAmount,
      );
      notifyListeners();
    }

    // Async backend edge function invocation
    _brandRepo.boostBrandRank(brandId: brandId, amount: additionalAmount).catchError((_) => <String, dynamic>{});
  }

  // Claim a Physical Product Reward
  void claimPhysicalReward({
    required String rewardId,
    required String shippingAddress,
  }) {
    final index = _rewards.indexWhere((r) => r.id == rewardId);
    if (index != -1) {
      final current = _rewards[index];
      _rewards[index] = current.copyWith(
        isClaimed: true,
        shippingAddress: shippingAddress,
        trackingNumber: 'TRK${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
        deliveryStatus: 'Processing with Brand',
      );
      notifyListeners();
    }

    // Async backend update
    _rewardsRepo.claimPhysicalReward(
      rewardId: rewardId,
      fullName: _player.name,
      shippingAddress: shippingAddress,
      pinCode: '560038',
      phone: _player.phoneNumber,
    ).catchError((_) {});
  }
}

