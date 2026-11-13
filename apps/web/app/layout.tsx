import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "WinToWin Brand Portal & Admin",
  description: "Climb the leaderboard, engage loyal fans, and drive direct sales on WinToWin.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="min-h-screen bg-canvas text-ink antialiased">
        {children}
      </body>
    </html>
  );
}
