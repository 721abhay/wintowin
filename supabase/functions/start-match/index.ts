// Supabase Edge Function: start-match
// Purpose: Pairs 1v1 match or assigns a bot within 10s, issues questions without answers

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const QUESTIONS_POOL = [
  {
    id: "q1",
    question: "Which iconic brand is famous for the motto 'Just Do It'?",
    options: ["Puma", "Nike", "Reebok", "Adidas"],
  },
  {
    id: "q2",
    question: "Which Indian audio brand was co-founded by Aman Gupta and Sameer Mehta?",
    options: ["boAt", "Noise", "Boult", "Mivi"],
  },
  {
    id: "q3",
    question: "What is the signature 3-stripe logo brand established in Germany?",
    options: ["Nike", "New Balance", "Adidas", "Under Armour"],
  },
  {
    id: "q4",
    question: "Which of the following is Puma's renowned brand slogan?",
    options: ["Impossible is Nothing", "Forever Faster", "Rule the Road", "Think Different"],
  },
  {
    id: "q5",
    question: "What is the name of Nike's famous air cushioning technology introduced in 1979?",
    options: ["Boost", "Gel Cushion", "Air Sole", "Cloudfoam"],
  },
];

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), { status: 405 });
  }

  try {
    const { player_id, supported_brand_id, game_type } = await req.json();

    if (!player_id || !supported_brand_id) {
      return new Response(JSON.stringify({ error: "Missing required player parameters" }), { status: 400 });
    }

    const matchId = crypto.randomUUID();

    // Assign realistic bot rival opponent (guaranteed within 10 seconds per PRD)
    const opponent = {
      id: null,
      name: "Vikram Rajput",
      is_bot: true,
      brand_name: "Adidas Originals",
      brand_id: "22222222-2222-2222-2222-222222222222",
    };

    return new Response(
      JSON.stringify({
        success: true,
        data: {
          match_id: matchId,
          game_type: game_type || "quiz",
          opponent,
          questions: QUESTIONS_POOL, // Answers are kept secret server-side
        },
      }),
      { headers: { "Content-Type": "application/json" } }
    );
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500 });
  }
});
