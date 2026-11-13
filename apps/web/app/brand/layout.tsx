import Link from "next/link";
import { LayoutDashboard, Zap, Package, Gift, BarChart3, ArrowLeft } from "lucide-react";

export default function BrandLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="flex min-h-screen bg-canvas">
      {/* Brand Sidebar */}
      <aside className="w-64 border-r border-line bg-surface flex flex-col justify-between p-4 shrink-0">
        <div>
          {/* Logo & Brand Info */}
          <div className="flex items-center gap-3 px-2 py-3 mb-6 border-b border-line">
            <div className="h-9 w-9 rounded-lg bg-ink text-white font-black flex items-center justify-center text-base tracking-tighter">
              NK
            </div>
            <div>
              <div className="font-bold text-sm text-ink">Nike Sportswear</div>
              <div className="text-[11px] font-mono text-primary font-semibold">Rank #1 (Leader)</div>
            </div>
          </div>

          {/* Navigation Links */}
          <nav className="space-y-1">
            <Link
              href="/brand"
              className="flex items-center gap-3 px-3 py-2 rounded-lg text-sm font-semibold text-ink bg-canvas border border-line"
            >
              <LayoutDashboard className="h-4 w-4 text-primary" />
              Overview
            </Link>
            <Link
              href="/brand/boost"
              className="flex items-center gap-3 px-3 py-2 rounded-lg text-sm font-semibold text-ink-muted hover:text-ink hover:bg-canvas transition"
            >
              <Zap className="h-4 w-4 text-win-gold" />
              Outbid & Boost Rank
            </Link>
            <Link
              href="/brand/products"
              className="flex items-center gap-3 px-3 py-2 rounded-lg text-sm font-semibold text-ink-muted hover:text-ink hover:bg-canvas transition"
            >
              <Package className="h-4 w-4" />
              Featured Products
            </Link>
            <Link
              href="/brand/rewards"
              className="flex items-center gap-3 px-3 py-2 rounded-lg text-sm font-semibold text-ink-muted hover:text-ink hover:bg-canvas transition"
            >
              <Gift className="h-4 w-4" />
              Sponsorship Rewards
            </Link>
          </nav>
        </div>

        {/* Back to Home & Logout */}
        <div className="border-t border-line pt-4 px-2">
          <Link
            href="/"
            className="flex items-center gap-2 text-xs font-semibold text-ink-muted hover:text-ink transition py-1"
          >
            <ArrowLeft className="h-3.5 w-3.5" /> Back to Main Site
          </Link>
          <div className="text-[11px] text-ink-muted/70 mt-2">
            Logged in as partner@nike.com
          </div>
        </div>
      </aside>

      {/* Main Content Area */}
      <main className="flex-1 flex flex-col min-w-0 overflow-y-auto">
        <header className="h-16 border-b border-line bg-surface flex items-center justify-between px-8 sticky top-0 z-40">
          <div className="flex items-center gap-3">
            <h1 className="text-lg font-black text-ink tracking-tight">Brand Partner Portal</h1>
            <span className="text-[11px] font-mono font-semibold px-2 py-0.5 rounded bg-primary-light text-primary border border-primary/20">
              Verified Partner
            </span>
          </div>

          <div className="flex items-center gap-4">
            <Link
              href="/brand/boost"
              className="inline-flex items-center gap-2 rounded-lg bg-win-gold px-3.5 py-1.5 text-xs font-black text-ink shadow-sm hover:opacity-95 transition"
            >
              <Zap className="h-3.5 w-3.5" /> Boost Rank
            </Link>
          </div>
        </header>

        <div className="p-8 max-w-7xl w-full">
          {children}
        </div>
      </main>
    </div>
  );
}
