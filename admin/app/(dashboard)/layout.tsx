"use client";

import { useEffect, useState } from "react";
import { usePathname } from "next/navigation";
import { getToken } from "@/lib/auth";
import { hardRedirect } from "@/lib/navigation";
import { Sidebar } from "@/components/layout/sidebar";
import { Header } from "@/components/layout/header";

// This is the only route guard: proxy/middleware never runs under a static
// export, so every protected page is gated here on the client instead.
export default function DashboardLayout({ children }: { children: React.ReactNode }) {
  const [authorized, setAuthorized] = useState(false);
  const pathname = usePathname();

  useEffect(() => {
    const token = getToken();
    if (!token) {
      // pathname is already basePath-free, which is what /login expects back.
      hardRedirect(`/login?next=${encodeURIComponent(pathname)}`);
    } else {
      setAuthorized(true);
    }
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
