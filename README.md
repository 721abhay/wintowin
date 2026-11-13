# WinToWin — Mobile Gaming & Brand Battles (iOS & Android)

**WinToWin** is a competitive mobile game app where users support their favorite brands, play casual 1v1 duels, and win real rewards (coupons, discount vouchers, and physical products). Brands pay to climb the Brand Leaderboard, while users never pay anything.

---

## 🏆 Core Mechanics & PRD Implementation

### 1. The 50/50 Brand Ranking Formula
A brand's final rank is determined transparently:
$$\text{Rank Score} = (0.5 \times \text{Money Score}) + (0.5 \times \text{Player Score})$$
- **Money Score**: $(\text{Brand's Total Paid} \div \text{Highest Brand Paid}) \times 100$
- **Player Score**: $(\text{Brand's Supporter Points} \div \text{Highest Player Points}) \times 100$

> **Brand Outbidding Rule**: To climb, a brand must pay more than the brand above it. The app shows how much each brand has paid and exactly how much is needed to overtake the rank above.

---

## 📱 App Navigation (5 Core Bottom Tabs)

1. **Home (`HomeScreen`)**:
   - **#1 Top Brand Banner**: Spotlight showcase for the reigning champion brand.
   - **Live Brand Battles**: Head-to-head clashes (e.g. Nike vs Adidas, boAt vs Noise) with live percentage bars.
   - **Trending Products**: Top brand wishlist items with direct **"Shop on Site"** links (zero shipping/logistics for WinToWin).
   - **Daily Player Point Cap**: 1,000 pts/day cap to eliminate bot dominance and ensure fair play.

2. **Play (`PlayScreen`)**:
   - **1v1 Brand Trivia Duel**: 5 rapid-fire questions with speed bonuses.
   - **1v1 Reaction Duel**: Millisecond reflex duel ("Wait for GREEN... TAP!").
   - **Smart Matchmaking**: Real-time matching with automatic 10-second bot fallback.
   - **Victory Reward Drops**: Random voucher drops (65%-70% chance on win).

3. **Leaderboard (`LeaderboardScreen`)**:
   - **Brand Rankings**: Live rank, total paid, player points, 50/50 combined score, amount to overtake, and interactive Razorpay boost demo.
   - **Top Supporters**: Community leaderboard showing individual player points and brand loyalty badges.

4. **Rewards Wallet (`RewardsScreen`)**:
   - **Digital Vouchers**: Instant coupons with copy code and expiry timers.
   - **Physical Products**: In-app claim form with address entry and courier tracking updates.

5. **Profile (`ProfileScreen`)**:
   - User profile and supported brand loyalty card.
   - **7-day Brand Switch Cooldown**: Prevents opportunistic hopping to whichever brand is winning.
   - Match win rates, current streaks, and theme mode toggle (Light/Dark/System).

---

## 🎮 Launch Games

| Game | Mode | Time | Mechanic |
| :--- | :--- | :--- | :--- |
| **Brand Trivia Quiz** | 1v1 | 60 - 90s | Slogans, logos, products, and culture trivia with countdown timer. |
| **Reflex Reaction Duel** | 1v1 | 30 - 45s | Millisecond stopwatch duel; best of 3 rounds; false start detection. |

---

## 🚀 Running the App Locally

```bash
# 1. Run live with Hot Reload:
flutter run

# 2. Build Android APK:
flutter build apk --split-per-abi

# 3. Build Google Play Store Bundle:
flutter build appbundle
```

---

## ☁️ Continuous Integration & Builds (GitHub Actions)

Every push to [`https://github.com/721abhay/wintowin`](https://github.com/721abhay/wintowin) triggers the `.github/workflows/build.yml` pipeline:
- Builds Android Release APK & AAB
- Builds iOS `.ipa` payload on free GitHub macOS runners
