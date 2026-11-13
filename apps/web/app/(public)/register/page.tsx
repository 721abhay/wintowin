"use client";

import { useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { Store, CheckCircle, ArrowRight } from "lucide-react";

export default function RegisterBrandPage() {
  const router = useRouter();
  const [submitted, setSubmitted] = useState(false);
  const [formData, setFormData] = useState({
    name: "",
    category: "Sportswear",
    website: "",
    gstin: "",
    tagline: "",
    primaryColor: "#0E7A5F",
    contactEmail: "",
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setSubmitted(true);
  };

  return (
    <div className="flex min-h-screen items-center justify-center bg-canvas px-4 py-12">
      <div className="w-full max-w-xl rounded-2xl border border-line bg-surface p-8 shadow-sm">
        <div className="text-center mb-8">
          <Link href="/" className="inline-flex h-12 w-12 items-center justify-center rounded-xl bg-ink text-white font-black text-2xl mb-4">
            W2W
          </Link>
          <h1 className="text-2xl font-black text-ink tracking-tight">Onboard Your Brand</h1>
          <p className="text-xs text-ink-muted mt-1">Submit your KYC and brand details for admin approval</p>
        </div>

        {submitted ? (
          <div className="rounded-xl border border-line bg-primary-light p-6 text-center">
            <CheckCircle className="h-12 w-12 text-primary mx-auto mb-3" />
            <h2 className="text-lg font-black text-ink">KYC Application Submitted!</h2>
            <p className="text-xs text-ink-muted mt-2 leading-relaxed">
              Your brand <strong>{formData.name}</strong> is under verification. Our admin team checks GSTIN and brand authority within 24 hours.
            </p>
            <div className="mt-6 flex justify-center gap-3">
              <button
                onClick={() => router.push("/brand")}
                className="rounded-lg bg-primary px-4 py-2 text-xs font-bold text-white hover:bg-primary-dark transition"
              >
                Go to Brand Sandbox
              </button>
              <Link
                href="/"
                className="rounded-lg border border-line bg-surface px-4 py-2 text-xs font-bold text-ink hover:bg-canvas transition"
              >
                Back to Home
              </Link>
            </div>
          </div>
        ) : (
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-xs font-bold text-ink uppercase tracking-wider mb-1.5">
                  Brand Name
                </label>
                <input
                  type="text"
                  required
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  placeholder="e.g. Puma Sports"
                  className="w-full rounded-lg border border-line bg-surface px-4 py-2.5 text-sm font-medium text-ink focus:border-primary focus:outline-none"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-ink uppercase tracking-wider mb-1.5">
                  Category
                </label>
                <select
                  value={formData.category}
                  onChange={(e) => setFormData({ ...formData, category: e.target.value })}
                  className="w-full rounded-lg border border-line bg-surface px-4 py-2.5 text-sm font-medium text-ink focus:border-primary focus:outline-none"
                >
                  <option value="Sportswear">Sportswear & Footwear</option>
                  <option value="Consumer Electronics">Consumer Electronics & Audio</option>
                  <option value="Apparel & Fashion">Apparel & Fashion</option>
                  <option value="Health & Nutrition">Health & Nutrition</option>
                  <option value="Gaming & Accessories">Gaming & Accessories</option>
                </select>
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-xs font-bold text-ink uppercase tracking-wider mb-1.5">
                  Official Website
                </label>
                <input
                  type="url"
                  required
                  value={formData.website}
                  onChange={(e) => setFormData({ ...formData, website: e.target.value })}
                  placeholder="https://brand.com"
                  className="w-full rounded-lg border border-line bg-surface px-4 py-2.5 text-sm font-medium text-ink focus:border-primary focus:outline-none"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-ink uppercase tracking-wider mb-1.5">
                  GSTIN (India)
                </label>
                <input
                  type="text"
                  required
                  value={formData.gstin}
                  onChange={(e) => setFormData({ ...formData, gstin: e.target.value })}
                  placeholder="29AAAAA0000A1Z5"
                  className="w-full rounded-lg border border-line bg-surface px-4 py-2.5 text-sm font-medium text-ink focus:border-primary focus:outline-none uppercase font-mono"
                />
              </div>
            </div>

            <div>
              <label className="block text-xs font-bold text-ink uppercase tracking-wider mb-1.5">
                Brand Tagline
              </label>
              <input
                type="text"
                required
                value={formData.tagline}
                onChange={(e) => setFormData({ ...formData, tagline: e.target.value })}
                placeholder="Forever Faster. Performance apparel."
                className="w-full rounded-lg border border-line bg-surface px-4 py-2.5 text-sm font-medium text-ink focus:border-primary focus:outline-none"
              />
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-xs font-bold text-ink uppercase tracking-wider mb-1.5">
                  Brand Color (Accent Hex)
                </label>
                <div className="flex items-center gap-2">
                  <input
                    type="color"
                    value={formData.primaryColor}
                    onChange={(e) => setFormData({ ...formData, primaryColor: e.target.value })}
                    className="h-10 w-12 rounded cursor-pointer border border-line"
                  />
                  <input
                    type="text"
                    value={formData.primaryColor}
                    onChange={(e) => setFormData({ ...formData, primaryColor: e.target.value })}
                    className="w-full rounded-lg border border-line bg-surface px-3 py-2 text-xs font-mono font-bold"
                  />
                </div>
              </div>

              <div>
                <label className="block text-xs font-bold text-ink uppercase tracking-wider mb-1.5">
                  Business Email
                </label>
                <input
                  type="email"
                  required
                  value={formData.contactEmail}
                  onChange={(e) => setFormData({ ...formData, contactEmail: e.target.value })}
                  placeholder="marketing@brand.com"
                  className="w-full rounded-lg border border-line bg-surface px-4 py-2.5 text-sm font-medium text-ink focus:border-primary focus:outline-none"
                />
              </div>
            </div>

            <button
              type="submit"
              className="w-full mt-4 rounded-lg bg-primary py-3 text-sm font-bold text-white shadow-sm hover:bg-primary-dark transition flex items-center justify-center gap-2"
            >
              Submit Brand Application <ArrowRight className="h-4 w-4" />
            </button>
          </form>
        )}

        <div className="mt-6 border-t border-line pt-4 text-center text-xs text-ink-muted">
          Already approved?{" "}
          <Link href="/login" className="font-bold text-primary hover:underline">
            Sign In Here
          </Link>
        </div>
      </div>
    </div>
  );
}
