"use client";

import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { formatDistanceToNow } from "date-fns";
import { CheckCircle2, Eye, Clock, Cpu, AlertCircle, BarChart3, Database, ChevronLeft, ChevronRight } from "lucide-react";
import Link from "next/link";

import api from "@/lib/api";
import { SearchInput } from "@/components/shared/search-input";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { Progress } from "@/components/ui/progress";
import { Skeleton } from "@/components/ui/skeleton";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import type { ApiResponse, IdentificationResult, PaginationMeta } from "@/types";

const OBSERVATION_STATUS_LABELS: Record<string, { label: string; cls: string }> = {
  pending: { label: "Pending", cls: "bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-400" },
  ai_identified: { label: "AI Identified", cls: "bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400" },
  expert_verified: { label: "Expert Verified", cls: "bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400" },
  community_verified: { label: "Community Verified", cls: "bg-emerald-100 text-emerald-800 dark:bg-emerald-900/30 dark:text-emerald-400" },
  rejected: { label: "Rejected", cls: "bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400" },
};

export default function IdentificationsPage() {
  const [page, setPage] = useState(1);
  const [search, setSearch] = useState("");
  const [status, setStatus] = useState("completed");

  const { data, isLoading } = useQuery({
    queryKey: ["identifications", page, search, status],
    queryFn: async () => {
      const params = new URLSearchParams({
        page: String(page),
        per_page: "20",
        ...(status !== "all" && { status }),
        ...(search && { search }),
      });
      const res = await api.get<ApiResponse<IdentificationResult[]>>(
        `/admin/identifications?${params}`
      );
      return { results: res.data.data, meta: res.data.meta as PaginationMeta };
    },
  });

  const results = data?.results ?? [];

  function StatusIcon({ status }: { status: string }) {
    if (status === "completed") return <CheckCircle2 size={15} className="text-green-500 shrink-0" />;
    if (status === "failed") return <AlertCircle size={15} className="text-red-500 shrink-0" />;
    if (status === "processing") return <Cpu size={15} className="text-blue-500 animate-pulse shrink-0" />;
    return <Clock size={15} className="text-muted-foreground shrink-0" />;
  }

  return (
    <div className="p-4 md:p-6 space-y-5">
      <div>
        <h2 className="text-base font-semibold">Identification Log</h2>
        <p className="text-xs text-muted-foreground">
          Audit Gemini Vision execution details, token usage metadata, and sighting information.
        </p>
      </div>

      <div className="flex items-center gap-2">
        <SearchInput
          value={search}
          onChange={(v) => { setSearch(v); setPage(1); }}
          placeholder="Search observation ID…"
          className="max-w-72"
        />
        <Select value={status} onValueChange={(v) => { setStatus(v); setPage(1); }}>
          <SelectTrigger className="h-8 w-36 text-xs">
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Jobs</SelectItem>
            <SelectItem value="completed">Completed</SelectItem>
            <SelectItem value="failed">Failed</SelectItem>
            <SelectItem value="processing">Processing</SelectItem>
          </SelectContent>
        </Select>
      </div>

      {isLoading ? (
        <div className="space-y-4">
          {Array.from({ length: 4 }).map((_, i) => (
            <Skeleton key={i} className="h-44 w-full" />
          ))}
        </div>
      ) : results.length === 0 ? (
        <div className="text-center text-muted-foreground py-16">
          No logs found matching search criteria.
        </div>
      ) : (
        <div className="space-y-4">
          {results.map((result) => {
            const obs = result.observation;
            let obsStatus = obs ? (OBSERVATION_STATUS_LABELS[obs.verification_status] || { label: obs.verification_status, cls: "bg-muted" }) : null;

            if (obs && obs.verification_status === "rejected" && result.error_message) {
              obsStatus = {
                label: result.error_message === "No butterfly detected in image." ? "Not a Butterfly" : "Quality Too Poor",
                cls: "bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400"
              };
            }

            return (
              <Card key={result.id} className="overflow-hidden hover:border-muted-foreground/30 transition-all">
                <CardContent className="p-0">
                  <div className="grid grid-cols-1 md:grid-cols-12 divide-y md:divide-y-0 md:divide-x divide-border">
                    
                    {/* Column 1: Sighting details (Span 4) */}
                    <div className="p-4 md:col-span-4 flex gap-3">
                      {/* Image Thumbnail */}
                      <div className="size-16 rounded-lg bg-muted overflow-hidden shrink-0 border border-border flex items-center justify-center text-xl">
                        {obs?.primary_image_url ? (
                          <img src={obs.primary_image_url} alt="" className="size-full object-cover" />
                        ) : (
                          "🦋"
                        )}
                      </div>
                      <div className="min-w-0 flex flex-col justify-between py-0.5">
                        <div>
                          <div className="flex items-center gap-1.5 flex-wrap">
                            <Link 
                              href={`/observations/${result.observation_id}`} 
                              className="text-sm font-semibold hover:underline truncate max-w-[180px] block"
                            >
                              {obs?.title || "Untitled Observation"}
                            </Link>
                          </div>
                          <p className="text-xs text-muted-foreground truncate">
                            by @{obs?.user?.username || "anonymous"}
                          </p>
                          {obs?.location_name && (
                            <p className="text-[10px] text-muted-foreground truncate">
                              📍 {obs.location_name}
                            </p>
                          )}
                        </div>
                        {obsStatus && (
                          <span className={`text-[10px] font-semibold px-2 py-0.5 rounded-full w-max ${obsStatus.cls}`}>
                            {obsStatus.label}
                          </span>
                        )}
                      </div>
                    </div>

                    {/* Column 2: AI Execution Log (Span 4) */}
                    <div className="p-4 md:col-span-4 space-y-3 bg-muted/20">
                      <div className="flex items-start justify-between">
                        <div className="space-y-0.5">
                          <div className="flex items-center gap-1.5">
                            <StatusIcon status={result.status} />
                            <span className="text-[10px] font-mono text-muted-foreground truncate max-w-[150px] block">
                              ID: {result.id}
                            </span>
                          </div>
                          <p className="text-xs font-medium text-foreground">
                            {result.gemini_model_version || "Unknown Model"}
                          </p>
                        </div>
                        <div className="flex flex-col items-end">
                          <Badge variant="outline" className="text-[10px] font-semibold capitalize px-1.5 py-0">
                            {result.status}
                          </Badge>
                          {result.processing_time_ms && (
                            <span className="text-[10px] text-muted-foreground mt-1">
                              ⚡ {(result.processing_time_ms / 1000).toFixed(2)}s
                            </span>
                          )}
                        </div>
                      </div>

                      {/* Token Usage Metrics Grid */}
                      <div className="grid grid-cols-3 gap-1 bg-background/50 p-1.5 rounded-lg border border-border">
                        <div className="text-center">
                          <p className="text-[9px] text-muted-foreground uppercase font-semibold">Input</p>
                          <p className="text-xs font-mono font-bold text-blue-600 dark:text-blue-400">
                            {result.input_token_count?.toLocaleString() || "—"}
                          </p>
                        </div>
                        <div className="text-center border-x border-border">
                          <p className="text-[9px] text-muted-foreground uppercase font-semibold">Output</p>
                          <p className="text-xs font-mono font-bold text-green-600 dark:text-green-400">
                            {result.output_token_count?.toLocaleString() || "—"}
                          </p>
                        </div>
                        <div className="text-center">
                          <p className="text-[9px] text-muted-foreground uppercase font-semibold">Total</p>
                          <p className="text-xs font-mono font-bold text-purple-600 dark:text-purple-400">
                            {result.total_token_count?.toLocaleString() || "—"}
                          </p>
                        </div>
                      </div>
                    </div>

                    {/* Column 3: Predictions & Action (Span 4) */}
                    <div className="p-4 md:col-span-4 flex flex-col justify-center">
                      {result.error_message && (
                        <p className="text-xs text-destructive bg-destructive/10 px-2 py-1.5 rounded mb-2 border border-destructive/20 font-medium">
                          ⚠ {result.error_message}
                        </p>
                      )}
                      
                      {result.matches && result.matches.length > 0 ? (
                        <div className="space-y-1.5">
                          {result.matches.length > 1 && (
                            <p className="text-[9px] text-muted-foreground leading-snug">
                              AI suggested {result.matches.length} candidates — #1 is its top
                              match, the rest are similar-looking species it also considered.
                            </p>
                          )}
                          {result.matches.map((m) => (
                            <div
                              key={m.id}
                              className={`flex items-center gap-2 p-1.5 rounded-md border text-xs leading-none ${
                                m.is_accepted 
                                  ? "border-green-300 bg-green-50/50 dark:border-green-800 dark:bg-green-950/20" 
                                  : "border-border bg-background"
                              }`}
                            >
                              <span className="text-[10px] text-muted-foreground w-4 text-center font-bold">
                                #{m.rank}
                              </span>
                              <div className="flex-1 min-w-0 pr-1">
                                <p className="font-semibold text-[11px] truncate">{m.matched_common_name}</p>
                                <p className="text-[9px] text-muted-foreground italic truncate">
                                  {m.matched_scientific_name}
                                </p>
                              </div>
                              <span
                                className={`text-[8px] font-semibold uppercase tracking-wide px-1.5 py-0.5 rounded-full shrink-0 ${
                                  m.rank === 1
                                    ? "bg-primary/10 text-primary"
                                    : "bg-muted text-muted-foreground"
                                }`}
                              >
                                {m.rank === 1 ? "Top match" : "Alternative"}
                              </span>
                              <span className="font-bold text-[10px] text-primary shrink-0">
                                {Math.round(m.confidence_score * 100)}%
                              </span>
                            </div>
                          ))}
                        </div>
                      ) : (
                        !result.error_message && (
                          <p className="text-xs text-muted-foreground text-center py-2">
                            No identification matches returned.
                          </p>
                        )
                      )}

                      <div className="mt-3 flex items-center justify-between text-[9px] text-muted-foreground flex-wrap gap-2 pt-2 border-t border-border/60">
                        <span>Submitted {formatDistanceToNow(new Date(result.created_at), { addSuffix: true })}</span>
                        <Button variant="ghost" size="icon-xs" className="h-5 w-5 hover:bg-muted" asChild>
                          <Link href={`/observations/${result.observation_id}`}>
                            <Eye size={11} />
                          </Link>
                        </Button>
                      </div>
                    </div>

                  </div>
                </CardContent>
              </Card>
            );
          })}

          {/* Pagination */}
          {data?.meta && data.meta.pages > 1 && (
            <div className="flex items-center justify-between px-1 pt-4 border-t border-border/60">
              <p className="text-xs text-muted-foreground">
                Showing {(data.meta.page - 1) * data.meta.per_page + 1}–
                {Math.min(data.meta.page * data.meta.per_page, data.meta.total)} of {data.meta.total}
              </p>
              <div className="flex items-center gap-1">
                <Button
                  variant="outline"
                  size="icon-sm"
                  disabled={!data.meta.has_prev}
                  onClick={() => setPage(data.meta.page - 1)}
                >
                  <ChevronLeft size={14} />
                </Button>
                <span className="text-xs px-2">
                  {data.meta.page} / {data.meta.pages}
                </span>
                <Button
                  variant="outline"
                  size="icon-sm"
                  disabled={!data.meta.has_next}
                  onClick={() => setPage(data.meta.page + 1)}
                >
                  <ChevronRight size={14} />
                </Button>
              </div>
            </div>
          )}
        </div>
      )}
    </div>
  );
}
