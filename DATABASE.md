# WinToWin — Database Architecture & Schema Specification (DATABASE.md)

**Document Version:** 1.0  
**Database Engine:** PostgreSQL 16+ (Supabase / AWS RDS)  
**Schema Standard:** Relational with UUID primary keys, strict foreign key constraints, and Row-Level Security (RLS)

---

## 1. Entity-Relationship Overview

```
+--------------------+        1:N        +-----------------------+
|       users        |-------------------|     match_history     |
+--------------------+                   +-----------------------+
         |                                           |
         | 1:N (supported brand)                     |
         v                                           v
+--------------------+        1:N        +-----------------------+
|       brands       |-------------------|    brand_battles      |
+--------------------+                   +-----------------------+
         | 1:N                                       |
         |                                           |
         +-------------------+                       |
         |                   |                       |
         v                   v                       v
+----------------+   +---------------+   +-----------------------+
|    products    |   |    rewards    |   |  reward_claims (prizes)|
+----------------+   +---------------+   +-----------------------+
         |                   |                       ^
         v                   v                       |
+----------------+   +---------------+               |
| brand_payments |   | reward_wallet |---------------+
+----------------+   +---------------+
```

---

## 2. Table Definitions & Data Dictionary

### 2.1 `users` (Players, Brand Managers, Admins)
Stores core identity and gameplay limits.

```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'player' CHECK (role IN ('player', 'brand_manager', 'admin')),
    supported_brand_id UUID REFERENCES brands(id) ON DELETE SET NULL,
    last_brand_switch_at TIMESTAMPTZ,
    daily_points_earned INT NOT NULL DEFAULT 0 CHECK (daily_points_earned >= 0),
    daily_point_cap INT NOT NULL DEFAULT 1000,
    daily_cap_reset_at TIMESTAMPTZ NOT NULL DEFAULT (CURRENT_DATE + INTERVAL '1 day'),
    total_wins INT NOT NULL DEFAULT 0,
    total_matches INT NOT NULL DEFAULT 0,
    current_streak_days INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Index for phone auth & brand filtering
CREATE INDEX idx_users_phone ON users(phone_number);
CREATE INDEX idx_users_supported_brand ON users(supported_brand_id);
```

---

### 2.2 `brands` (Participating Commercial Sponsors)
Stores financial spend and accumulated player points used for the 50/50 formula.

```sql
CREATE TABLE brands (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) UNIQUE NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    tagline VARCHAR(255) NOT NULL,
    category VARCHAR(50) NOT NULL,
    logo_url TEXT NOT NULL,
    banner_url TEXT,
    primary_color VARCHAR(10) NOT NULL DEFAULT '#111827',
    total_paid_amount NUMERIC(12, 2) NOT NULL DEFAULT 0.00 CHECK (total_paid_amount >= 0),
    player_points INT NOT NULL DEFAULT 0 CHECK (player_points >= 0),
    weekly_player_points INT NOT NULL DEFAULT 0 CHECK (weekly_player_points >= 0),
    website_url TEXT NOT NULL,
    supporters_count INT NOT NULL DEFAULT 0,
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Index for sorting leaderboard
CREATE INDEX idx_brands_total_paid ON brands(total_paid_amount DESC);
CREATE INDEX idx_brands_player_points ON brands(player_points DESC);
```

---

### 2.3 `brand_payments` (Razorpay / Stripe Outbid Transactions)
Auditable financial ledger of all brand boost transactions.

```sql
CREATE TABLE brand_payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE RESTRICT,
    amount NUMERIC(12, 2) NOT NULL CHECK (amount > 0),
    currency VARCHAR(5) NOT NULL DEFAULT 'INR',
    gateway VARCHAR(20) NOT NULL CHECK (gateway IN ('razorpay', 'stripe')),
    gateway_order_id VARCHAR(100) NOT NULL,
    gateway_payment_id VARCHAR(100),
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'captured', 'failed', 'refunded')),
    invoice_number VARCHAR(50) UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_brand_payments_brand ON brand_payments(brand_id);
CREATE INDEX idx_brand_payments_gateway_order ON brand_payments(gateway_order_id);
```

---

### 2.4 `products` (Trending Products from Top Brand)
Outbound e-commerce items featured in the app.

```sql
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    original_price NUMERIC(10, 2) NOT NULL,
    discount_price NUMERIC(10, 2) NOT NULL CHECK (discount_price <= original_price),
    store_url TEXT NOT NULL,
    image_url TEXT NOT NULL,
    is_trending BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_products_brand ON products(brand_id);
```

---

### 2.5 `rewards` (Coupon Inventory & Physical Pools)
Defines vouchers and prizes allocated by brands.

```sql
CREATE TABLE rewards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    reward_type VARCHAR(20) NOT NULL CHECK (reward_type IN ('voucher', 'physical_product')),
    promo_code VARCHAR(50),
    discount_value VARCHAR(50),
    total_stock INT NOT NULL DEFAULT 100,
    remaining_stock INT NOT NULL DEFAULT 100 CHECK (remaining_stock >= 0),
    valid_until TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_rewards_brand ON rewards(brand_id);
```

---

### 2.6 `reward_wallet` (Player Inventory)
Stores prizes unlocked by individual players.

```sql
CREATE TABLE reward_wallet (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    reward_id UUID NOT NULL REFERENCES rewards(id) ON DELETE RESTRICT,
    promo_code VARCHAR(50),
    is_claimed BOOLEAN NOT NULL DEFAULT FALSE,
    claimed_at TIMESTAMPTZ,
    shipping_address TEXT,
    tracking_number VARCHAR(100),
    delivery_status VARCHAR(50) DEFAULT 'unclaimed',
    expires_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_wallet_user ON reward_wallet(user_id);
CREATE INDEX idx_wallet_reward ON reward_wallet(reward_id);
```

---

### 2.7 `matches` (1v1 Gameplay Records)
Logs gameplay sessions, telemetry, and points awarded.

```sql
CREATE TABLE matches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    game_type VARCHAR(30) NOT NULL CHECK (game_type IN ('quiz', 'reaction_duel')),
    player_id UUID NOT NULL REFERENCES users(id),
    player_brand_id UUID NOT NULL REFERENCES brands(id),
    opponent_id UUID REFERENCES users(id), -- NULL if bot
    opponent_name VARCHAR(100) NOT NULL,
    opponent_brand_id UUID NOT NULL REFERENCES brands(id),
    is_bot_opponent BOOLEAN NOT NULL DEFAULT FALSE,
    player_score INT NOT NULL,
    opponent_score INT NOT NULL,
    is_player_winner BOOLEAN NOT NULL,
    player_points_awarded INT NOT NULL,
    brand_points_awarded INT NOT NULL,
    drop_reward_id UUID REFERENCES rewards(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_matches_player ON matches(player_id);
CREATE INDEX idx_matches_created_at ON matches(created_at DESC);
```

---

## 3. Row-Level Security (RLS) Policies

Postgres RLS guarantees that data access boundaries are enforced at the database layer:

```sql
-- 1. Enable RLS on user wallet
ALTER TABLE reward_wallet ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Players can only view their own rewards"
    ON reward_wallet FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Players can update their own shipping address"
    ON reward_wallet FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- 2. Brands and Products are publicly readable
ALTER TABLE brands ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view active brands" ON brands FOR SELECT USING (TRUE);

ALTER TABLE products ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view trending products" ON products FOR SELECT USING (TRUE);
```

---

## 4. Maintenance & Weekly Reset Routine

```sql
-- Weekly Sunday 23:59 UTC reset function for Player Points
CREATE OR REPLACE FUNCTION reset_weekly_player_points()
RETURNS void AS $$
BEGIN
    UPDATE brands SET weekly_player_points = 0;
END;
$$ LANGUAGE plpgsql;
```
