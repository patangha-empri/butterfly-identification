"use client";

import axios from "axios";
import { AlertTriangle, RotateCw } from "lucide-react";

import { apiErrorMessage } from "@/lib/api";
import { Button } from "@/components/ui/button";

/**
 * What a failed detail-page fetch should say.
 *
 * These pages used to render a bare "not found" whenever the query produced no
 * data. That is only true for a 404 — a network blip, a cold start timing out,
 * or a 500 all produced the same message, which sent people looking for a
 * deleted record that was never deleted. Only the server actually saying 404
 * means "not found"; everything else is a failure worth showing, with a way to
 * try again.
 */
export function QueryError({
  error,
  entity,
  onRetry,
}: {
  error: unknown;
  entity: string;
  onRetry?: () => void;
}) {
  const status = axios.isAxiosError(error) ? error.response?.status : undefined;

  if (status === 404) {
    return (
      <div className="p-6 text-sm text-muted-foreground">
        {entity} not found. It may have been deleted.
      </div>
    );
  }

  const offline = typeof navigator !== "undefined" && navigator.onLine === false;

  return (
    <div className="p-6">
      <div className="flex max-w-lg items-start gap-3 rounded-lg border border-destructive/30 bg-destructive/5 p-4">
        <AlertTriangle className="mt-0.5 size-4 shrink-0 text-destructive" />
        <div className="space-y-2">
          <p className="text-sm font-medium">Could not load this {entity.toLowerCase()}.</p>
          <p className="text-xs text-muted-foreground">
            {offline
              ? "You appear to be offline. Check your connection and try again."
              : apiErrorMessage(error)}
            {status ? ` (HTTP ${status})` : ""}
          </p>
          <p className="text-xs text-muted-foreground">
            The record itself is most likely fine — this is a problem reaching the
            server.
          </p>
          {onRetry && (
            <Button type="button" variant="outline" size="sm" onClick={onRetry}>
              <RotateCw size={14} className="mr-1" />
              Try again
            </Button>
          )}
        </div>
      </div>
    </div>
  );
}
