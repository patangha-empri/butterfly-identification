"use client";

import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { Search, X, MapIcon, GridIcon } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Skeleton } from "@/components/ui/skeleton";
import { SightingCard } from "@/components/sightings/sighting-card";
import { DynamicMap } from "@/components/map/dynamic-map";
import api from "@/lib/api";
import type { ApiResponse, Observation } from "@/types";

type View = "grid" | "map";

export default function SightingsPage() {
  const [view, setView] = useState<View>("grid");
  const [search, setSearch] = useState("");
  const [status, setStatus] = useState("all");
  const [page, setPage] = useState(1);

  const { data, isLoading } = useQuery({
    queryKey: ["observations", search, status, page],
    queryFn: async () => {
      const params = new URLSearchParams({
        page: String(page),
        per_page: "12",
        sort: "created_at",
        order: "desc",
      });
      if (search) params.set("search", search);
      if (status !== "all") params.set("status", status);
      const res = await api.get<ApiResponse<Observation[]>>(`/observations?${params}`);
      return res.data;
    },
  });

  const observations = data?.data ?? [];
  const meta = data?.meta;

  return (
    <div className="container mx-auto px-4 py-8 space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold">Sightings</h1>
          <p className="text-sm text-muted-foreground">
            {meta ? `${meta.total.toLocaleString("en-IN")} observations across India` : "Explore butterfly observations"}
          </p>
        </div>
        <div className="flex items-center gap-2">
          <Button
            variant={view === "grid" ? "default" : "outline"}
            size="sm"
            onClick={() => setView("grid")}
            className="gap-1.5"
          >
            <GridIcon size={14} /> Grid
          </Button>
          <Button
            variant={view === "map" ? "default" : "outline"}
            size="sm"
            onClick={() => setView("map")}
            className="gap-1.5"
          >
            <MapIcon size={14} /> Map
          </Button>
        </div>
      </div>

      {/* Filters */}
      <div className="flex flex-col sm:flex-row gap-3">
        <div className="relative flex-1 max-w-sm">
          <Search size={15} className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
          <Input
            placeholder="Search species, location…"
            value={search}
            onChange={(e) => { setSearch(e.target.value); setPage(1); }}
            className="pl-9 pr-8"
          />
          {search && (
            <button onClick={() => { setSearch(""); setPage(1); }}
              className="absolute right-2.5 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground">
              <X size={14} />
            </button>
          )}
        </div>
        <Select value={status} onValueChange={(v) => { setStatus(v); setPage(1); }}>
          <SelectTrigger className="w-48">
            <SelectValue placeholder="Status" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All statuses</SelectItem>
            <SelectItem value="pending">Pending</SelectItem>
            <SelectItem value="ai_identified">AI Identified</SelectItem>
            <SelectItem value="expert_verified">Expert Verified</SelectItem>
            <SelectItem value="community_verified">Community Verified</SelectItem>
          </SelectContent>
        </Select>
      </div>

      {/* Map view */}
      {view === "map" && (
        <div className="h-[500px]">
          {isLoading ? (
            <Skeleton className="w-full h-full rounded-lg" />
          ) : (
            <DynamicMap observations={observations} className="w-full h-full" />
          )}
        </div>
      )}

      {/* Grid view */}
      {view === "grid" && (
        <>
          {isLoading ? (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
              {Array.from({ length: 12 }).map((_, i) => (
                <Skeleton key={i} className="aspect-[4/3] rounded-lg" />
              ))}
            </div>
          ) : observations.length === 0 ? (
            <div className="text-center py-20 text-muted-foreground">
              <div className="text-5xl mb-3">🔍</div>
              <p>No sightings found. Try adjusting your filters.</p>
            </div>
          ) : (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
              {observations.map((obs) => (
                <SightingCard key={obs.id} observation={obs} />
              ))}
            </div>
          )}

          {/* Pagination */}
          {meta && meta.pages > 1 && (
            <div className="flex items-center justify-center gap-2 pt-4">
              <Button variant="outline" size="sm" disabled={!meta.has_prev}
                onClick={() => setPage((p) => p - 1)}>
                Previous
              </Button>
              <span className="text-sm text-muted-foreground">
                Page {meta.page} of {meta.pages}
              </span>
              <Button variant="outline" size="sm" disabled={!meta.has_next}
                onClick={() => setPage((p) => p + 1)}>
                Next
              </Button>
            </div>
          )}
        </>
      )}
    </div>
  );
}
