"use client";

import { useEffect } from "react";
import { hardRedirect } from "@/lib/navigation";

// app/page.tsx resolves to "/" and would conflict with app/(dashboard)/page.tsx.
// Route-group pages are silently shadowed by non-grouped ones, so we forward
// here and keep the real dashboard at /dashboard.
//
// This must be a *client* redirect: next/navigation's redirect() runs during
// prerender, which output: "export" cannot resolve — it bakes an error document
// into out/index.html instead of a working entry point. And it must be a hard
// redirect rather than router.replace(), so the entry point never depends on
// the client router booting successfully.
export default function RootPage() {
  useEffect(() => {
    hardRedirect("/dashboard");
  }, []);

  return null;
}
