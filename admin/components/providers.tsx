"use client";

import { useState } from "react";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import type { AxiosError } from "axios";
import { Toaster } from "@/components/ui/sonner";
import { TooltipProvider } from "@/components/ui/tooltip";

export function Providers({ children }: { children: React.ReactNode }) {
  const [queryClient] = useState(
    () =>
      new QueryClient({
        defaultOptions: {
          queries: {
            staleTime: 30 * 1000,
            // Retrying a 4xx is pointless — the server answered, and the answer
            // will not change. Transient failures are the ones worth retrying:
            // a network blip, or a Cloud Run cold start timing out. With a flat
            // retry:1 those surfaced as real errors after two quick attempts,
            // which the detail pages then rendered as "not found".
            retry: (failureCount, error) => {
              const status = (error as AxiosError)?.response?.status;
              if (status && status >= 400 && status < 500) return false;
              return failureCount < 3;
            },
            retryDelay: (attempt) => Math.min(1000 * 2 ** attempt, 8000),
            refetchOnWindowFocus: false,
          },
        },
      })
  );

  return (
    <QueryClientProvider client={queryClient}>
      {/* Radix tooltips need a provider above every trigger. The species screens
          lean on tooltips to explain what Active/Inactive actually does. */}
      <TooltipProvider delayDuration={200}>
        {children}
        <Toaster richColors position="top-right" />
      </TooltipProvider>
    </QueryClientProvider>
  );
}
