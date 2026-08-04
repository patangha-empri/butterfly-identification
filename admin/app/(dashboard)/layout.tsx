"use client";

import { useEffect, useState } from "react";
import { getToken } from "@/lib/auth";
import { Sidebar } from "@/components/layout/sidebar";
import { Header } from "@/components/layout/header";

export default function DashboardLayout({ children }: { children: React.ReactNode }) {
  const [authorized, setAuthorized] = useState(false);

  useEffect(() => {
    const token = getToken();
    if (!token) {
      if (typeof window !== "undefined") {
        window.location.href = "/admin/login/";
      }
    } else {
      setAuthorized(true);
    }
  }, []);

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
