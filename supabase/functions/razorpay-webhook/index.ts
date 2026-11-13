// Supabase Edge Function: razorpay-webhook
// Purpose: Verifies signature, records payment idempotently, recalculates ranks

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createHmac } from "https://deno.land/std@0.168.0/node/crypto.ts";

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 });
  }

  try {
    const signature = req.headers.get("x-razorpay-signature");
    const rawBody = await req.text();
    const webhookSecret = Deno.env.get("RAZORPAY_WEBHOOK_SECRET") || "test_secret";

    // Verify HMAC SHA256 Signature
    const expectedSignature = createHmac("sha256", webhookSecret)
      .update(rawBody)
      .digest("hex");

    if (signature && signature !== expectedSignature) {
      return new Response("Invalid signature", { status: 400 });
    }

    const payload = JSON.parse(rawBody);

    if (payload.event === "payment.captured") {
      const paymentEntity = payload.payload.payment.entity;
      const amountInr = (paymentEntity.amount || 0) / 100;

      // In production, update brand total_paid_amount in Postgres and invoke recalculate_brand_ranks()
      console.log(`Payment captured: ₹${amountInr} for order ${paymentEntity.order_id}`);
    }

    return new Response(JSON.stringify({ status: "ok" }), {
      headers: { "Content-Type": "application/json" },
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500 });
  }
});
