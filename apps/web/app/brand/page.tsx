"use client";

import { useState } from "react";
import Link from "next/link";
import { Trophy, TrendingUp, Users, ArrowUpRight, Zap, Eye, ShoppingCart } from "lucide-react";
import { formatINR, formatNumber } from "@/lib/utils";

export default function BrandDashboardPage() {
  const [totalPaid, setTotalPaid] = useState(520000);
  const [playerPoints, setPlayerPoints] = useState(48200);
  const [supportersCount] = useState(14200);
  const [productClicks] = useState(3840);

  // Normalization limits from current leaderboard
  const maxPaid = 520000;
  const maxPoints = 48200;

  const moneyScore = (totalPaid / maxPaid) * 100;
  const playScore = (playerPoints / maxPoints) * 100;
  const combinedScore = (0.5 * moneyScore) + (0.5 * playScore);

  // Rival buffer: Adidas is at ₹4,95,000 and 46,100 pts (Score: 94.2)
  const rivalScore = 94.2;
  const leadBuffer = combinedScore - rivalScore;

  return (
    <div className="space-y-8">
      {/* 4dp Brand Stripe & Header Card */}
      <div className="relative overflow-hidden rounded-xl border border-line bg-surface p-6 shadow-sm">
        {/* Strict 4dp Brand Stripe */}
        <div className="absolute top-0 left-0 right-0 h-1 bg-[#111827]" />

        <div className="flex flex-col md:flex-row md:items-center justify-between gap-6 pt-2">
          <div className="flex items-center gap-4">
            <div className="flex h-16 w-16 items-center justify-center rounded-xl bg-win-gold text-ink font-mono font-black text-2xl shadow-sm">
              #1
            </div>
            <div>
              <div className="flex items-center gap-2">
                <h2 className="text-2xl font-black text-ink tracking-tight">Nike Sportswear</h2>
                <span className="rounded bg-win-gold-light border border-win-gold/40 px-2 py-0.5 text-xs font-bold text-ink">
                  Currently #1 On Leaderboard
                </span>
              </div>
              <p className="text-sm text-ink-muted mt-0.5">
                Your products are currently featured on the mobile app home screen.
              </p>
            </div>
          </div>

          <div className="flex items-center gap-3">
            <Link
              href="/brand/boost"
              className="inline-flex items-center gap-2 rounded-lg bg-win-gold px-4 py-2.5 text-sm font-black text-ink shadow-sm hover:opacity-95 transition"
            >
              <Zap className="h-4 w-4" /> Secure Lead (+₹25,000)
            </Link>
          </div>
        </div>
      </div>

      {/* 50/50 Formula Score Breakdown Card */}
      <div className="rounded-xl border border-line bg-surface p-6 shadow-sm">
        <div className="flex flex-col md:flex-row md:items-center justify-between mb-4 gap-2">
          <div>
            <h3 className="text-base font-black text-ink tracking-tight flex items-center gap-2">
              <Trophy className="h-5 w-5 text-win-gold" />
              Formula Breakdown: Money (50%) + Gameplay (50%)
            </h3>
            <p className="text-xs text-ink-muted mt-0.5">
              Rank Score = (0.5 × Normalized Spend) + (0.5 × Supporter Points). Weekly reset every Sunday.
            </p>
          </div>
          <div className="font-mono text-2xl font-black text-primary">
            {combinedScore.toFixed(1)} <span className="text-xs text-ink-muted font-normal">/ 100</span>
          </div>
        </div>

        {/* Visual Score Bar */}
        <div className="space-y-2">
          <div className="h-4 w-full rounded-full bg-canvas overflow-hidden flex border border-line">
            <div
              className="bg-ink transition-all duration-500"
              style={{ width: `${(moneyScore * 0.5).toFixed(1)}%` }}
              title={`Money Score: ${(moneyScore * 0.5).toFixed(1)} pts`}
            />
            <div
              className="bg-primary transition-all duration-500"
              style={{ width: `${(playScore * 0.5).toFixed(1)}%` }}
              title={`Player Score: ${(playScore * 0.5).toFixed(1)} pts`}
            />
          </div>

          <div className="flex items-center justify-between text-xs font-semibold text-ink-muted">
            <span className="flex items-center gap-1.5">
              <span className="h-2.5 w-2.5 rounded-full bg-ink" />
              Money Component: {(moneyScore * 0.5).toFixed(1)} pts ({formatINR(totalPaid)})
            </span>
            <span className="flex items-center gap-1.5">
              <span className="h-2.5 w-2.5 rounded-full bg-primary" />
              Supporter Gameplay: {(playScore * 0.5).toFixed(1)} pts ({formatNumber(playerPoints)} pts)
            </span>
          </div>
        </div>

        <div className="mt-4 rounded-lg bg-canvas p-3 border border-line text-xs text-ink flex items-center justify-between">
          <span>
            Lead over #2 (<strong>Adidas Originals</strong>): <strong>+{leadBuffer.toFixed(1)} pts</strong>
          </span>
          <span className="text-ink-muted">
            Minimum outbid threshold: ₹10,000
          </span>
        </div>
      </div>

      {/* Metric Cards Grid */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div className="rounded-xl border border-line bg-surface p-5">
          <div className="flex items-center justify-between text-ink-muted text-xs font-bold uppercase tracking-wider mb-2">
            <span>Total Invested</span>
            <TrendingUp className="h-4 w-4 text-primary" />
          </div>
          <div className="font-mono text-2xl font-black text-ink">{formatINR(totalPaid)}</div>
          <div className="text-[11px] text-ink-muted mt-1 font-medium">Rank #1 by Spend in Category</div>
        </div>

        <div className="rounded-xl border border-line bg-surface p-5">
          <div className="flex items-center justify-between text-ink-muted text-xs font-bold uppercase tracking-wider mb-2">
            <span>Active Supporters</span>
            <Users className="h-4 w-4 text-primary" />
          </div>
          <div className="font-mono text-2xl font-black text-ink">{formatNumber(supportersCount)}</div>
          <div className="text-[11px] text-ink-muted mt-1 font-medium">+1,420 fans joined this week</div>
        </div>

        <div className="rounded-xl border border-line bg-surface p-5">
          <div className="flex items-center justify-between text-ink-muted text-xs font-bold uppercase tracking-wider mb-2">
            <span>Supporter Points</span>
            <Trophy className="h-4 w-4 text-win-gold" />
          </div>
          <div className="font-mono text-2xl font-black text-ink">{formatNumber(playerPoints)}</div>
          <div className="text-[11px] text-ink-muted mt-1 font-medium">From 2,840 competitive duels</div>
        </div>

        <div className="rounded-xl border border-line bg-surface p-5">
          <div className="flex items-center justify-between text-ink-muted text-xs font-bold uppercase tracking-wider mb-2">
            <span>Product Store Clicks</span>
            <Eye className="h-4 w-4 text-primary" />
          </div>
          <div className="font-mono text-2xl font-black text-ink">{formatNumber(productClicks)}</div>
          <div className="text-[11px] text-primary font-bold mt-1">100% Outbound Direct Traffic</div>
        </div>
      </div>

      {/* Featured Products Table */}
      <div className="rounded-xl border border-line bg-surface p-6 shadow-sm">
        <div className="flex items-center justify-between mb-4">
          <div>
            <h3 className="text-base font-black text-ink tracking-tight flex items-center gap-2">
              <ShoppingCart className="h-5 w-5 text-primary" />
              Active Trending Products on App Home
            </h3>
            <p className="text-xs text-ink-muted mt-0.5">
              When ranked #1, these products receive prime placement on thousands of mobile player devices.
            </p>
          </div>
          <Link
            href="/brand/products"
            className="text-xs font-bold text-primary hover:underline inline-flex items-center gap-1"
          >
            Manage Products <ArrowUpRight className="h-3.5 w-3.5" />
          </Link>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs">
            <thead>
              <tr className="border-b border-line bg-canvas/60 text-ink-muted font-bold uppercase tracking-wider">
                <th className="py-2.5 px-4">Product</th>
                <th className="py-2.5 px-4">Retail Price</th>
                <th className="py-2.5 px-4">Clicks (7 Days)</th>
                <th className="py-2.5 px-4">Status</th>
                <th className="py-2.5 px-4 text-right">Destination</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-line font-medium text-ink">
              <tr>
                <td className="py-3 px-4 font-bold">Air Zoom Pegasus 40 Running Shoes</td>
                <td className="py-3 px-4 font-mono font-bold">{formatINR(7995)}</td>
                <td className="py-3 px-4 font-mono">1,824</td>
                <td className="py-3 px-4">
                  <span className="rounded bg-primary-light text-primary px-2 py-0.5 font-bold">
                    Featured (#1 Spot)
                  </span>
                </td>
                <td className="py-3 px-4 text-right font-mono text-ink-muted">nike.com</td>
              </tr>
              <tr>
                <td className="py-3 px-4 font-bold">Dri-FIT Academy Pro Football Tracksuit</td>
                <td className="py-3 px-4 font-mono font-bold">{formatINR(3995)}</td>
                <td className="py-3 px-4 font-mono">1,142</td>
                <td className="py-3 px-4">
                  <span className="rounded bg-primary-light text-primary px-2 py-0.5 font-bold">
                    Featured
                  </span>
                </td>
                <td className="py-3 px-4 text-right font-mono text-ink-muted">nike.com</td>
              </tr>
              <tr>
                <td className="py-3 px-4 font-bold">Air Max 270 Lifestyle Sneakers</td>
                <td className="py-3 px-4 font-mono font-bold">{formatINR(9995)}</td>
                <td className="py-3 px-4 font-mono">874</td>
                <td className="py-3 px-4">
                  <span className="rounded bg-primary-light text-primary px-2 py-0.5 font-bold">
                    Featured
                  </span>
                </td>
                <td className="py-3 px-4 text-right font-mono text-ink-muted">nike.com</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
