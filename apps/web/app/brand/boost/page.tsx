"use client";

import { useState } from "react";
import Link from "next/link";
import { Zap, ShieldCheck, CheckCircle2, ArrowRight } from "lucide-react";
import { formatINR } from "@/lib/utils";

export default function BoostRankPage() {
  const [amount, setAmount] = useState<number>(25000);
  const [processing, setProcessing] = useState(false);
  const [confirmed, setConfirmed] = useState(false);
  const [orderId, setOrderId] = useState("");

  const currentSpend = 520000;
  const newSpend = currentSpend + amount;
  const minimumIncrement = 10000;

  const handleCheckout = async () => {
    setProcessing(true);

    // Call Supabase Edge Function create-payment-order simulation
    setTimeout(() => {
      setProcessing(false);
      setConfirmed(true);
      setOrderId(`order_${Date.now()}`);
    }, 1200);
  };

  return (
    <div className="max-w-3xl mx-auto space-y-8">
      <div>
        <h2 className="text-2xl font-black text-ink tracking-tight flex items-center gap-2">
          <Zap className="h-6 w-6 text-win-gold" /> Outbid & Boost Brand Rank
        </h2>
        <p className="text-sm text-ink-muted mt-1">
          Every payment increases your brand's Money Score (50% weight). Real-time leaderboard updates upon Razorpay webhook verification.
        </p>
      </div>

      {confirmed ? (
        <div className="rounded-2xl border border-line bg-surface p-8 text-center shadow-sm">
          <div className="h-16 w-16 bg-primary-light text-primary rounded-full flex items-center justify-center mx-auto mb-4">
            <CheckCircle2 className="h-10 w-10" />
          </div>
          <span className="rounded bg-primary-light text-primary font-mono text-xs font-bold px-3 py-1">
            Payment Verified (HMAC-SHA256)
          </span>
          <h3 className="text-2xl font-black text-ink mt-4">Boost Successfully Applied!</h3>
          <p className="text-sm text-ink-muted mt-2 max-w-md mx-auto">
            Payment of <strong>{formatINR(amount)}</strong> was confirmed via webhook. Razorpay Order:{" "}
            <span className="font-mono text-xs">{orderId}</span>.
          </p>

          <div className="mt-6 p-4 rounded-xl bg-canvas border border-line text-left text-xs space-y-2">
            <div className="flex justify-between font-bold">
              <span>New Total Brand Investment:</span>
              <span className="font-mono">{formatINR(newSpend)}</span>
            </div>
            <div className="flex justify-between text-ink-muted">
              <span>Leaderboard Recalculation:</span>
              <span className="text-primary font-bold">Triggered & Live</span>
            </div>
          </div>

          <div className="mt-8 flex justify-center gap-4">
            <Link
              href="/brand"
              className="rounded-lg bg-primary px-6 py-2.5 text-sm font-bold text-white hover:bg-primary-dark transition"
            >
              Return to Brand Dashboard
            </Link>
          </div>
        </div>
      ) : (
        <div className="rounded-2xl border border-line bg-surface p-8 shadow-sm space-y-6">
          {/* Status Banner */}
          <div className="rounded-xl border border-line bg-canvas p-4 flex items-center justify-between">
            <div>
              <div className="text-xs font-bold text-ink-muted uppercase tracking-wider">Current Standings</div>
              <div className="text-lg font-black text-ink mt-0.5">Rank #1 • Nike Sportswear</div>
            </div>
            <div className="text-right">
              <div className="text-xs text-ink-muted">Current Paid:</div>
              <div className="font-mono font-bold text-base text-ink">{formatINR(currentSpend)}</div>
            </div>
          </div>

          {/* Amount Selector */}
          <div>
            <label className="block text-xs font-bold text-ink uppercase tracking-wider mb-2">
              Select Boost Amount (INR)
            </label>
            <div className="grid grid-cols-3 gap-3 mb-4">
              {[15000, 25000, 50000].map((preset) => (
                <button
                  key={preset}
                  type="button"
                  onClick={() => setAmount(preset)}
                  className={`rounded-lg border py-3 text-center transition font-mono font-bold text-sm ${
                    amount === preset
                      ? "border-primary bg-primary-light text-primary"
                      : "border-line bg-surface text-ink hover:bg-canvas"
                  }`}
                >
                  +{formatINR(preset)}
                </button>
              ))}
            </div>

            <div className="relative">
              <span className="absolute left-4 top-3 text-ink-muted font-bold">₹</span>
              <input
                type="number"
                min={minimumIncrement}
                step={5000}
                value={amount}
                onChange={(e) => setAmount(Number(e.target.value))}
                className="w-full rounded-lg border border-line bg-surface pl-8 pr-4 py-2.5 font-mono text-base font-bold text-ink focus:border-primary focus:outline-none"
              />
            </div>
            <div className="text-[11px] text-ink-muted mt-1.5 flex items-center justify-between">
              <span>Minimum outbid increment: {formatINR(minimumIncrement)}</span>
              <span>Projected Total: <strong className="font-mono text-ink">{formatINR(newSpend)}</strong></span>
            </div>
          </div>

          {/* Transparency & Security Card */}
          <div className="rounded-xl border border-line bg-canvas p-4 text-xs space-y-2 text-ink-muted">
            <div className="flex items-center gap-2 text-ink font-bold">
              <ShieldCheck className="h-4 w-4 text-primary" /> India-Compliant Razorpay Integration
            </div>
            <p>
              • Payments are processed securely via Razorpay (Cards, UPI, Netbanking).<br />
              • Funds are allocated according to business rules: prize pool reward replenishment and platform maintenance.<br />
              • A notification is automatically dispatched to the rival brand if their rank position is threatened.
            </p>
          </div>

          <button
            onClick={handleCheckout}
            disabled={processing || amount < minimumIncrement}
            className="w-full rounded-lg bg-primary py-3.5 text-base font-black text-white shadow-sm hover:bg-primary-dark transition flex items-center justify-center gap-2"
          >
            {processing ? (
              "Communicating with Razorpay & Edge Function..."
            ) : (
              <>
                Confirm & Pay {formatINR(amount)} <ArrowRight className="h-5 w-5" />
              </>
            )}
          </button>
        </div>
      )}
    </div>
  );
}
