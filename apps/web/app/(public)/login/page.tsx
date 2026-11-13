"use client";

import { useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { ShieldCheck, Store, Lock, ArrowRight } from "lucide-react";

export default function LoginPage() {
  const router = useRouter();
  const [role, setRole] = useState<"brand" | "admin">("brand");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    setTimeout(() => {
      setLoading(false);
      if (role === "admin") {
        router.push("/admin");
      } else {
        router.push("/brand");
      }
    }, 600);
  };

  return (
    <div className="flex min-h-screen items-center justify-center bg-canvas px-4 py-12">
      <div className="w-full max-w-md rounded-2xl border border-line bg-surface p-8 shadow-sm">
        <div className="text-center mb-8">
          <Link href="/" className="inline-flex h-12 w-12 items-center justify-center rounded-xl bg-ink text-white font-black text-2xl mb-4">
            W2W
          </Link>
          <h1 className="text-2xl font-black text-ink tracking-tight">Sign in to WinToWin</h1>
          <p className="text-xs text-ink-muted mt-1">Access the Brand Dashboard or Admin Console</p>
        </div>

        {/* Role Toggle */}
        <div className="grid grid-cols-2 gap-2 rounded-lg border border-line bg-canvas p-1 mb-6">
          <button
            type="button"
            onClick={() => setRole("brand")}
            className={`flex items-center justify-center gap-2 rounded-md py-2 text-xs font-bold transition ${
              role === "brand" ? "bg-surface text-ink shadow-sm" : "text-ink-muted hover:text-ink"
            }`}
          >
            <Store className="h-4 w-4" /> Brand Partner
          </button>
          <button
            type="button"
            onClick={() => setRole("admin")}
            className={`flex items-center justify-center gap-2 rounded-md py-2 text-xs font-bold transition ${
              role === "admin" ? "bg-surface text-ink shadow-sm" : "text-ink-muted hover:text-ink"
            }`}
          >
            <ShieldCheck className="h-4 w-4" /> Admin
          </button>
        </div>

        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="block text-xs font-bold text-ink uppercase tracking-wider mb-1.5">
              Email Address
            </label>
            <input
              type="email"
              required
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder={role === "admin" ? "admin@wintowin.app" : "partner@brand.com"}
              className="w-full rounded-lg border border-line bg-surface px-4 py-2.5 text-sm font-medium text-ink focus:border-primary focus:outline-none focus:ring-1 focus:ring-primary"
            />
          </div>

          <div>
            <label className="block text-xs font-bold text-ink uppercase tracking-wider mb-1.5">
              Password
            </label>
            <div className="relative">
              <input
                type="password"
                required
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="••••••••"
                className="w-full rounded-lg border border-line bg-surface px-4 py-2.5 text-sm font-medium text-ink focus:border-primary focus:outline-none focus:ring-1 focus:ring-primary"
              />
              <Lock className="absolute right-3 top-3 h-4 w-4 text-ink-muted" />
            </div>
          </div>

          <button
            type="submit"
            disabled={loading}
            className="w-full rounded-lg bg-primary py-3 text-sm font-bold text-white shadow-sm hover:bg-primary-dark transition flex items-center justify-center gap-2"
          >
            {loading ? "Authenticating..." : `Enter ${role === "admin" ? "Admin Console" : "Brand Dashboard"}`}
            <ArrowRight className="h-4 w-4" />
          </button>
        </form>

        <div className="mt-6 border-t border-line pt-4 text-center text-xs text-ink-muted">
          Want to onboard a new brand?{" "}
          <Link href="/register" className="font-bold text-primary hover:underline">
            Submit Brand KYC
          </Link>
        </div>
      </div>
    </div>
  );
}
