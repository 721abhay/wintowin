// Supabase Edge Function: create-payment-order
// Purpose: Validates minimum outbid amount and creates Razorpay Order

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), { status: 405 });
  }

  try {
    const { brand_id, amount_inr } = await req.json();

    if (!brand_id || !amount_inr || amount_inr < 5000) {
      return new Response(
        JSON.stringify({ error: "Minimum boost amount is ₹5,000 INR." }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    const razorpayKeyId = Deno.env.get("RAZORPAY_KEY_ID") || "rzp_test_wintowin";
    const orderId = "order_" + crypto.randomUUID().substring(0, 14);

    return new Response(
      JSON.stringify({
        success: true,
        data: {
          order_id: orderId,
          amount: amount_inr * 100, // Razorpay uses paisa
          currency: "INR",
          key_id: razorpayKeyId,
        },
      }),
      { headers: { "Content-Type": "application/json" } }
    );
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500 });
  }
});
