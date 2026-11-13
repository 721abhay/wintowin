// Supabase Edge Function: track-click
// Purpose: Records click for brand analytics and redirects to brand store

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

serve(async (req) => {
  const url = new URL(req.url);
  const productId = url.searchParams.get("product_id");
  const targetUrl = url.searchParams.get("target") || "https://wintowin.app";

  try {
    if (productId) {
      console.log(`Outbound click tracked for product: ${productId}`);
    }

    return Response.redirect(targetUrl, 302);
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500 });
  }
});
