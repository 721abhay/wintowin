import Link from "next/link";
import { ShieldAlert, Users, Award, Settings, ArrowLeft } from "lucide-react";

export default function AdminLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="flex min-h-screen bg-canvas">
      {/* Admin Sidebar */}
      <aside className="w-64 border-r border-line bg-surface flex flex-col justify-between p-4 shrink-0">
        <div>
          <div className="flex items-center gap-3 px-2 py-3 mb-6 border-b border-line">
            <div className="h-9 w-9 rounded-lg bg-danger text-white font-black flex items-center justify-center text-sm">
              ADM
            </div>
            <div>
              <div className="font-bold text-sm text-ink">WinToWin Admin</div>
              <div className="text-[11px] font-mono text-danger font-semibold">Super Administrator</div>
            </div>
          </div>

          <nav className="space-y-1">
            <Link
              href="/admin"
              className="flex items-center gap-3 px-3 py-2 rounded-lg text-sm font-semibold text-ink bg-canvas border border-line"
            >
              <Award className="h-4 w-4 text-primary" />
              Leaderboard & Recalculation
            </Link>
            <Link
              href="/admin#kyc"
              className="flex items-center gap-3 px-3 py-2 rounded-lg text-sm font-semibold text-ink-muted hover:text-ink hover:bg-canvas transition"
            >
              <Users className="h-4 w-4" />
              Brand KYC Approvals
            </Link>
            <Link
              href="/admin#anti-cheat"
              className="flex items-center gap-3 px-3 py-2 rounded-lg text-sm font-semibold text-ink-muted hover:text-ink hover:bg-canvas transition"
            >
              <ShieldAlert className="h-4 w-4 text-warning" />
              Anti-Cheat & Fraud Watch
            </Link>
          </nav>
        </div>

        <div className="border-t border-line pt-4 px-2">
          <Link
            href="/"
            className="flex items-center gap-2 text-xs font-semibold text-ink-muted hover:text-ink transition py-1"
          >
            <ArrowLeft className="h-3.5 w-3.5" /> Back to Main Site
          </Link>
          <div className="text-[11px] text-ink-muted/70 mt-2">
            Logged in as admin@wintowin.app
          </div>
        </div>
      </aside>

      {/* Main Admin Area */}
      <main className="flex-1 flex flex-col min-w-0 overflow-y-auto">
        <header className="h-16 border-b border-line bg-surface flex items-center justify-between px-8 sticky top-0 z-40">
          <div className="flex items-center gap-3">
            <h1 className="text-lg font-black text-ink tracking-tight">System Administration</h1>
            <span className="text-[11px] font-mono font-semibold px-2 py-0.5 rounded bg-win-gold-light text-ink border border-win-gold/40">
              Live Production
            </span>
          </div>
        </header>

        <div className="p-8 max-w-7xl w-full">
          {children}
        </div>
      </main>
    </div>
  );
}
