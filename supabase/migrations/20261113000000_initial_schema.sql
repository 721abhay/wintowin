-- WinToWin Initial Database Schema
-- Matches DATABASE.md & ARCHITECTURE.md specifications

-- 1. EXTENSIONS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 2. USERS TABLE
CREATE TABLE IF NOT EXISTS public.users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'player' CHECK (role IN ('player', 'brand_manager', 'admin')),
    supported_brand_id UUID, -- Foreign key added after brands table creation
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

-- 3. BRANDS TABLE
CREATE TABLE IF NOT EXISTS public.brands (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) UNIQUE NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    tagline VARCHAR(255) NOT NULL,
    category VARCHAR(50) NOT NULL,
    logo_url TEXT NOT NULL,
    banner_url TEXT,
    primary_color VARCHAR(10) NOT NULL DEFAULT '#14161C',
    total_paid_amount NUMERIC(12, 2) NOT NULL DEFAULT 0.00 CHECK (total_paid_amount >= 0),
    player_points INT NOT NULL DEFAULT 0 CHECK (player_points >= 0),
    weekly_player_points INT NOT NULL DEFAULT 0 CHECK (weekly_player_points >= 0),
    website_url TEXT NOT NULL,
    supporters_count INT NOT NULL DEFAULT 0,
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Add foreign key constraint to users table
ALTER TABLE public.users
    ADD CONSTRAINT fk_users_supported_brand
    FOREIGN KEY (supported_brand_id)
    REFERENCES public.brands(id)
    ON DELETE SET NULL;

-- 4. BRAND CACHED RANKS TABLE
CREATE TABLE IF NOT EXISTS public.brand_ranks (
    brand_id UUID PRIMARY KEY REFERENCES public.brands(id) ON DELETE CASCADE,
    rank INT NOT NULL,
    money_score NUMERIC(5, 2) NOT NULL,
    player_score NUMERIC(5, 2) NOT NULL,
    combined_score NUMERIC(5, 2) NOT NULL,
    amount_to_overtake_next NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 5. BRAND PAYMENTS TABLE (Financial Ledger)
CREATE TABLE IF NOT EXISTS public.brand_payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    brand_id UUID NOT NULL REFERENCES public.brands(id) ON DELETE RESTRICT,
    amount NUMERIC(12, 2) NOT NULL CHECK (amount > 0),
    currency VARCHAR(5) NOT NULL DEFAULT 'INR',
    gateway VARCHAR(20) NOT NULL DEFAULT 'razorpay' CHECK (gateway IN ('razorpay', 'stripe')),
    gateway_order_id VARCHAR(100) NOT NULL,
    gateway_payment_id VARCHAR(100) UNIQUE,
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'captured', 'failed', 'refunded')),
    invoice_number VARCHAR(50) UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 6. PRODUCTS TABLE (Direct brand links)
CREATE TABLE IF NOT EXISTS public.products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    brand_id UUID NOT NULL REFERENCES public.brands(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    original_price NUMERIC(10, 2) NOT NULL,
    discount_price NUMERIC(10, 2) NOT NULL CHECK (discount_price <= original_price),
    store_url TEXT NOT NULL,
    image_url TEXT NOT NULL,
    is_trending BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 7. REWARDS CATALOG TABLE
CREATE TABLE IF NOT EXISTS public.rewards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    brand_id UUID NOT NULL REFERENCES public.brands(id) ON DELETE CASCADE,
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

-- 8. REWARD WALLET TABLE (Player's won rewards)
CREATE TABLE IF NOT EXISTS public.reward_wallet (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    reward_id UUID NOT NULL REFERENCES public.rewards(id) ON DELETE RESTRICT,
    promo_code VARCHAR(50),
    is_claimed BOOLEAN NOT NULL DEFAULT FALSE,
    claimed_at TIMESTAMPTZ,
    shipping_address TEXT,
    tracking_number VARCHAR(100),
    delivery_status VARCHAR(50) DEFAULT 'unclaimed',
    expires_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 9. MATCHES TABLE (1v1 Gameplay Records)
CREATE TABLE IF NOT EXISTS public.matches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    game_type VARCHAR(30) NOT NULL CHECK (game_type IN ('quiz', 'reaction_duel')),
    player_id UUID NOT NULL REFERENCES public.users(id),
    player_brand_id UUID NOT NULL REFERENCES public.brands(id),
    opponent_id UUID REFERENCES public.users(id), -- NULL if bot
    opponent_name VARCHAR(100) NOT NULL,
    opponent_brand_id UUID NOT NULL REFERENCES public.brands(id),
    is_bot_opponent BOOLEAN NOT NULL DEFAULT FALSE,
    player_score INT NOT NULL,
    opponent_score INT NOT NULL,
    is_player_winner BOOLEAN NOT NULL,
    player_points_awarded INT NOT NULL,
    brand_points_awarded INT NOT NULL,
    drop_reward_id UUID REFERENCES public.rewards(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 10. PRODUCT CLICK TRACKING TABLE
CREATE TABLE IF NOT EXISTS public.product_clicks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
    brand_id UUID NOT NULL REFERENCES public.brands(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.users(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 11. INDEXES FOR HIGH-TRAFFIC QUERY PATHS
CREATE INDEX IF NOT EXISTS idx_users_phone ON public.users(phone_number);
CREATE INDEX IF NOT EXISTS idx_users_supported_brand ON public.users(supported_brand_id);
CREATE INDEX IF NOT EXISTS idx_brands_total_paid ON public.brands(total_paid_amount DESC);
CREATE INDEX IF NOT EXISTS idx_brands_player_points ON public.brands(player_points DESC);
CREATE INDEX IF NOT EXISTS idx_brand_ranks_rank ON public.brand_ranks(rank ASC);
CREATE INDEX IF NOT EXISTS idx_brand_payments_brand ON public.brand_payments(brand_id);
CREATE INDEX IF NOT EXISTS idx_brand_payments_gateway_order ON public.brand_payments(gateway_order_id);
CREATE INDEX IF NOT EXISTS idx_products_brand ON public.products(brand_id);
CREATE INDEX IF NOT EXISTS idx_rewards_brand ON public.rewards(brand_id);
CREATE INDEX IF NOT EXISTS idx_wallet_user ON public.reward_wallet(user_id);
CREATE INDEX IF NOT EXISTS idx_matches_player ON public.matches(player_id);
CREATE INDEX IF NOT EXISTS idx_matches_created_at ON public.matches(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_clicks_product ON public.product_clicks(product_id);

-- 12. ROW-LEVEL SECURITY (RLS) POLICIES
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.brands ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.brand_ranks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.rewards ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reward_wallet ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.matches ENABLE ROW LEVEL SECURITY;

-- Public read policies
CREATE POLICY "Public read brands" ON public.brands FOR SELECT USING (TRUE);
CREATE POLICY "Public read brand ranks" ON public.brand_ranks FOR SELECT USING (TRUE);
CREATE POLICY "Public read products" ON public.products FOR SELECT USING (TRUE);
CREATE POLICY "Public read active rewards" ON public.rewards FOR SELECT USING (valid_until > NOW());

-- User isolated read & write policies
CREATE POLICY "Users read own profile" ON public.users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users read own wallet" ON public.reward_wallet FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users update own shipping info" ON public.reward_wallet FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users read own matches" ON public.matches FOR SELECT USING (auth.uid() = player_id);

-- 13. RECALCULATE RANKS FUNCTION (The 50/50 Formula Implementation)
CREATE OR REPLACE FUNCTION public.recalculate_brand_ranks()
RETURNS void AS $$
DECLARE
    v_max_paid NUMERIC;
    v_max_points INT;
BEGIN
    -- Determine maximum values for normalization
    SELECT COALESCE(MAX(total_paid_amount), 1.0) INTO v_max_paid FROM public.brands;
    SELECT COALESCE(MAX(player_points), 1) INTO v_max_points FROM public.brands;

    -- Avoid division by zero
    IF v_max_paid <= 0 THEN v_max_paid := 1.0; END IF;
    IF v_max_points <= 0 THEN v_max_points := 1; END IF;

    -- Upsert recalculated ranks
    WITH calculated AS (
        SELECT
            b.id AS brand_id,
            ROUND((b.total_paid_amount / v_max_paid) * 100, 2) AS m_score,
            ROUND((b.player_points::numeric / v_max_points) * 100, 2) AS p_score,
            ROUND((0.5 * (b.total_paid_amount / v_max_paid) * 100) + (0.5 * (b.player_points::numeric / v_max_points) * 100), 2) AS c_score,
            b.total_paid_amount
        FROM public.brands b
    ),
    ranked AS (
        SELECT
            c.brand_id,
            ROW_NUMBER() OVER (ORDER BY c.c_score DESC, c.total_paid_amount DESC) AS r_rank,
            c.m_score,
            c.p_score,
            c.c_score,
            c.total_paid_amount
        FROM calculated c
    ),
    with_overtake AS (
        SELECT
            r.brand_id,
            r.r_rank::int AS rank,
            r.m_score AS money_score,
            r.p_score AS player_score,
            r.c_score AS combined_score,
            COALESCE(
                GREATEST(0, (LAG(r.total_paid_amount) OVER (ORDER BY r.r_rank) - r.total_paid_amount) + 5000),
                0.00
            ) AS amount_to_overtake_next
        FROM ranked r
    )
    INSERT INTO public.brand_ranks (brand_id, rank, money_score, player_score, combined_score, amount_to_overtake_next, updated_at)
    SELECT brand_id, rank, money_score, player_score, combined_score, amount_to_overtake_next, NOW()
    FROM with_overtake
    ON CONFLICT (brand_id) DO UPDATE SET
        rank = EXCLUDED.rank,
        money_score = EXCLUDED.money_score,
        player_score = EXCLUDED.player_score,
        combined_score = EXCLUDED.combined_score,
        amount_to_overtake_next = EXCLUDED.amount_to_overtake_next,
        updated_at = NOW();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
