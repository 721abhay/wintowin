# DESIGN.md: WinToWin

Source of truth for visual design and UX. Product requirements live in PRD.md. Items marked **[APPROVAL]** need the owner's decision. All colour values must be checked for contrast in the real UI before release.

## 1. Visual Direction and Design Principles

**Direction:** a clean, confident, sports-scoreboard feel. Neutral surfaces, strong numerals, one energetic accent. Brands bring their own colours, so the app itself stays visually quiet and lets brands and scores stand out.

**Principles**
1. **Scores are the hero.** Ranks, points, and money are the most important content. Large, tabular numerals.
2. **Fair by design.** No brand can change layout, size, or typography of the app. Brands appear in fixed slots with fixed styling. Their colour appears only in permitted places (section 3.3).
3. **Fast to play.** From opening the app to a match in at most three taps.
4. **Honest rewards.** Always show what was won, its expiry, and how to use it. Never hide terms.
5. **Calm, not noisy.** Motion and celebration are brief and earned.

**Avoid:** purple-to-blue gradients, glassmorphism, stock illustrations, decorative emojis, floating blobs, and identical card grids with no hierarchy.

## 2. Platforms
- **Player app:** mobile (Android first), designed at 360 to 430 dp width.
- **Brand dashboard and admin panel:** responsive web, desktop first.

## 3. Colours

### 3.1 Core palette
| Token | Hex | Use |
|---|---|---|
| ink | #14161C | Primary text, dark surfaces |
| ink-muted | #5B6070 | Secondary text |
| canvas | #F6F4EF | App background |
| surface | #FFFFFF | Cards, sheets |
| line | #E2DFD6 | Borders and dividers |
| primary | #0E7A5F | Primary buttons, links, selected tab |
| on-primary | #FFFFFF | Text on primary |
| win-gold | #F2A900 | Rank badges, win moments, highlights (fill only) |
| on-gold | #14161C | Text on gold |
| danger | #C62828 | Errors, destructive actions |
| warning | #B26A00 | Pending, expiring soon |
| success | #0E7A5F | Confirmation (same as primary) |

Rules: gold is used as a fill, never as text on light backgrounds. Text colours must meet WCAG AA contrast (4.5:1 body, 3:1 large text).

### 3.2 Dark mode
Dark mode is out of scope for MVP. **[APPROVAL]**

### 3.3 Brand colour usage
A brand may supply one accent colour. It may appear **only** in: the brand logo chip background, a 4 dp stripe on that brand's card header, and the supporter badge. It never colours text, buttons, or backgrounds of whole screens. If a brand colour fails contrast, the app falls back to ink for any text placed on it.

## 4. Typography

| Role | Font | Weight | Size / line |
|---|---|---|---|
| Display (scores, rank) | Sora | 700 | 32 / 38 |
| Heading 1 | Sora | 600 | 24 / 30 |
| Heading 2 | Sora | 600 | 18 / 24 |
| Body | Manrope | 500 | 16 / 24 |
| Body small | Manrope | 500 | 14 / 20 |
| Caption | Manrope | 600 | 12 / 16 |
| Button | Manrope | 700 | 16 / 20 |

- Numbers (scores, rank, prices) use tabular figures so columns align.
- Fallback font for Hindi and other Indian scripts: Noto Sans Devanagari or the matching Noto Sans script.
- Support system text scaling up to 200% without clipping.

## 5. Spacing and Layout

- **Base unit:** 4 dp. Allowed spacing: 4, 8, 12, 16, 24, 32, 48.
- **Screen padding:** 16 dp horizontal on mobile.
- **Corner radius:** 8 (inputs, chips), 12 (cards), 16 (bottom sheets), full (pills, avatars).
- **Elevation:** prefer 1 dp borders (`line`) over shadows. One shadow level only, for floating sheets and dialogs.
- **Grid:** single column on mobile. Web dashboards use a 12-column grid with 24 px gutters and a max content width of 1200 px.

## 6. Reusable Components

### 6.1 Buttons
- **Primary:** filled `primary`, white text, 48 dp height, 12 dp radius. One per screen.
- **Secondary:** 1 dp `line` outline, ink text.
- **Text button:** primary colour text, no background.
- **Destructive:** danger fill, used only with a confirmation step.
- **Disabled:** 40% opacity and no ripple. Always show why (helper text).

### 6.2 Cards
- **Brand card:** logo chip, brand name, rank badge, supporter count, brand stripe. Same size for every brand.
- **Leaderboard row:** rank number, logo chip, name, combined score, and a score breakdown bar (6.4).
- **Reward card:** brand logo, reward title, type tag (coupon, discount, product), expiry, status.
- **Match card:** game name, duration, "Play" action.
- **Product card:** image, name, price shown by brand, "View on brand site."

### 6.3 Rank badge
Circle with rank number. Gold fill for rank 1, `line`-coloured fill with ink text for others. Rank movement is shown with an arrow icon plus the number, never colour alone.

### 6.4 Score breakdown bar
A two-segment horizontal bar showing **Money points** and **Player points** side by side, with labels and values. This is the core fairness component and appears on the leaderboard, brand detail, and brand dashboard.

### 6.5 Inputs
- 48 dp height, 8 dp radius, visible label above the field (no placeholder-only labels).
- Error text beneath in `danger` with an icon.
- **OTP input:** six separate boxes, auto-advance, auto-submit on the sixth digit, paste support.
- **Amount input (brand payment):** large numeric field, helper text "Minimum to reach #N: amount," live total.

### 6.6 Navigation components
- **Bottom navigation (player):** five tabs: Home, Play, Leaderboard, Rewards, Profile. Icon plus label always visible. Selected tab uses `primary`.
- **Top bar:** title, optional back arrow, optional notifications icon.
- **Web sidebar (brand and admin):** fixed left, 240 px, collapses to icons below 1024 px.

### 6.7 Feedback components
- **Toast:** short confirmations, 3 seconds, bottom position above navigation.
- **Banner:** persistent notices (payment pending, brand awaiting approval).
- **Dialog:** only for destructive or irreversible actions.
- **Bottom sheet:** reward details, filters, confirmations.

### 6.8 Skeletons, empty, and error blocks
- **Skeleton:** grey blocks matching the final layout, with a subtle shimmer.
- **Empty state:** one line of text, one supporting sentence, one action.
- **Error state:** plain explanation, retry button, and cached content where available.

## 7. Navigation Structure

**Player app**
- Tabs: Home, Play, Leaderboard, Rewards, Profile.
- Pushed screens: Brand detail, Reward detail, Product handoff, Notifications, Help, Terms.
- Game screens (match, result) are full-screen and hide the bottom navigation.
- Login and onboarding screens appear only before the first session.

**Brand dashboard sidebar:** Overview, Boost Rank, Products, Rewards, Analytics, Billing, Settings.
**Admin sidebar:** Brand approvals, Users, Payments, Rewards, Flagged activity, Settings.

## 8. Forms
- One primary action per form.
- Validate inline after a field loses focus, and again on submit.
- Never clear a form on error.
- Long forms (brand registration) are split into steps with a visible progress indicator.
- Payment confirmation always shows the amount and the resulting rank before the final pay button.
- Keyboard type matches the field (numeric for OTP and amounts, email for email).

## 9. Loading, Empty, and Error States
Follow the table in PRD.md section 9. Design rules:
- Loading shows skeletons for anything over 300 ms. Full-screen spinners are only for payment processing.
- Empty states always include a next action.
- Errors never show raw codes to players. Admin and brand screens may show a reference id.
- Payment states are explicit: **Processing**, **Confirmed**, **Failed (not charged)**, **Pending (we'll confirm)**.
- Offline: show a persistent banner and the last cached leaderboard.

## 10. Interactions and Animations
- **Duration:** 150 to 250 ms for transitions, ease-out.
- **Rank change:** the row slides to its new position, and the badge number updates. Under 400 ms.
- **Score update:** number counts up quickly, under 600 ms.
- **Match countdown:** 3-2-1 before start, then a visible timer bar.
- **Win moment:** short gold highlight on the result card and a single confetti burst, maximum 1.2 seconds, shown only for wins and reward drops.
- **Haptics:** light haptic on button press in matches and on reward earned.
- **Reduced motion:** if the device setting is on, replace all motion with instant state changes or simple fades.

## 11. Responsive Behaviour
| Context | Breakpoint | Behaviour |
|---|---|---|
| Player app, small phone | 320 to 359 dp | Reduce side padding to 12 dp; stack stats vertically |
| Player app, standard | 360 to 430 dp | Base layout |
| Player app, tablet | above 600 dp | Centre content at max 560 dp width |
| Web dashboard | below 640 px | Sidebar becomes a top menu; tables become stacked cards |
| Web dashboard | 640 to 1023 px | Collapsed icon sidebar |
| Web dashboard | 1024 px and up | Full sidebar, multi-column content |

Tables with more than four columns scroll horizontally inside their own container on small screens.

## 12. Accessibility Requirements
- WCAG 2.1 AA minimum.
- Touch targets at least 48 x 48 dp.
- All icons that carry meaning have text labels or accessible descriptions.
- Never rely on colour alone (rank movement, errors, status).
- Screen reader order matches visual order. Each leaderboard row reads as one sentence, for example "Rank 2, Brand name, combined score 74, money 80, players 68."
- Quiz timer: announce time remaining at intervals, and allow an accessibility setting that extends time. **[APPROVAL]**
- Focus visible on all interactive web elements.
- Support system font scaling up to 200%.
- Form errors are announced and linked to their field.

## 13. Page-Level Layout Guidance

### Player app
- **Login and OTP:** logo, one input, one primary button. No other content.
- **Choose a brand:** vertical list of brand cards with a single "Support" action. Rank and supporter count visible. A confirmation sheet states the switch cooldown.
- **Home:** order from top: top-brand banner (fixed slot), live battle or daily challenge card, "Play now" action, trending products from the #1 brand, reward summary.
- **Play:** game card(s), then recent matches. In matches: opponent and brand chips at top, question area centre, timer bar below the top bar, answer buttons in the thumb zone.
- **Result:** large result text, points earned for player and brand, reward drop if any, two actions: Play again, Back home.
- **Leaderboard:** segmented toggle (Brands, Players). Brand view: list of leaderboard rows with score breakdown bars; tapping opens brand detail. A sticky "Your brand" row remains visible at the bottom.
- **Brand detail:** header with logo and stripe, rank, score breakdown, supporters, products, rewards offered.
- **Rewards:** tabs (Active, Used, Expired). Reward card shows a code or status and expiry. Detail opens in a bottom sheet.
- **Profile:** display name, supported brand, stats, settings, help, logout.

### Brand dashboard
- **Overview:** rank and score breakdown at top, then key numbers (supporters, clicks, claims, spend), then "Amount to pass the brand above" with a Boost Rank action.
- **Boost Rank:** current standing, amount field, live preview of the new rank, payment summary, pay button.
- **Products and Rewards:** table with add button, edit in a side panel, stock and expiry visible.
- **Analytics:** simple charts with a date range filter and plain-language summary above each chart.

### Admin panel
- Data tables with filters, status chips, bulk-safe actions only (no mass destructive actions), and a detail side panel for approvals with the brand's submitted documents.

## 14. Design Decisions Requiring Approval
1. Dark mode out of MVP (proposed: yes).
2. Font pairing Sora plus Manrope.
3. Accent colours (primary green, win gold) and the "brand colour only in stripe, chip, and badge" rule.
4. Extended-time accessibility setting for the quiz.
5. English only at MVP, or English and Hindi. **[ASSUMPTION]** English only, but layouts must tolerate longer text.
