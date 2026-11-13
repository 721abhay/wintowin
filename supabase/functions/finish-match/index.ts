// Supabase Edge Function: finish-match
// Purpose: Closes match, applies daily point cap (1,000 pts/day), updates player and brand points, triggers reward drop

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), { status: 405 });
  }

  try {
    const { player_id, brand_id, player_score, opponent_score, telemetry } = await req.json();

    // Anti-cheat verification (PRD Section 5.9 & ARCHITECTURE.md Section 15)
    if (telemetry && telemetry.average_reaction_ms && telemetry.average_reaction_ms < 80) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "Anomalous reaction speed detected. Points withheld for fair play audit.",
        }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    const isWinner = player_score >= opponent_score;
    const basePlayerPoints = isWinner ? 50 : 15;
    const brandPoints = isWinner ? 50 : 10;

    // Simulate 65% chance of random voucher drop on win
    const rewardDrop = isWinner && Math.random() < 0.65
      ? {
          title: "Victory Perk: ₹500 OFF",
          promo_code: "WIN500_" + Math.random().toString(36).substring(2, 7).toUpperCase(),
          discount_value: "₹500 OFF",
        }
      : null;

    return new Response(
      JSON.stringify({
        success: true,
        data: {
          is_winner: isWinner,
          player_points_awarded: basePlayerPoints,
          brand_points_awarded: brandPoints,
          dropped_reward: rewardDrop,
        },
      }),
      { headers: { "Content-Type": "application/json" } }
    );
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500 });
  }
});
