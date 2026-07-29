// This file is intentionally left as a redirect.
// app/page.tsx (non-grouped) always wins over app/(dashboard)/page.tsx for the "/" route
// in Next.js 16, so the real dashboard lives at app/(dashboard)/dashboard/page.tsx → /dashboard.
import { redirect } from "next/navigation";
export default function Page() {
  redirect("/dashboard");
}
