"use client";

import { useEffect, useState } from "react";
import { usePathname } from "next/navigation";
import { hasSession, hasStoredCredentials, needsRefresh } from "@/lib/auth";
import { endSession, ensureAccessToken } from "@/lib/session";
import { Sidebar } from "@/components/layout/sidebar";
import { Header } from "@/components/layout/header";

// This is the only route guard: proxy/middleware never runs under a static
// export, so every protected page is gated here on the client instead.
//
// The guard admits anyone holding *either* a live access token or a usable
// refresh token. Gating on the access token alone — the previous behaviour —
// meant returning after the 24h access window bounced you to /login even though
// the 30-day refresh token sitting in localStorage could have restored the
// session silently.
export default function DashboardLayout({ children }: { children: React.ReactNode }) {
  const [authorized, setAuthorized] = useState(false);
  const pathname = usePathname();

  useEffect(() => {
    let cancelled = false;

    if (!hasSession()) {
      // Tokens present but past their window (a return visit after 30 days
      // away) is an expiry worth explaining. Nothing stored at all is just a
      // signed-out visitor, who needs no apology.
      endSession(hasStoredCredentials() ? "expired" : undefined);
      return;
    }

    if (!needsRefresh()) {
      setAuthorized(true);
      return;
    }

    // Access token is stale but the refresh token is good. Renew before we
    // render, so the dashboard's first data fetch already has a live token
    // instead of racing several parallel refreshes.
    void ensureAccessToken()
      .then((token) => {
        if (cancelled) return;
        if (token) setAuthorized(true);
        else endSession("expired");
      })
      // A network failure here is not an expired session — render anyway and
      // let the individual requests surface their own errors.
      .catch(() => {
        if (!cancelled) setAuthorized(true);
      });

    return () => {
      cancelled = true;
    };
  }, [pathname]);

  if (!authorized) {
    return null;
  }

  return (
    <div className="flex h-screen overflow-hidden">
      {/* Sidebar — desktop only */}
      <Sidebar className="hidden md:flex w-56 flex-col shrink-0" />

      {/* Main area */}
      <div className="flex flex-col flex-1 overflow-hidden">
        <Header />
        <main className="flex-1 overflow-y-auto bg-muted/20">
          {children}
        </main>
      </div>
    </div>
  );
}
