"use client";

import { useState } from "react";
import { Gift, Plus, CheckCircle, Clock } from "lucide-react";

export default function BrandRewardsPage() {
  const [rewards, setRewards] = useState([
    {
      id: "rew_1",
      title: "Flat ₹1,500 OFF on Orders Above ₹5,000",
      type: "voucher",
      promoCode: "NIKEWIN1500",
      discount: "₹1,500 OFF",
      claims: 412,
      stockRemaining: 588,
      status: "Active",
    },
    {
      id: "rew_2",
      title: "Nike Club Fleece Pullover Hoodie",
      type: "physical_product",
      promoCode: null,
      discount: "Physical Prize",
      claims: 24,
      stockRemaining: 26,
      status: "Active",
    },
  ]);

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-black text-ink tracking-tight flex items-center gap-2">
            <Gift className="h-6 w-6 text-primary" /> Brand Sponsorship Rewards
          </h2>
          <p className="text-sm text-ink-muted mt-1">
            Supplying attractive prizes motivates active gameplay and attracts more supporters to your brand.
          </p>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {rewards.map((r) => (
          <div key={r.id} className="rounded-xl border border-line bg-surface p-6 shadow-sm flex flex-col justify-between">
            <div>
              <div className="flex items-center justify-between mb-3">
                <span className={`text-[11px] font-bold uppercase tracking-wider px-2 py-0.5 rounded ${
                  r.type === "voucher" ? "bg-primary-light text-primary" : "bg-win-gold-light text-ink"
                }`}>
                  {r.type === "voucher" ? "Digital Voucher" : "Physical Product Giveaway"}
                </span>
                <span className="text-xs font-mono font-bold text-ink">
                  Stock: {r.stockRemaining} left
                </span>
              </div>
              <h3 className="font-bold text-base text-ink mb-1">{r.title}</h3>
              {r.promoCode && (
                <div className="font-mono text-xs bg-canvas border border-line rounded px-2.5 py-1 inline-block mt-2 font-bold text-ink">
                  Code: {r.promoCode}
                </div>
              )}
            </div>

            <div className="mt-6 pt-4 border-t border-line flex items-center justify-between text-xs text-ink-muted">
              <span>Claimed by supporters: <strong className="text-ink font-mono">{r.claims}</strong></span>
              <span className="text-primary font-bold flex items-center gap-1">
                <CheckCircle className="h-3.5 w-3.5" /> {r.status}
              </span>
            </div>
          </div>
        ))}
      </div>

      {/* Physical Claims Delivery Queue */}
      <div className="rounded-xl border border-line bg-surface p-6 shadow-sm">
        <h3 className="text-base font-black text-ink tracking-tight flex items-center gap-2 mb-2">
          <Clock className="h-4 w-4 text-primary" /> Physical Prize Shipping Queue
        </h3>
        <p className="text-xs text-ink-muted mb-4">
          Addresses submitted by winning players. Shipped directly from your warehouse.
        </p>

        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs">
            <thead>
              <tr className="border-b border-line bg-canvas/60 text-ink-muted font-bold uppercase tracking-wider">
                <th className="py-2.5 px-4">Winner Name</th>
                <th className="py-2.5 px-4">Prize Won</th>
                <th className="py-2.5 px-4">Shipping Address</th>
                <th className="py-2.5 px-4">Tracking Number</th>
                <th className="py-2.5 px-4 text-right">Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-line font-medium text-ink">
              <tr>
                <td className="py-3 px-4 font-bold">Abhay Kumar</td>
                <td className="py-3 px-4">Nike Club Fleece Hoodie (Size L)</td>
                <td className="py-3 px-4">Flat 402, Green Valley, Indiranagar, BLR 560038</td>
                <td className="py-3 px-4 font-mono">DELHIVERY_NK98231</td>
                <td className="py-3 px-4 text-right">
                  <span className="rounded bg-primary-light text-primary px-2 py-0.5 font-bold">
                    Out for Delivery
                  </span>
                </td>
              </tr>
              <tr>
                <td className="py-3 px-4 font-bold">Rohan Sharma</td>
                <td className="py-3 px-4">Nike Club Fleece Hoodie (Size M)</td>
                <td className="py-3 px-4">B-12, Sector 62, Noida, UP 201301</td>
                <td className="py-3 px-4 font-mono">BLUEDART_994124</td>
                <td className="py-3 px-4 text-right">
                  <span className="rounded bg-primary-light text-primary px-2 py-0.5 font-bold">
                    Dispatched
                  </span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
