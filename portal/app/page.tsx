// app/page.tsx — non-grouped root shadows (public)/page.tsx, so redirect to /home
import { redirect } from "next/navigation";

export default function RootPage() {
  redirect("/home");
}
