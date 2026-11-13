// Supabase Edge Function: submit-answer
// Purpose: Validates an answer against server-held key and returns correctness & score

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const ANSWER_KEYS: Record<string, number> = {
  q1: 1, // Nike
  q2: 0, // boAt
  q3: 2, // Adidas
  q4: 1, // Forever Faster
  q5: 2, // Air Sole
};

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), { status: 405 });
  }

  try {
    const { question_id, selected_index, time_left_seconds } = await req.json();

    const correctAnswer = ANSWER_KEYS[question_id];
    const isCorrect = selected_index === correctAnswer;

    // Speed bonus: +2 points per remaining second
    const pointsAwarded = isCorrect ? 20 + Math.max(0, (time_left_seconds || 0) * 2) : 0;

    return new Response(
      JSON.stringify({
        success: true,
        data: {
          is_correct: isCorrect,
          correct_index: correctAnswer,
          points_awarded: pointsAwarded,
        },
      }),
      { headers: { "Content-Type": "application/json" } }
    );
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500 });
  }
});
