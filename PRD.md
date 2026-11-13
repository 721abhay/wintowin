# WinToWin — Product Requirements Document (PRD)

**Document Version:** 1.0  
**Status:** Approved for Implementation  
**Product Owner:** Abhay  
**Target Platforms:** Mobile (iOS & Android via Flutter), Web Dashboards (Brand & Admin)

---

## 1. Executive Summary & Value Proposition

### 1.1 Problem Statement
- **For Brands**: Traditional digital advertising has become passive, expensive, and heavily ignored (banner blindness, ad-blockers, declining click-through rates). Brands struggle to turn passive ad viewers into emotionally invested advocates.
- **For Consumers**: Players spend millions of hours on casual mobile games with zero tangible return or face predatory pay-to-win/gambling mechanics that require constant monetary deposits.

### 1.2 Value Proposition
- **WinToWin** bridges casual competitive gaming and brand sponsorship:
  - **For Players**: 100% free-to-play competitive casual games. Players back their chosen brand, compete in 1v1 and team battles, push their brand up the public leaderboard, and win real rewards (instant discount vouchers, exclusive coupons, and actual physical products). Players never pay any money.
  - **For Brands**: An active, high-intent gamified marketing arena. Brands pay to boost their leaderboard standing. Because brand rank is determined 50% by monetary spend and 50% by player game victories, brands earn authentic tribal loyalty and sales conversions.
  - **Zero Logistics Burden**: Winning players redeem products and coupons directly through brand-hosted e-commerce links. Brands handle payment, fulfillment, shipping, and customer support.

---

## 2. Target Users & User Personas

### 2.1 Player Persona ("The Competitive Deal Hunter")
- **Profile**: 18–34 years old, mobile-first, plays casual games during commutes and breaks.
- **Goals**: Wants fast, skill-based games (1–3 minutes), loves discounts and free merchandise, enjoys sports/brand rivalries (e.g., Nike vs. Adidas).
- **Key Pain Point**: Dislikes ads that interrupt games and refuses to pay real money for in-game gems or pay-to-win upgrades.

### 2.2 Brand Persona ("The Growth Marketing Director")
- **Profile**: D2C (Direct-to-Consumer) and enterprise consumer brands in sportswear, electronics, beverage, and personal care.
- **Goals**: Wants quantifiable engagement, brand advocacy, and verifiable outbound click-through sales without high ad fraud.
- **Key Pain Point**: Rising Cost Per Acquisition (CPA) on Google and Meta ads with low brand retention.

### 2.3 Admin Persona ("Platform Operator")
- **Profile**: WinToWin internal operations and compliance team.
- **Goals**: Approves legitimate brands, moderates matches, verifies anti-cheat telemetry, monitors Razorpay payouts and prize pool distributions.

---

## 3. Core Mechanics & Brand Ranking Formula

### 3.1 The 50/50 Brand Ranking Formula
A brand's live position on the Brand Leaderboard is governed by the formula:

$$\text{Final Rank Score} = (0.5 \times \text{Money Score}) + (0.5 \times \text{Player Score})$$

Where:
- $\text{Money Score} = \left(\frac{\text{Brand Total Paid}}{\text{Highest Brand Total Paid}}\right) \times 100$
- $\text{Player Score} = \left(\frac{\text{Brand Gameplay Points}}{\text{Highest Brand Gameplay Points}}\right) \times 100$

### 3.2 Leaderboard Rules & Anti-Dominance Constraints
1. **Outbidding Requirement**: To advance in rank via spend, a brand must pay an amount greater than the brand immediately above it. The app displays the exact amount required to overtake rank $\#(N-1)$.
2. **Weekly Reset for Gameplay**: Player Points reset every Sunday at 23:59:59 UTC to keep the competition dynamic. Monetary scores carry over.
3. **Daily Player Cap**: Individual players can contribute a maximum of **1,000 gameplay points per 24 hours**. This eliminates bot-farm manipulation and prevents single-player dominance.
4. **Transparent Audit**: The public leaderboard displays Money Score, Player Score, and Combined Score side-by-side.

---

## 4. User Roles & Permissions

| Role | Access Level | Primary Actions |
| :--- | :--- | :--- |
| **Player** | Mobile App (iOS / Android) | Choose supported brand, play 1v1 duels, view leaderboards, claim vouchers, submit shipping address for physical prizes, click brand store links. |
| **Brand Manager** | Web Portal | Register company, upload KYC (GST/Incorporation), manage product catalog, fund rank boost via Razorpay/Stripe, track outbound clicks, view reward inventory. |
| **Admin** | Admin Web Portal | Approve/reject brand registrations, monitor anti-cheat logs, manage prize allocations, review disputed reward claims, configure seasonal parameters. |

---

## 5. Functional Requirements & Feature Scope

### 5.1 Player Mobile Application
- **Authentication**: Phone OTP authentication (Firebase Auth / SMS gateway) with Google OAuth backup. 1 account per physical phone number.
- **Onboarding Flow**:
  1. Login with OTP.
  2. Choose supported brand (with brand logo, rank, and supporter tally).
  3. Interactive tutorial match against bot (guaranteed win).
  4. Welcome reward unlock (instant coupon in wallet).
  5. Home dashboard arrival.
- **Brand Switching & Cooldown**: Players can switch their supported brand, subject to a strict **7-day cooldown** to prevent bandwagoning.
- **Game Arena (MVP Launch Games)**:
  - **1v1 Brand Trivia Quiz**: 5 rapid-fire multiple-choice questions (10s timer per question, speed bonuses, brand slogans and products).
  - **1v1 Reaction Duel**: Reflex test ("Wait for Green... TAP!"). Sub-millisecond stopwatch with False Start penalties across Best-of-3 rounds.
  - **Smart Matchmaking**: Zone/city matchmaking with a **guaranteed 10-second bot fallback** if no human opponent connects.
- **Rewards Wallet**:
  - **Digital Vouchers**: Real-time display of discount codes, copy-to-clipboard, expiry timer, terms of use.
  - **Physical Product Claims**: Form to input shipping details; passes order data directly to brand; displays courier tracking updates.
- **Featured Brand Spotlight & Shopping**:
  - Carousel of trending products from the #1 ranked brand.
  - Outbound "Shop on Site" links launching the brand's verified website via in-app browser or native browser with tracking parameters.

### 5.2 Brand Web Dashboard
- **Brand Registration & KYC**: Business email registration, GST/Tax ID upload, website verification.
- **Rank Booster**: Displays current rank, amount paid, supporter points, and the exact minimum payment needed to overtake the next rank. Integrates Razorpay / Stripe checkout.
- **Catalog & Rewards Inventory**: Upload product images, URLs, prices, discount coupon codes, and physical reward inventory pools.
- **Analytics**: Real-time tracking of outbound clicks, supporter count, matches played for brand, and voucher redemption rates.

### 5.3 Admin Control Panel
- **Brand Approvals**: Review KYC, approve or reject pending brands.
- **Fraud & Anti-Cheat**: Monitor daily point cap violators, emulator signatures, and anomalous reaction times (<80ms flags).
- **Finance & Payouts**: Review platform fees, prize pool escrow allocations, and tax reports.

---

## 6. Non-Functional Requirements

### 6.1 Performance & Latency
- Mobile app cold launch time: $< 2.0$ seconds on modern iOS and Android devices.
- Game matchmaking latency: Opponent found or bot assigned in $\le 10$ seconds.
- Frame rate target: Consistent 60 FPS (with 120 FPS Impeller support on compatible ProMotion and 120Hz AMOLED screens).

### 6.2 Security & Compliance
- **Zero Real-Money Gaming for Players**: Players never deposit, gamble, or wager money. All prizes are sponsored promotional marketing rewards, compliant with Indian and international consumer sweepstakes/contest laws.
- **Client-Server Trust Boundary**: Game score calculations, win verifications, and point disbursements must be calculated or signed server-side.
- **Rate Limiting**: API calls rate-limited to 60 requests/minute per authenticated user.

### 6.3 Reliability & Availability
- Core API uptime target: 99.9% availability.
- Offline resilience: Graceful connection recovery and cached asset fallback.

---

## 7. MVP Scope vs. Future Roadmap

### In Scope for MVP (Phase 1)
- Flutter mobile app for iOS & Android with phone OTP login.
- 5 core bottom tabs: Home, Play, Board, Rewards, Profile.
- 2 launch games: 1v1 Trivia Quiz & 1v1 Reaction Duel with 10s bot fallback.
- Brand Leaderboard with 50/50 formula and overtake cost indicator.
- Digital vouchers and physical product claim flow.
- Outbound click-through shopping links to brand stores.
- Razorpay test payment integration for brand rank boosting.

### Out of Scope for MVP (Phase 2 & Phase 3)
- Real-time location-based GPS zone capture battles (Phase 3).
- Team multi-player tournaments with brackets (Phase 3).
- In-house shipping and fulfillment logistics (Strict Non-Goal).
- Direct in-app e-commerce payment checkout for third-party goods (Strict Non-Goal).

---

## 8. Success Metrics & KPIs
1. **Player Retention**: D1 $\ge 45\%$, D7 $\ge 25\%$, D30 $\ge 12\%$.
2. **Engagement**: Average matches played per active user $\ge 4.5$ matches/day.
3. **Brand ROI**: Outbound store click-through rate (CTR) on trending products $\ge 8\%$.
4. **Monetization**: Total brand sponsor boost payments processed per month.

