"use client";

import { useEffect } from "react";
import { AlertTriangle } from "lucide-react";
import { Button } from "@/components/ui/button";
import { appUrl } from "@/lib/navigation";

/**
 * Recovery UI for any unhandled error inside the dashboard.
 *
 * Without this, a throw during render leaves a blank document and the user has
 * no route back — which is how a single failed request turned into a dead page.
 * Reloading is the right recovery here: every route is a static file, so a
 * fresh document load rebuilds the app from scratch.
 */
export default function DashboardError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    console.error("Dashboard error:", error);
  }, [error]);

  return (
    <div className="flex min-h-[60vh] items-center justify-center p-6">
      <div className="max-w-md space-y-4 text-center">
        <AlertTriangle className="mx-auto size-10 text-destructive" />
        <div className="space-y-1.5">
          <h2 className="text-lg font-semibold">Something went wrong</h2>
          <p className="text-sm text-muted-foreground">
            This page failed to load. Reloading usually fixes it — the app fetches a
            fresh copy from the server.
          </p>
          {error.digest && (
            <p className="text-[10px] text-muted-foreground/70">Ref: {error.digest}</p>
          )}
        </div>
        <div className="flex justify-center gap-2">
          <Button onClick={() => window.location.reload()}>Reload page</Button>
          <Button variant="outline" onClick={reset}>
            Try again
          </Button>
          <Button variant="ghost" asChild>
            <a href={appUrl("/dashboard")}>Dashboard</a>
          </Button>
        </div>
      </div>
    </div>
  );
}
