"use client";

import { useEffect } from "react";
import { hardRedirect } from "@/lib/navigation";

// app/page.tsx (non-grouped) always wins over app/(dashboard)/page.tsx for the "/" route,
// so the real dashboard lives at app/(dashboard)/dashboard/page.tsx → /dashboard.
// Hard redirect for the same reasons as app/page.tsx.
export default function Page() {
  useEffect(() => {
    hardRedirect("/dashboard");
  }, []);

  return null;
}
