-- WinToWin Initial Seed Data for Development & Testing

-- Insert initial verified brands
INSERT INTO public.brands (id, name, slug, tagline, category, logo_url, primary_color, total_paid_amount, player_points, website_url, supporters_count, is_verified)
VALUES
    ('11111111-1111-1111-1111-111111111111', 'Nike Sportswear', 'nike', 'Just Do It. Premium athletic performance gear.', 'Sportswear & Footwear', 'https://assets.wintowin.app/brands/nike.png', '#14161C', 520000.00, 48200, 'https://www.nike.com', 14200, TRUE),
    ('22222222-2222-2222-2222-222222222222', 'Adidas Originals', 'adidas', 'Impossible Is Nothing. Iconic streetwear & sport.', 'Sportswear & Footwear', 'https://assets.wintowin.app/brands/adidas.png', '#0369A1', 495000.00, 46100, 'https://www.adidas.com', 12850, TRUE),
    ('33333333-3333-3333-3333-333333333333', 'boAt Lifestyle', 'boat', 'Plug Into Nirvana. India''s audio giant.', 'Consumer Electronics', 'https://assets.wintowin.app/brands/boat.png', '#DC2626', 410000.00, 39500, 'https://www.boat-lifestyle.com', 10920, TRUE),
    ('44444444-4444-4444-4444-444444444444', 'Puma Velocity', 'puma', 'Forever Faster. Speed and urban agility.', 'Sportswear', 'https://assets.wintowin.app/brands/puma.png', '#D97706', 360000.00, 33400, 'https://in.puma.com', 8740, TRUE),
    ('55555555-5555-5555-5555-555555555555', 'Noise Wearables', 'noise', 'Listen to the Noise Within. Smart fitness tech.', 'Wearables & Audio', 'https://assets.wintowin.app/brands/noise.png', '#7C3AED', 310000.00, 29800, 'https://www.gonoise.com', 7600, TRUE)
ON CONFLICT (id) DO NOTHING;

-- Trigger rank calculation
SELECT public.recalculate_brand_ranks();

-- Insert initial trending products from #1 brand (Nike)
INSERT INTO public.products (id, brand_id, title, description, original_price, discount_price, store_url, image_url, is_trending)
VALUES
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', 'Air Zoom Pegasus 40 Running Shoes', 'Responsive cushioning for road runners with engineered mesh upper.', 11495.00, 7995.00, 'https://www.nike.com', 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&auto=format&fit=crop&q=80', TRUE),
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '11111111-1111-1111-1111-111111111111', 'Dri-FIT Academy Pro Tracksuit', 'Sweat-wicking performance fabric with zippered ankle hems.', 5995.00, 3995.00, 'https://www.nike.com', 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=600&auto=format&fit=crop&q=80', TRUE),
    ('cccccccc-cccc-cccc-cccc-cccccccccccc', '11111111-1111-1111-1111-111111111111', 'Air Max 270 Lifestyle Sneakers', 'Legendary Max Air 270 unit delivers all-day supreme comfort.', 13995.00, 9995.00, 'https://www.nike.com', 'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=600&auto=format&fit=crop&q=80', TRUE)
ON CONFLICT (id) DO NOTHING;

-- Insert initial reward vouchers
INSERT INTO public.rewards (id, brand_id, title, description, reward_type, promo_code, discount_value, total_stock, remaining_stock, valid_until)
VALUES
    ('dddddddd-dddd-dddd-dddd-dddddddddddd', '11111111-1111-1111-1111-111111111111', 'Flat ₹1,500 OFF on Orders Above ₹5,000', 'Valid across all footwear and apparel on the official Nike site.', 'voucher', 'NIKEWIN1500', '₹1,500 OFF', 500, 480, NOW() + INTERVAL '30 days'),
    ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', '33333333-3333-3333-3333-333333333333', 'Flat 25% Instant Discount', 'Unlock 25% off on all TWS Earbuds & Bluetooth speakers.', 'voucher', 'BOATPLAY25', '25% OFF', 1000, 940, NOW() + INTERVAL '20 days'),
    ('ffffffff-ffff-ffff-ffff-ffffffffffff', '11111111-1111-1111-1111-111111111111', 'Nike Club Fleece Pullover Hoodie', 'Physical prize won in Weekend Tournament! Shipped by Nike.', 'physical_product', NULL, 'Free Product', 25, 22, NOW() + INTERVAL '45 days')
ON CONFLICT (id) DO NOTHING;
