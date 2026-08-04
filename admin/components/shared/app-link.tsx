"use client";

import { forwardRef, type AnchorHTMLAttributes } from "react";
import { appUrl } from "@/lib/navigation";

/**
 * Navigation link for the admin panel. Renders a plain anchor — a full page
 * load — with the deploy basePath applied.
 *
 * We deliberately do NOT use next/link here. Under output: "export" every route
 * is already a prebuilt HTML document on disk, so client-side soft navigation
 * buys almost nothing, yet it makes every click depend on fetching an RSC
 * payload (…/index.txt?_rsc=…). If that fetch fails at the network layer — a
 * QUIC/HTTP protocol error, a stale cached payload, a file removed by a
 * redeploy — the App Router cannot complete the transition and the page wedges
 * with no way for the user to recover.
 *
 * A hard navigation simply asks the server for a document that already exists.
 * It cannot get stuck half-way, and a failure is a normal browser error the
 * user can retry. Slightly slower, dramatically more reliable.
 */
export interface AppLinkProps extends AnchorHTMLAttributes<HTMLAnchorElement> {
  href: string;
}

export const AppLink = forwardRef<HTMLAnchorElement, AppLinkProps>(
  function AppLink({ href, ...props }, ref) {
    return <a ref={ref} href={appUrl(href)} {...props} />;
  }
);
