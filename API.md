# WinToWin — Backend API Specification (API.md)

**Document Version:** 1.0  
**Protocol:** HTTPS RESTful + WSS (WebSockets)  
**Standard Response Envelope:** JSON (`{ success: boolean, data?: T, error?: ErrorObject }`)

---

## 1. Authentication & Security Headers

All protected endpoints require a Bearer JWT passed in the HTTP Authorization header:
```http
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json
X-Client-Version: 1.0.0
```

### Common Error Codes
- `400 Bad Request`: Validation failure or invalid parameters.
- `401 Unauthorized`: Missing or expired JWT token.
- `403 Forbidden`: Insufficient role or cooldown active.
- `429 Too Many Requests`: Rate limit reached (Default: 60 req/min).
- `500 Internal Error`: Server execution fault.

---

## 2. Authentication Endpoints

### 2.1 Send Phone OTP
- **POST** `/api/v1/auth/otp/send`
- **Body**:
  ```json
  {
    "phone_number": "+919876543210"
  }
  ```
- **Response (200 OK)**:
  ```json
  {
    "success": true,
    "data": {
      "session_id": "sess_9823198273",
      "expires_in_seconds": 120
    }
  }
  ```

### 2.2 Verify Phone OTP
- **POST** `/api/v1/auth/otp/verify`
- **Body**:
  ```json
  {
    "session_id": "sess_9823198273",
    "otp_code": "482910"
  }
  ```
- **Response (200 OK)**:
  ```json
  {
    "success": true,
    "data": {
      "access_token": "eyJhbGciOi...",
      "user": {
        "id": "u_8392",
        "phone_number": "+919876543210",
        "supported_brand_id": "brand_nike",
        "daily_points_earned": 350
      }
    }
  }
  ```

---

## 3. Brand & Leaderboard Endpoints

### 3.1 Get Live Brand Leaderboard
- **GET** `/api/v1/brands/leaderboard`
- **Response (200 OK)**:
  ```json
  {
    "success": true,
    "data": {
      "max_paid_amount": 520000.0,
      "max_player_points": 48200,
      "brands": [
        {
          "rank": 1,
          "id": "brand_nike",
          "name": "Nike Sportswear",
          "category": "Sportswear",
          "total_paid_amount": 520000.0,
          "player_points": 48200,
          "money_score": 100.0,
          "player_score": 100.0,
          "combined_score": 100.0,
          "supporters_count": 14200,
          "amount_to_overtake_next": 0.0
        },
        {
          "rank": 2,
          "id": "brand_adidas",
          "name": "Adidas Originals",
          "category": "Sportswear",
          "total_paid_amount": 495000.0,
          "player_points": 46100,
          "money_score": 95.19,
          "player_score": 95.64,
          "combined_score": 95.41,
          "supporters_count": 12850,
          "amount_to_overtake_next": 30000.0
        }
      ]
    }
  }
  ```

### 3.2 Switch Supported Brand (7-Day Cooldown)
- **POST** `/api/v1/players/switch-brand`
- **Headers**: `Authorization: Bearer <JWT>`
- **Body**:
  ```json
  {
    "new_brand_id": "brand_adidas"
  }
  ```
- **Response (200 OK)**:
  ```json
  {
    "success": true,
    "data": {
      "message": "Brand switched successfully. Fighting for Adidas Originals.",
      "cooldown_until": "2026-11-20T13:30:00Z"
    }
  }
  ```
- **Error (403 Forbidden - Cooldown Active)**:
  ```json
  {
    "success": false,
    "error": {
      "code": "COOLDOWN_ACTIVE",
      "message": "You can only switch brands once every 7 days. Next switch available on 2026-11-18."
    }
  }
  ```

---

## 4. Game Arena & Matchmaking Endpoints

### 4.1 Queue for Match
- **POST** `/api/v1/matches/queue`
- **Headers**: `Authorization: Bearer <JWT>`
- **Body**:
  ```json
  {
    "game_type": "quiz",
    "supported_brand_id": "brand_nike"
  }
  ```
- **Response (200 OK)**:
  ```json
  {
    "success": true,
    "data": {
      "match_id": "match_829103",
      "status": "matched",
      "opponent": {
        "name": "Vikram Rajput",
        "is_bot": true,
        "brand_name": "Adidas Originals"
      }
    }
  }
  ```

### 4.2 Submit Match Result (Verification & Point Disbursement)
- **POST** `/api/v1/matches/submit-result`
- **Headers**: `Authorization: Bearer <JWT>`
- **Body**:
  ```json
  {
    "match_id": "match_829103",
    "player_score": 90,
    "opponent_score": 60,
    "telemetry": {
      "average_reaction_ms": 234,
      "tap_coordinates": [{"x": 182, "y": 420, "time_ms": 218}]
    }
  }
  ```
- **Response (200 OK)**:
  ```json
  {
    "success": true,
    "data": {
      "is_winner": true,
      "player_points_awarded": 50,
      "brand_points_awarded": 50,
      "daily_points_status": {
        "earned_today": 400,
        "remaining_cap": 600
      },
      "dropped_reward": {
        "id": "rew_9123",
        "title": "₹500 OFF on Nike Sportswear",
        "promo_code": "VICTORY500",
        "expiry_date": "2026-11-27T00:00:00Z"
      }
    }
  }
  ```

---

## 5. Rewards & Wallet Endpoints

### 5.1 Get Player Rewards
- **GET** `/api/v1/rewards/my-wallet`
- **Headers**: `Authorization: Bearer <JWT>`
- **Response (200 OK)**:
  ```json
  {
    "success": true,
    "data": {
      "rewards": [
        {
          "id": "rew_1",
          "brand_name": "Nike",
          "title": "Flat ₹1,500 OFF on Orders Above ₹5,000",
          "type": "voucher",
          "promo_code": "NIKEWIN1500",
          "expiry_date": "2026-11-25T12:00:00Z"
        },
        {
          "id": "rew_3",
          "brand_name": "Nike",
          "title": "Nike Club Fleece Hoodie",
          "type": "physical_product",
          "is_claimed": true,
          "tracking_number": "DELHIVERY_NK98231",
          "delivery_status": "Out for Delivery"
        }
      ]
    }
  }
  ```

### 5.2 Claim Physical Product Reward
- **POST** `/api/v1/rewards/:id/claim-physical`
- **Headers**: `Authorization: Bearer <JWT>`
- **Body**:
  ```json
  {
    "shipping_address": "Flat 402, Green Valley Apts, Indiranagar, Bengaluru, 560038",
    "contact_phone": "+919876543210"
  }
  ```
- **Response (200 OK)**:
  ```json
  {
    "success": true,
    "data": {
      "tracking_number": "TRK8912301",
      "delivery_status": "Processing with Brand",
      "message": "Shipping details securely forwarded to the brand."
    }
  }
  ```

---

## 6. Payments & Webhooks (Brands Only)

### 6.1 Razorpay Webhook Verification
- **POST** `/api/v1/webhooks/razorpay`
- **Headers**: `X-Razorpay-Signature: <HMAC_SHA256_HEX>`
- **Security Check**:
  ```typescript
  const crypto = require('crypto');
  const expectedSignature = crypto
    .createHmac('sha256', process.env.RAZORPAY_WEBHOOK_SECRET)
    .update(rawBody)
    .digest('hex');

  if (expectedSignature !== req.headers['x-razorpay-signature']) {
    return res.status(400).send('Invalid signature');
  }
  ```
- **Action**: On `payment.captured`, automatically increments `brands.total_paid_amount` and recalculates 50/50 leaderboard standings.
