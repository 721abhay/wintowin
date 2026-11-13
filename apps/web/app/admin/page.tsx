"use client";

import { useState } from "react";
import { Award, Users, RefreshCw, CheckCircle, XCircle, ShieldAlert, AlertTriangle } from "lucide-react";
import { formatINR } from "@/lib/utils";

export default function AdminPage() {
  const [recalculating, setRecalculating] = useState(false);
  const [lastRecalculated, setLastRecalculated] = useState("Just now");

  const [pendingBrands, setPendingBrands] = useState([
    {
      id: "brand_pending_1",
      name: "Fastrack Watches",
      category: "Wearables",
      gstin: "29AAACB1234D1Z4",
      website: "https://www.fastrack.in",
      submittedAt: "2 hours ago",
    },
    {
      id: "brand_pending_2",
      name: "Myfitness Peanut Butter",
      category: "Health & Nutrition",
      gstin: "27AAECK5678B1Z2",
      website: "https://myfitness.in",
      submittedAt: "5 hours ago",
    },
  ]);

  const [flaggedMatches] = useState([
    {
      id: "match_cheat_1",
      userId: "user_981",
      gameType: "Reaction Duel",
      recordedTime: "42 ms",
      reason: "Below 80ms human threshold (Bot suspected)",
      actionTaken: "Points nullified, flagged",
    },
    {
      id: "match_cheat_2",
      userId: "user_412",
      gameType: "Trivia Quiz",
      recordedTime: "120 ms/answer",
      reason: "Scripted click macro detected",
      actionTaken: "Daily cap frozen",
    },
  ]);

  const handleRecalculate = () => {
    setRecalculating(true);
    setTimeout(() => {
      setRecalculating(false);
      setLastRecalculated(new Date().toLocaleTimeString());
    }, 1000);
  };

  const handleApprove = (id: string) => {
    setPendingBrands(pendingBrands.filter((b) => b.id !== id));
  };

  const handleReject = (id: string) => {
    setPendingBrands(pendingBrands.filter((b) => b.id !== id));
  };

  return (
    <div className="space-y-8">
      {/* Top Action Controls */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 rounded-xl border border-line bg-surface p-6 shadow-sm">
        <div>
          <h2 className="text-xl font-black text-ink tracking-tight flex items-center gap-2">
            <Award className="h-5 w-5 text-win-gold" /> Brand Rank Engine Controls
          </h2>
          <p className="text-xs text-ink-muted mt-1">
            Recompute 50/50 scores across all active brands. Last executed: <strong>{lastRecalculated}</strong>.
          </p>
        </div>

        <div className="flex items-center gap-3">
          <button
            onClick={handleRecalculate}
            disabled={recalculating}
            className="inline-flex items-center gap-2 rounded-lg bg-primary px-4 py-2 text-xs font-bold text-white hover:bg-primary-dark transition"
          >
            <RefreshCw className={`h-3.5 w-3.5 ${recalculating ? "animate-spin" : ""}`} />
            {recalculating ? "Computing Ranks..." : "Recalculate Ranks Now"}
          </button>
        </div>
      </div>

      {/* Pending Brand Approvals */}
      <div id="kyc" className="rounded-xl border border-line bg-surface p-6 shadow-sm">
        <h3 className="text-base font-black text-ink tracking-tight flex items-center gap-2 mb-2">
          <Users className="h-5 w-5 text-primary" /> Pending Brand KYC Applications ({pendingBrands.length})
        </h3>
        <p className="text-xs text-ink-muted mb-4">
          Verify GSTIN and business authority before authorizing brands to participate in outbidding.
        </p>

        {pendingBrands.length === 0 ? (
          <div className="rounded-lg border border-line bg-canvas p-6 text-center text-xs text-ink-muted">
            All brand partner applications reviewed. Zero pending KYC requests.
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead>
                <tr className="border-b border-line bg-canvas/60 text-ink-muted font-bold uppercase tracking-wider">
                  <th className="py-2.5 px-4">Brand Name</th>
                  <th className="py-2.5 px-4">Category</th>
                  <th className="py-2.5 px-4">GSTIN</th>
                  <th className="py-2.5 px-4">Website</th>
                  <th className="py-2.5 px-4">Submitted</th>
                  <th className="py-2.5 px-4 text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-line font-medium text-ink">
                {pendingBrands.map((b) => (
                  <tr key={b.id}>
                    <td className="py-3 px-4 font-bold">{b.name}</td>
                    <td className="py-3 px-4">{b.category}</td>
                    <td className="py-3 px-4 font-mono">{b.gstin}</td>
                    <td className="py-3 px-4 text-primary underline">
                      <a href={b.website} target="_blank" rel="noreferrer">{b.website}</a>
                    </td>
                    <td className="py-3 px-4 text-ink-muted">{b.submittedAt}</td>
                    <td className="py-3 px-4 text-right">
                      <div className="flex items-center justify-end gap-2">
                        <button
                          onClick={() => handleApprove(b.id)}
                          className="inline-flex items-center gap-1 rounded bg-primary-light text-primary border border-primary/20 px-2.5 py-1 text-xs font-bold hover:bg-primary hover:text-white transition"
                        >
                          <CheckCircle className="h-3.5 w-3.5" /> Approve
                        </button>
                        <button
                          onClick={() => handleReject(b.id)}
                          className="inline-flex items-center gap-1 rounded bg-canvas text-danger border border-line px-2.5 py-1 text-xs font-bold hover:bg-danger hover:text-white transition"
                        >
                          <XCircle className="h-3.5 w-3.5" /> Reject
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* Anti-Cheat & Fraud Watch */}
      <div id="anti-cheat" className="rounded-xl border border-line bg-surface p-6 shadow-sm">
        <h3 className="text-base font-black text-ink tracking-tight flex items-center gap-2 mb-2">
          <ShieldAlert className="h-5 w-5 text-warning" /> Anti-Cheat & Integrity Monitor
        </h3>
        <p className="text-xs text-ink-muted mb-4">
          Automated server-side verification flags humanly impossible reaction times (&lt;80ms) and bot macros.
        </p>

        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs">
            <thead>
              <tr className="border-b border-line bg-canvas/60 text-ink-muted font-bold uppercase tracking-wider">
                <th className="py-2.5 px-4">Player ID</th>
                <th className="py-2.5 px-4">Game Arena</th>
                <th className="py-2.5 px-4">Recorded Timing</th>
                <th className="py-2.5 px-4">Anomaly Flag</th>
                <th className="py-2.5 px-4 text-right">System Action</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-line font-medium text-ink">
              {flaggedMatches.map((m) => (
                <tr key={m.id}>
                  <td className="py-3 px-4 font-mono font-bold">{m.userId}</td>
                  <td className="py-3 px-4">{m.gameType}</td>
                  <td className="py-3 px-4 font-mono text-danger font-bold">{m.recordedTime}</td>
                  <td className="py-3 px-4 flex items-center gap-1 text-warning font-semibold">
                    <AlertTriangle className="h-3.5 w-3.5" /> {m.reason}
                  </td>
                  <td className="py-3 px-4 text-right">
                    <span className="rounded bg-canvas text-ink-muted border border-line px-2 py-0.5 text-[11px] font-bold">
                      {m.actionTaken}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
