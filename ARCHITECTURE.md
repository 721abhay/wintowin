# WinToWin — System Architecture (ARCHITECTURE.md)

**Document Version:** 1.0  
**Status:** Approved for Implementation  
**Primary Architect:** Abhay

---

## 1. System Overview & Recommended Tech Stack

WinToWin is designed with a lightweight, decoupled architecture separating the consumer mobile game app from the brand/admin web management portals.

```
+-------------------------------------------------------------------------+
|                              PLAYERS                                    |
|                Flutter Mobile App (iOS & Android)                       |
+------------------------------------+------------------------------------+
                                     |  HTTPS / WebSocket
                                     v
+-------------------------------------------------------------------------+
|                            BACKEND API                                  |
|          Node.js / TypeScript (NestJS or Express) OR Supabase Edge     |
+------------------------------------+------------------------------------+
                                     |
              +----------------------+----------------------+
              |                                             |
              v                                             v
+-----------------------------+               +---------------------------+
|      PRIMARY DATABASE       |               |     REAL-TIME ENGINE      |
|    PostgreSQL (Supabase)    |               |  WebSockets / Redis PubSub|
+-----------------------------+               +---------------------------+
              |                                             |
              v                                             v
+-----------------------------+               +---------------------------+
|    BRAND WEB DASHBOARD      |               |      PAYMENT GATEWAY      |
|     React / Next.js         |               |     Razorpay / Stripe     |
+-----------------------------+               +---------------------------+
```

### 1.1 Tech Stack Justification
- **Mobile Frontend: Flutter (Dart)**
  - *Reasoning*: Delivers native 60–120 FPS rendering on both iOS and Android from a single shared codebase. Crucial for reaction duels where millisecond input latency determines match outcomes.
- **Backend Services: Node.js (TypeScript) & Supabase / Firebase**
  - *Reasoning*: Real-time database synchronisation for match states and leaderboard updates, out-of-the-box phone OTP authentication, and automated Postgres Row-Level Security (RLS).
- **Primary Database: PostgreSQL**
  - *Reasoning*: Relational integrity is mandatory for financial ledger entries (brand boost payments), reward claims, and leaderboard snapshots.
- **Payment Processing: Razorpay (India) & Stripe (Global)**
  - *Reasoning*: Direct integration with UPI, cards, net banking, and instant webhooks for brand rank boost confirmations.

---

## 2. Component Architecture & Boundaries

### 2.1 Mobile Client Architecture (Flutter)
The mobile app adopts a clean layered structure:
- **Presentation Layer**: Flutter widgets and screens categorized by tab (`home`, `play`, `leaderboard`, `rewards`, `profile`).
- **Domain/State Layer**: `ChangeNotifier` / `Bloc` encapsulating pure business logic (e.g. `WinToWinState`, 50/50 formula calculation, cooldown timers).
- **Data/Service Layer**:
  - `HardwareService`: Encapsulates camera, biometrics, GPS, and local device preferences.
  - `ApiClient`: Handles authenticated REST requests to backend endpoints.
  - `RealtimeService`: WebSocket/Firebase channel for 1v1 matchmaking.

### 2.2 Brand & Admin Web Portals (Next.js)
- Responsive web dashboard for brand managers to upload products, manage reward inventory, and trigger Razorpay outbids.
- Role-based server-side access control with JWT verification.

---

## 3. Data Flow & Critical Paths

### 3.1 1v1 Game Match & Score Distribution Flow
1. **Match Request**: Player taps "Play" -> Client sends `{ gameType, zone, brandId }` to `/matches/queue`.
2. **Matchmaking**: Server attempts to match with another live queued user within 10 seconds. If timer reaches 10s, server assigns a realistic certified bot opponent with a rival brand.
3. **Game Execution**: Client runs match timer and local inputs.
4. **Result Verification**: Client submits `{ matchId, answers, reactionTimesMs, score }`.
5. **Server Verification**:
   - Server checks daily point cap for player ($< 1,000$ pts).
   - Validates reaction times against human threshold ($> 80\text{ ms}$).
   - Commits win/loss transaction to database.
   - Increases brand's `player_points` score.
   - Triggers random voucher reward drop if eligible ($65\%\text{ chance}$).
   - Returns verified result to mobile client.

### 3.2 Brand Outbidding & Rank Recalculation Flow
1. Brand opens Web Dashboard -> Views current rank and amount required to overtake rank $\#(N-1)$.
2. Initiates payment: POST `/brands/boost` with `{ amount }`.
3. Server creates Razorpay Order with unique signature.
4. Brand completes payment in Razorpay modal.
5. Razorpay webhook notifies WinToWin server (`payment.captured`).
6. Webhook verifies signature -> Increments `brand.total_paid_amount` atomically in Postgres.
7. Leaderboard engine recalculates 50/50 scores across all active brands.
8. Real-time push notification delivered to newly outbid brand.

---

## 4. Mobile Project Folder Structure

```text
wintowin/
├── android/                   # Native Android host & permissions
├── ios/                       # Native iOS Xcode workspace & Info.plist
├── lib/
│   ├── main.dart              # App bootstrap & ThemeMode listener
│   ├── models/                # Typed data entities
│   │   ├── brand.dart         # Brand model & 50/50 formula
│   │   ├── brand_battle.dart  # Head-to-head clash entity
│   │   ├── product.dart       # Store product model
│   │   ├── reward.dart        # Digital & physical reward model
│   │   ├── player_profile.dart# User profile & cap tracker
│   │   └── leaderboard_player.dart # Community top players
│   ├── screens/
│   │   ├── main_navigation_screen.dart # 5-tab bottom container
│   │   ├── home_screen.dart   # Top brand spotlight & clash feeds
│   │   ├── play_screen.dart   # Game arena selection
│   │   ├── leaderboard_screen.dart # Brand & player rankings
│   │   ├── rewards_screen.dart# Vouchers & physical claims
│   │   ├── profile_screen.dart# Stats, cooldown & settings
│   │   └── games/
│   │       ├── matchmaking_screen.dart # Radar animation & 10s fallback
│   │       ├── quiz_game_screen.dart   # 1v1 brand trivia duel
│   │       ├── reaction_duel_screen.dart # Millisecond reflex duel
│   │       └── game_result_screen.dart  # Win/loss & reward drop
│   ├── services/
│   │   ├── wintowin_state.dart# Core reactive business logic
│   │   └── hardware_service.dart # Biometrics, camera, GPS, local db
│   ├── theme/
│   │   └── app_theme.dart     # Material 3 light & dark palettes
│   └── widgets/
│       ├── adaptive_dialog.dart # Cupertino / Material modal switcher
│       ├── platform_badge.dart# Active runtime target indicator
│       └── stat_card.dart     # KPI metric cards
├── test/
│   └── widget_test.dart       # Automated test suite
└── .github/
    └── workflows/
        └── build.yml          # Automated CI/CD for iOS & Android
```

---

## 5. Security Boundaries & Anti-Cheat Protocols

1. **Client-Server Trust Principle**: The mobile client is considered untrusted. Final match validation and rank updates are calculated server-side.
2. **Anti-Cheat Telemetry**:
   - Telemetry tracks touch coordinates and response velocity.
   - Impossible human reaction times ($< 80\text{ ms}$) trigger a silent audit flag and invalidates match points.
   - Enforced daily point cap ($1,000\text{ pts/day}$) completely neutralizes the incentive for 24/7 automated emulator bot farms.
3. **Brand Outbound Isolation**:
   - Product purchasing happens via external URLs (`url_launcher`).
   - WinToWin passes zero user financial data to third-party brand stores.
   - No payment credentials ever touch the mobile app.

