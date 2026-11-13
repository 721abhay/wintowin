import Link from "next/link";
import { Trophy, ShieldCheck, ArrowRight, Zap, Target, Flame } from "lucide-react";
import { formatINR } from "@/lib/utils";

export default function Home() {
  const sampleRanks = [
    { rank: 1, name: "Nike Sportswear", category: "Footwear & Athletic", paid: 520000, points: 48200, score: 98.4, color: "#111827" },
    { rank: 2, name: "Adidas Originals", category: "Footwear & Streetwear", paid: 495000, points: 46100, score: 94.2, color: "#0369A1" },
    { rank: 3, name: "boAt Lifestyle", category: "Consumer Electronics", paid: 410000, points: 39500, score: 81.6, color: "#DC2626" },
    { rank: 4, name: "Puma Velocity", category: "Sportswear", paid: 360000, points: 33400, score: 71.8, color: "#D97706" },
    { rank: 5, name: "Noise Wearables", category: "Smart Tech & Audio", paid: 310000, points: 29800, score: 62.5, color: "#7C3AED" },
  ];

  return (
    <div className="flex min-h-screen flex-col">
      {/* Sports Navigation Bar */}
      <header className="border-b border-line bg-surface sticky top-0 z-50">
        <div className="mx-auto flex max-w-7xl items-center justify-between px-6 py-4">
          <div className="flex items-center gap-3">
            <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-ink text-white font-black text-xl tracking-tighter">
              W2W
            </div>
            <div>
              <span className="text-xl font-black tracking-tight text-ink">WinToWin</span>
              <span className="ml-2 text-xs font-semibold uppercase tracking-wider text-primary bg-primary-light px-2 py-0.5 rounded">
                Brand & Admin Portal
              </span>
            </div>
          </div>
          <div className="flex items-center gap-3">
            <Link
              href="/login"
              className="rounded-lg border border-line bg-surface px-4 py-2 text-sm font-semibold text-ink hover:bg-canvas transition"
            >
              Sign In
            </Link>
            <Link
              href="/brand"
              className="rounded-lg bg-primary px-4 py-2 text-sm font-semibold text-white hover:bg-primary-dark transition"
            >
              Brand Dashboard
            </Link>
          </div>
        </div>
      </header>

      {/* Hero Section */}
      <section className="border-b border-line bg-surface py-20 px-6">
        <div className="mx-auto max-w-5xl text-center">
          <div className="inline-flex items-center gap-2 rounded-full border border-line bg-canvas px-4 py-1.5 text-xs font-bold uppercase tracking-wider text-ink mb-6">
            <Flame className="h-4 w-4 text-win-gold" />
            Transparent 50/50 Brand Ranking Formula
          </div>
          <h1 className="text-4xl font-black tracking-tight sm:text-6xl text-ink">
            Brands compete for rank. <br />
            <span className="text-primary">Supporters play to push you #1.</span>
          </h1>
          <p className="mt-6 text-lg text-ink-muted max-w-3xl mx-auto leading-relaxed">
            WinToWin replaces passive ads with live gaming rivalry. Fans play 1v1 casual trivia and reaction duels for your brand, 
            earning genuine product vouchers. Brands outbid competitors to dominate the public scoreboard.
          </p>

          <div className="mt-10 flex flex-wrap items-center justify-center gap-4">
            <Link
              href="/register"
              className="inline-flex items-center gap-2 rounded-lg bg-primary px-6 py-3.5 text-base font-bold text-white shadow-sm hover:bg-primary-dark transition"
            >
              Register Your Brand <ArrowRight className="h-5 w-5" />
            </Link>
            <Link
              href="/brand"
              className="inline-flex items-center gap-2 rounded-lg border border-line bg-surface px-6 py-3.5 text-base font-bold text-ink hover:bg-canvas transition"
            >
              Explore Brand Dashboard
            </Link>
            <Link
              href="/admin"
              className="inline-flex items-center gap-2 rounded-lg border border-line bg-canvas px-4 py-3.5 text-sm font-semibold text-ink-muted hover:text-ink transition"
            >
              <ShieldCheck className="h-4 w-4" /> Admin Console
            </Link>
          </div>
        </div>
      </section>

      {/* Live Brand Scoreboard Preview */}
      <section className="py-16 px-6 mx-auto max-w-6xl w-full">
        <div className="flex flex-col md:flex-row md:items-end justify-between mb-8 gap-4">
          <div>
            <h2 className="text-2xl font-black text-ink tracking-tight flex items-center gap-2">
              <Trophy className="h-6 w-6 text-win-gold" /> Live Brand Scoreboard
            </h2>
            <p className="text-sm text-ink-muted mt-1">
              Score = (50% × Money Normalization) + (50% × Player Gameplay Normalization). Updates live via Supabase.
            </p>
          </div>
          <div className="text-xs font-mono font-medium text-ink-muted bg-surface border border-line rounded px-3 py-1.5 self-start md:self-auto">
            Weekly Reset: Sunday 23:59 IST
          </div>
        </div>

        <div className="overflow-hidden rounded-xl border border-line bg-surface shadow-sm">
          <div className="grid grid-cols-12 bg-canvas/80 border-b border-line px-6 py-3 text-xs font-bold text-ink-muted uppercase tracking-wider">
            <div className="col-span-1">Rank</div>
            <div className="col-span-4">Brand</div>
            <div className="col-span-3 text-right">Total Paid (Money 50%)</div>
            <div className="col-span-2 text-right">Player Pts (50%)</div>
            <div className="col-span-2 text-right">Combined</div>
          </div>
          <div className="divide-y divide-line">
            {sampleRanks.map((b) => (
              <div key={b.rank} className="grid grid-cols-12 items-center px-6 py-4 hover:bg-canvas/40 transition">
                <div className="col-span-1">
                  <span className={`inline-flex h-8 w-8 items-center justify-center rounded-lg font-mono font-black text-sm ${
                    b.rank === 1 ? "bg-win-gold text-ink" : "bg-canvas text-ink-muted border border-line"
                  }`}>
                    #{b.rank}
                  </span>
                </div>
                <div className="col-span-4 flex items-center gap-3">
                  <div
                    className="h-3.5 w-1 rounded-full"
                    style={{ backgroundColor: b.color }}
                  />
                  <div>
                    <div className="font-bold text-ink text-base">{b.name}</div>
                    <div className="text-xs text-ink-muted">{b.category}</div>
                  </div>
                </div>
                <div className="col-span-3 text-right font-mono font-bold text-ink">
                  {formatINR(b.paid)}
                </div>
                <div className="col-span-2 text-right font-mono text-sm text-ink-muted font-medium">
                  {b.points.toLocaleString()} pts
                </div>
                <div className="col-span-2 text-right">
                  <span className="font-mono font-black text-base text-primary">
                    {b.score.toFixed(1)}
                  </span>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Triple Pillar Grid */}
      <section className="border-t border-line bg-surface py-16 px-6">
        <div className="mx-auto max-w-6xl grid grid-cols-1 md:grid-cols-3 gap-8">
          <div className="rounded-xl border border-line bg-canvas p-6">
            <div className="h-10 w-10 rounded-lg bg-primary-light text-primary flex items-center justify-center mb-4">
              <Zap className="h-5 w-5" />
            </div>
            <h3 className="text-lg font-black text-ink mb-2">Zero Wasted Ad Spend</h3>
            <p className="text-sm text-ink-muted leading-relaxed">
              Every rupee paid directly climbs the public scoreboard. Brands must outbid the rank above to take the spot.
            </p>
          </div>

          <div className="rounded-xl border border-line bg-canvas p-6">
            <div className="h-10 w-10 rounded-lg bg-win-gold-light text-win-gold flex items-center justify-center mb-4">
              <Target className="h-5 w-5" />
            </div>
            <h3 className="text-lg font-black text-ink mb-2">Engaged Supporter Army</h3>
            <p className="text-sm text-ink-muted leading-relaxed">
              Fans play 1v1 trivia and reaction duels wearing your badge. Better players push your brand higher on the board.
            </p>
          </div>

          <div className="rounded-xl border border-line bg-canvas p-6">
            <div className="h-10 w-10 rounded-lg bg-primary-light text-primary flex items-center justify-center mb-4">
              <ShieldCheck className="h-5 w-5" />
            </div>
            <h3 className="text-lg font-black text-ink mb-2">Zero Shipping Hassle</h3>
            <p className="text-sm text-ink-muted leading-relaxed">
              Top brand features trending products. Outbound links navigate directly to your e-commerce domain.
            </p>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="border-t border-line bg-canvas py-8 px-6 text-center text-xs text-ink-muted mt-auto">
        <div className="mx-auto max-w-7xl flex flex-col md:flex-row items-center justify-between gap-4">
          <div>© 2026 WinToWin Platform. Engineering Standards & Strict Sports-Scoreboard Design.</div>
          <div className="flex items-center gap-6">
            <Link href="/brand" className="hover:text-ink">Brand Portal</Link>
            <Link href="/admin" className="hover:text-ink">Admin Desk</Link>
            <a href="https://github.com/721abhay/wintowin" target="_blank" rel="noreferrer" className="hover:text-ink font-mono">
              GitHub Repo
            </a>
          </div>
        </div>
      </footer>
    </div>
  );
}
