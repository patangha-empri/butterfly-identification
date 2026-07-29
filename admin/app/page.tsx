import { redirect } from "next/navigation";

// app/page.tsx resolves to "/" and would conflict with app/(dashboard)/page.tsx.
// Route-group pages are silently shadowed by non-grouped ones in Next.js 16,
// so we redirect here instead and keep the real dashboard at /dashboard.
export default function RootPage() {
  redirect("/dashboard");
}
