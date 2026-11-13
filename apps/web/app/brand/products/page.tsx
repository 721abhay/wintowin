"use client";

import { useState } from "react";
import { Package, Plus, ExternalLink, Trash2 } from "lucide-react";
import { formatINR } from "@/lib/utils";

export default function ProductsPage() {
  const [products, setProducts] = useState([
    {
      id: "prod_1",
      title: "Air Zoom Pegasus 40 Running Shoes",
      price: 7995,
      targetUrl: "https://www.nike.com/in/t/pegasus-40-road-running-shoes",
      imageUrl: "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&auto=format&fit=crop&q=80",
      badge: "Trending",
      clicks: 1824,
    },
    {
      id: "prod_2",
      title: "Dri-FIT Academy Pro Football Tracksuit",
      price: 3995,
      targetUrl: "https://www.nike.com/in/t/dri-fit-academy-tracksuit",
      imageUrl: "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=600&auto=format&fit=crop&q=80",
      badge: "Hot",
      clicks: 1142,
    },
    {
      id: "prod_3",
      title: "Air Max 270 Lifestyle Sneakers",
      price: 9995,
      targetUrl: "https://www.nike.com/in/t/air-max-270-shoes",
      imageUrl: "https://images.unsplash.com/photo-1552346154-21d32810aba3?w=600&auto=format&fit=crop&q=80",
      badge: "Featured",
      clicks: 874,
    },
  ]);

  const [showModal, setShowModal] = useState(false);
  const [newTitle, setNewTitle] = useState("");
  const [newPrice, setNewPrice] = useState("");
  const [newUrl, setNewUrl] = useState("");

  const handleAdd = (e: React.FormEvent) => {
    e.preventDefault();
    setProducts([
      ...products,
      {
        id: `prod_${Date.now()}`,
        title: newTitle,
        price: Number(newPrice),
        targetUrl: newUrl,
        imageUrl: "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&auto=format&fit=crop&q=80",
        badge: "New",
        clicks: 0,
      },
    ]);
    setShowModal(false);
    setNewTitle("");
    setNewPrice("");
    setNewUrl("");
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-black text-ink tracking-tight flex items-center gap-2">
            <Package className="h-6 w-6 text-primary" /> Featured Product Catalog
          </h2>
          <p className="text-sm text-ink-muted mt-1">
            When your brand ranks #1, these products are automatically showcased on the app home screen.
          </p>
        </div>
        <button
          onClick={() => setShowModal(true)}
          className="inline-flex items-center gap-2 rounded-lg bg-primary px-4 py-2 text-xs font-bold text-white hover:bg-primary-dark transition"
        >
          <Plus className="h-4 w-4" /> Add Product
        </button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {products.map((p) => (
          <div key={p.id} className="rounded-xl border border-line bg-surface overflow-hidden shadow-sm flex flex-col justify-between">
            <div>
              <div className="relative h-44 bg-canvas flex items-center justify-center p-4 overflow-hidden border-b border-line">
                <img
                  src={p.imageUrl}
                  alt={p.title}
                  className="h-full object-contain"
                />
                <span className="absolute top-3 left-3 rounded bg-primary text-white text-[10px] font-black uppercase px-2 py-0.5 tracking-wider">
                  {p.badge}
                </span>
              </div>
              <div className="p-4">
                <h4 className="font-bold text-sm text-ink line-clamp-1">{p.title}</h4>
                <div className="font-mono text-base font-black text-ink mt-1">{formatINR(p.price)}</div>
                <div className="text-xs text-ink-muted mt-2">
                  Total Clicks Tracked: <strong className="text-primary font-mono">{p.clicks}</strong>
                </div>
              </div>
            </div>

            <div className="p-4 border-t border-line bg-canvas/30 flex items-center justify-between">
              <a
                href={p.targetUrl}
                target="_blank"
                rel="noreferrer"
                className="text-xs font-bold text-primary inline-flex items-center gap-1 hover:underline"
              >
                Store Link <ExternalLink className="h-3 w-3" />
              </a>
              <button
                onClick={() => setProducts(products.filter((item) => item.id !== p.id))}
                className="text-ink-muted hover:text-danger transition p-1"
                title="Remove product"
              >
                <Trash2 className="h-4 w-4" />
              </button>
            </div>
          </div>
        ))}
      </div>

      {showModal && (
        <div className="fixed inset-0 z-50 bg-ink/50 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="w-full max-w-md rounded-2xl border border-line bg-surface p-6 shadow-xl">
            <h3 className="text-lg font-black text-ink mb-4">Add Featured Product</h3>
            <form onSubmit={handleAdd} className="space-y-4">
              <div>
                <label className="block text-xs font-bold text-ink uppercase mb-1">Title</label>
                <input
                  type="text"
                  required
                  value={newTitle}
                  onChange={(e) => setNewTitle(e.target.value)}
                  placeholder="e.g. Nike Pro Cap"
                  className="w-full rounded-lg border border-line bg-surface px-3 py-2 text-sm focus:outline-none focus:border-primary"
                />
              </div>
              <div>
                <label className="block text-xs font-bold text-ink uppercase mb-1">Price (INR)</label>
                <input
                  type="number"
                  required
                  value={newPrice}
                  onChange={(e) => setNewPrice(e.target.value)}
                  placeholder="1495"
                  className="w-full rounded-lg border border-line bg-surface px-3 py-2 text-sm focus:outline-none focus:border-primary font-mono"
                />
              </div>
              <div>
                <label className="block text-xs font-bold text-ink uppercase mb-1">Store URL</label>
                <input
                  type="url"
                  required
                  value={newUrl}
                  onChange={(e) => setNewUrl(e.target.value)}
                  placeholder="https://www.nike.com/in/t/..."
                  className="w-full rounded-lg border border-line bg-surface px-3 py-2 text-sm focus:outline-none focus:border-primary"
                />
              </div>
              <div className="flex justify-end gap-2 pt-2">
                <button
                  type="button"
                  onClick={() => setShowModal(false)}
                  className="rounded-lg border border-line px-4 py-2 text-xs font-bold text-ink"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="rounded-lg bg-primary px-4 py-2 text-xs font-bold text-white hover:bg-primary-dark"
                >
                  Save Product
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
