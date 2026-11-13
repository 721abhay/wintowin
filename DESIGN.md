# WinToWin — Design System & UX/UI Specification (DESIGN.md)

**Document Version:** 1.0  
**Design Standard:** Material 3 Adaptive with Cupertino Fidelity  
**Target Viewports:** Mobile (iOS / Android 360dp–430dp width) & Tablet/Desktop Web Dashboards

---

## 1. Visual Direction & Design Principles

### 1.1 Core Principles
1. **Dynamic Sports Arena Atmosphere**: WinToWin feels energetic, high-stakes, and competitive without resembling a dark casino or spammy reward app. It uses electric brand accents, high-contrast typography, and crisp tactile micro-animations.
2. **Transparent Hierarchy**: Numbers matter. Brand ranks, monetary contributions, player points, and countdown timers are visually emphasized using tabular/monospaced numerical styling.
3. **Adaptive Platform Parity**: The mobile app feels natively crafted on both iOS and Android. It renders Cupertino-style action sheets and pickers on iOS and Material 3 surfaces with ink splashes on Android.
4. **Zero Dark Patterns**: Rewards display honest expiry dates, countdowns, and terms. Claim buttons are prominent and uncluttered.

---

## 2. Color Palette & Theming System

### 2.1 Brand Palette (Tokens)
- **Primary Accent (Indigo)**: `#4F46E5` (Light) / `#818CF8` (Dark) — Main actions, primary buttons, active navigation indicators.
- **Secondary Accent (Cyan)**: `#06B6D4` (Light) / `#38BDF8` (Dark) — Stats, telemetry, info callouts.
- **Victory & Success (Emerald)**: `#10B981` — Wins, active vouchers, approved claims, online indicators.
- **High-Alert / Urgent (Amber)**: `#F59E0B` — Rank #1 gold badges, countdown timers, overtake cost callouts.
- **Defeat / Danger (Rose Red)**: `#EF4444` — Match losses, false starts, cooldown warnings.

### 2.2 Surface & Neutral Tokens

| Token | Light Mode | Dark Mode | Usage |
| :--- | :--- | :--- | :--- |
| `background` | `#F8FAFC` (Slate 50) | `#090D16` (Deep Midnight) | Main app canvas |
| `surface` | `#FFFFFF` (Pure White) | `#0F172A` (Slate 900) | Cards, bottom sheets, navigation |
| `surfaceSubtle`| `#F1F5F9` (Slate 100)| `#1E293B` (Slate 800) | Secondary containers, text fields |
| `border` | `#E2E8F0` (Slate 200)| `#1E293B` (Slate 800) | 1px card and divider boundaries |
| `textPrimary` | `#0F172A` (Slate 900)| `#F8FAFC` (Slate 50) | Primary headlines and labels |
| `textSecondary`| `#64748B` (Slate 500)| `#94A3B8` (Slate 400)| Subtitles, captions, metadata |

---

## 3. Typography Hierarchy

The type system prioritizes legibility in fast-paced 1v1 gaming contexts:

| Style | Size | Weight | Line Height | Usage |
| :--- | :--- | :--- | :--- | :--- |
| **Display Large** | 28px | 900 (Black) | 34px | Victory/Defeat screen banners |
| **Display Medium**| 22px | 700 (Bold) | 28px | Top brand spotlight headline, screen titles |
| **Title Medium**  | 17px | 700 (Bold) | 24px | Section headers, product cards |
| **Body Large**    | 15px | 600 (Semi-bold)| 22px | Game question text, button labels |
| **Body Small**    | 13px | 400 (Regular) | 18px | Descriptions, terms, secondary metadata |
| **Data Monospace**| 14px | 800 (Extra-bold)| 18px | Millisecond timers, promo codes, tracking IDs |

---

## 4. Spacing, Grid & Elevation

- **Baseline Spacing Grid**: 4px base increment (`4px`, `8px`, `12px`, `16px`, `20px`, `24px`, `32px`).
- **Screen Padding**: Standard horizontal padding is `16px` across mobile viewports.
- **Corner Radii**:
  - Small pills & badges: `8px` to `12px`
  - Cards & text fields: `14px` to `16px`
  - Bottom sheets & Hero banners: `24px`
- **Elevation & Shadows**: Flat elevation with subtle tinted borders (`1px solid borderToken`) and soft blur shadows (`blur: 16px, y-offset: 8px, opacity: 0.12`).

---

## 5. Component Library & Patterns

### 5.1 Navigation Architecture
- **Bottom Navigation Bar**: 5 items: `Home`, `Play`, `Board`, `Rewards`, `Profile`.
- Selected items feature filled icons and a soft brand-colored capsule indicator.
- Unselected items use outline icons with `textSecondary` tint.

### 5.2 Top Brand Spotlight Hero Card
- Gradient background matching the #1 brand's signature color.
- Crown badge: "RANK #1 LEADER".
- Prominent dual action: "Play for Brand" (primary filled) and "View Board" (outlined).

### 5.3 Live Brand Battle Cards
- Split-progress bar visualizing the point ratio between Brand A and Brand B.
- Active countdown pill: "Ends in Xh Ym".
- "Play Clash" quick-action button triggering instant matchmaking.

### 5.4 Game Arena UI
- **Trivia Duel**: Top sticky scoreboard with circular countdown badge. Question text in high-contrast card. 4 distinct choice tiles with instant green (correct) or red (incorrect) state change.
- **Reaction Duel**: Full-screen reactive tap canvas. State transitions:
  - Red canvas (`#DC2626`): "Wait for GREEN... (Tapping now = False Start)"
  - Bright Green canvas (`#10B981`): "⚡ TAP NOW!"
  - Blue canvas (`#4F46E5`): "Calculating Milliseconds..."

### 5.5 Reward Vouchers & Physical Cards
- Cut-out coupon aesthetic or modern fintech card.
- Monospaced promo code display with instant "Copy" action and tactile toast confirmation.
- Status badges: `Digital Voucher`, `Physical Product - Out for Delivery`, `Claim Address Needed`.

---

## 6. UX States: Loading, Empty, and Error

### 6.1 Loading States
- **Matchmaking**: Pulsing circular radar animation with active second timer (0 to 10s).
- **Listings / Feeds**: 16px rounded skeleton shimmer blocks matching exact card geometries.

### 6.2 Empty States
- **Zero Vouchers in Wallet**: Friendly illustration with copy: *"No active rewards yet. Win your first 1v1 match to unlock instant coupons!"* and a prominent *"Go to Game Arena"* button.
- **No Search Results**: *"No brands or features match your search. Try searching for Sportswear or Audio."*

### 6.3 Error States
- **Offline Network**: Non-blocking top snackbar: *"Connection lost. Playing in offline practice mode."*
- **False Start in Reaction Duel**: Immediate vibration, screen flashes dark red with text: *"False Start! 1 Round Penalty."*

---

## 7. Accessibility & Touch Targets

- **Minimum Touch Targets**: All interactive buttons, chips, and tap cards maintain a minimum touch bounding box of $48 \times 48\text{ dp}$.
- **Contrast Ratios**: Body text meets WCAG AA standards (minimum 4.5:1 against respective light/dark surface).
- **Reduced Motion Support**: Animations respect system-level `prefers-reduced-motion` settings.
