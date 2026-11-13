# ARCHITECTURE.md: WinToWin

Defines how the product is built. Source documents: PRD.md and DESIGN.md. Items marked **[APPROVAL]** need the owner's decision. Provider capabilities and pricing must be verified against current documentation before building.

## 1. Architecture Principles
- Simplest reliable setup. One managed backend, no microservices, no self-managed servers.
- The server decides everything that matters: scores, ranks, payments, rewards. The client only displays and requests.
- MVP and future scale are kept separate (section 14).
- Do not add dependencies not listed here without approval.

## 2. Recommended Tech Stack

| Layer | Choice | Reasoning |
|---|---|---|
| Player app | Flutter (Android first) | One codebase for Android and iOS; matches the owner's existing skills |
| Backend platform | Supabase | Managed Postgres, auth, realtime, serverless functions, and scheduled jobs in one place |
| Database | PostgreSQL (via Supabase) | Relational data fits users, brands, payments, scores; row-level security enforces ownership |
| Server logic | Supabase Edge Functions plus Postgres functions | Webhooks, matchmaking, scoring, and rank calculation stay on the server |
| Realtime | Supabase Realtime | Live matches and leaderboard updates without running a separate WebSocket server |
| Brand dashboard and admin | Next.js (TypeScript) on Vercel | Fast to build and deploy; one web app with two protected areas |
| Payments | Razorpay | India-first; signed webhooks for confirmation |
| Push notifications | Firebase Cloud Messaging | Standard for Flutter |
| Phone OTP | SMS provider connected to Supabase Auth | Needs India SMS compliance setup (see section 9) **[APPROVAL]** |
| Error monitoring | Sentry (app and web) | Simple setup, covers Flutter and Next.js |

**Alternative considered:** Firebase for everything. Rejected for MVP because the data is relational and ranking queries and ownership rules are cleaner in Postgres. **[APPROVAL]**

## 3. System Overview

```
Player app (Flutter) ──┐
                       ├──> Supabase (Auth, Postgres + RLS, Realtime, Edge Functions, Scheduled jobs)
Brand/Admin web (Next.js)┘            │
                                      ├──> Razorpay (payments, webhooks)
                                      ├──> SMS provider (OTP)
                                      └──> Firebase Cloud Messaging (push)
```

There is no custom API server. Clients talk to Supabase directly for safe reads (protected by row-level security) and call Edge Functions for any action with side effects.

## 4. Frontend Architecture

### Player app (Flutter)
- Feature-first structure: auth, brands, games, leaderboard, rewards, profile, notifications.
- State management: one approach used everywhere (Riverpod). **[APPROVAL]**
- Data access only through repository classes. Screens never call the backend directly.
- Design tokens (colours, type, spacing) from DESIGN.md live in one theme module.
- Local cache of the last leaderboard and rewards for offline display.

### Brand and admin web (Next.js)
- Two route groups: `/brand` and `/admin`, each guarded by role.
- Shared component library built from DESIGN.md.
- Server-side data fetching for dashboards; payment start is a server action calling an Edge Function.

## 5. Backend Architecture

All business logic runs in the database or Edge Functions:

| Function | Purpose |
|---|---|
| `start-match` | Matchmaking, creates match, issues questions, bot fallback after about 10 seconds |
| `submit-answer` | Validates an answer against the server-held answer key, records score |
| `finish-match` | Closes the match, awards points to player and brand (applies the daily cap) |
| `create-payment-order` | Validates the minimum outbid and creates the Razorpay order |
| `razorpay-webhook` | Verifies the signature, records the payment once, triggers rank recalculation |
| `recalculate-ranks` | Computes Money Score, Player Score, and combined score for every approved brand |
| `issue-reward` | Issues a reward if stock remains; transactional |
| `claim-reward` | Marks a reward as used and returns the code |
| `track-click` | Records a product click and returns the brand URL |
| Scheduled: `daily-snapshot` | Stores a rank snapshot |
| Scheduled: `expire-rewards` | Marks expired rewards |

Quiz answers are never sent to the client before the question is answered.

## 6. Data Flow

### A match
1. Player taps Play. App calls `start-match`.
2. Server pairs the player or assigns a bot, and returns the first question (without the answer).
3. Each answer goes to `submit-answer`; the server checks it and replies with correctness and the next question.
4. When time ends, `finish-match` awards points, applies the daily cap, may call `issue-reward`, and updates the player's brand points.
5. `recalculate-ranks` updates the leaderboard; Realtime pushes the change to subscribed clients.

### A brand payment
1. Brand enters an amount. The web app calls `create-payment-order`; the server checks the minimum outbid.
2. Brand pays in the Razorpay checkout.
3. Razorpay sends a webhook. `razorpay-webhook` verifies the signature, records the payment once (using the provider payment id as a unique key), and calls `recalculate-ranks`.
4. The outbid brand receives a push notification.
5. The brand's screen shows Processing until the webhook result is stored, then Confirmed.

### A reward
1. A win, rank placement, or drop triggers `issue-reward`.
2. The function checks stock and the brand's rules in one transaction, then creates the reward for the player.
3. The player sees it in the wallet and claims it with `claim-reward`.

## 7. Folder Structure

```
wintowin/
├── apps/
│   ├── mobile/                 Flutter player app
│   │   └── lib/
│   │       ├── core/           theme, routing, config, error handling
│   │       ├── data/           repositories, models
│   │       └── features/       auth, brands, games, leaderboard, rewards, profile, notifications
│   └── web/                    Next.js brand and admin app
│       ├── app/
│       │   ├── (public)/       login, register
│       │   ├── brand/          brand dashboard
│       │   └── admin/          admin panel
│       ├── components/
│       └── lib/
├── supabase/
│   ├── migrations/             SQL schema changes (DATABASE.md)
│   ├── functions/              Edge Functions (one folder each)
│   ├── seed/                   development data
│   └── tests/                  database and function tests
├── docs/                       PRD.md, DESIGN.md, ARCHITECTURE.md, DATABASE.md, API.md
├── AGENTS.md
└── README.md
```

## 8. Database Interaction
- Postgres is the single source of truth. Schema is defined in DATABASE.md.
- All schema changes are versioned migrations. No manual changes in production.
- Clients read through row-level security. Writes that affect scores, payments, ranks, or rewards happen only inside Edge Functions or database functions using the service role.
- Weekly Player Score is calculated from timestamped point records over the current week window, so no data is deleted at reset.
- Current ranks are cached in a table refreshed by `recalculate-ranks`; history is stored in daily snapshots.

## 9. Authentication and Authorization

### Authentication
- **Players:** phone OTP through Supabase Auth with an SMS provider. India requires registered SMS sender and template compliance (DLT); this must be arranged before launch. **[APPROVAL]**
- **Brands and admins:** email and password through Supabase Auth, with email verification.
- Sessions use short-lived access tokens with refresh tokens, stored in secure storage on mobile.

### Authorization
- Role stored server-side (player, brand, admin). The client never decides the role.
- Row-level security: players access only their own matches, rewards, and notifications; brands access only their own products, rewards, payments, and analytics; admins access all.
- Brand accounts are inactive until an admin approves them.
- Admin accounts are created manually, with two-factor authentication required. **[APPROVAL]**

## 10. API Architecture
- Reads: direct Supabase queries under row-level security, through repositories only.
- Actions: named Edge Functions listed in section 5. Detailed contracts will be in API.md.
- Responses use one consistent JSON shape for success and errors.
- Every action function validates input, checks role and ownership, and is idempotent where money or rewards are involved.

## 11. External Services
| Service | Used for | Failure behaviour |
|---|---|---|
| Razorpay | Payments | Show Pending; confirmation only through webhook; reconcile pending payments by a scheduled check |
| SMS provider | OTP | Show clear retry message; limit attempts |
| FCM | Push | Failure never blocks the main action |
| Sentry | Errors | Optional at runtime |

## 12. AI Architecture
No AI features in MVP. Not required by PRD.md.

## 13. Environment Configuration
Three environments: **local**, **staging**, **production**, each with its own Supabase project and Razorpay keys (test keys outside production).

| Variable | Where used | Visibility |
|---|---|---|
| SUPABASE_URL | App, web, functions | Public |
| SUPABASE_ANON_KEY | App, web | Public (protected by row-level security) |
| SUPABASE_SERVICE_ROLE_KEY | Edge Functions only | Secret |
| RAZORPAY_KEY_ID | Web (checkout) | Public |
| RAZORPAY_KEY_SECRET | Edge Functions only | Secret |
| RAZORPAY_WEBHOOK_SECRET | Edge Functions only | Secret |
| SMS_PROVIDER credentials | Supabase Auth settings | Secret |
| FCM service credentials | Edge Functions only | Secret |
| SENTRY_DSN | App, web | Public |

Rules: no secrets in the repository or in client code. Provide a `.env.example` with names only.

## 14. Error Handling
- Edge Functions return structured errors with a stable code and a safe message.
- Clients map codes to the messages defined in DESIGN.md. Players never see raw errors.
- Unexpected errors are logged to Sentry with no phone numbers, tokens, or payment details.
- Money and reward operations run in database transactions. A failure leaves no partial state.
- Webhook processing is idempotent: repeated deliveries do nothing.

## 15. Security Boundaries
- **Client (untrusted):** can only display data and request actions.
- **Supabase with row-level security:** enforces who can read what.
- **Edge Functions with service role:** the only place scores, payments, ranks, and rewards change.
- Payment amounts are taken from the server-created order, never from the client.
- Rate limiting on OTP, matchmaking, and payment creation.
- Anti-abuse: one account per phone number, daily point cap per player, server-side answer checking.
- Personal data kept minimal: phone number, display name, chosen brand.

## 16. Testing Approach
- **Database:** tests for row-level security and for rank calculation with known inputs.
- **Edge Functions:** unit tests for validation, scoring, daily cap, stock limits, and duplicate webhooks.
- **Flutter:** widget tests for key screens; integration test for login to match to result.
- **Web:** component tests and an end-to-end test for brand registration to payment (Razorpay test mode).
- Critical paths are prioritised: payments, rank calculation, reward stock, authorization.

## 17. Deployment Approach
- Supabase: separate staging and production projects; migrations applied through the Supabase command line from CI.
- Web: Vercel with preview deployments from branches and production from the main branch.
- Mobile: Android release through Google Play internal testing first.
- CI (GitHub Actions): lint, type-check, tests, and migration check on every pull request.
- Backups: Supabase automated backups; restore procedure tested before launch.

## 18. MVP vs Future Scalability

| Area | MVP | Later |
|---|---|---|
| Games | One 1v1 quiz with bot fallback | More games, team mode, location zones |
| Matchmaking | Simple queue in the database | Dedicated matchmaking service if load requires |
| Ranking | Recalculate on events | Cached ranks with incremental updates |
| Rewards | Digital coupons | Physical rewards with order tracking |
| Payments | Razorpay | Stripe and international |
| Platforms | Android | iOS |
| Search and analytics | Basic queries | Dedicated analytics store |

Scale only when measured load requires it.

## 19. Decisions Requiring Approval
1. Supabase instead of Firebase.
2. Riverpod for Flutter state management.
3. Next.js on Vercel for brand and admin.
4. SMS provider choice and DLT registration plan.
5. Two-factor authentication for admins.
6. Sentry for monitoring.
