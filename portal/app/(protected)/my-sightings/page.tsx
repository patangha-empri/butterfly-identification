"use client";

import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import Link from "next/link";
import { PlusCircle } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Skeleton } from "@/components/ui/skeleton";
import { SightingCard } from "@/components/sightings/sighting-card";
import api from "@/lib/api";
import type { ApiResponse, Observation } from "@/types";

export default function MySightingsPage() {
  const [status, setStatus] = useState("all");
  const [page, setPage] = useState(1);

  const { data, isLoading } = useQuery({
    queryKey: ["my-observations", status, page],
    queryFn: async () => {
      const params = new URLSearchParams({ page: String(page), per_page: "12", mine: "true" });
      if (status !== "all") params.set("status", status);
      const res = await api.get<ApiResponse<Observation[]>>(`/observations?${params}`);
      return res.data;
    },
  });

  const observations = data?.data ?? [];
  const meta = data?.meta;

  return (
    <div className="container mx-auto px-4 py-8 space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold">My Sightings</h1>
          <p className="text-sm text-muted-foreground">
            {meta ? `${meta.total} observations submitted` : "Your butterfly observations"}
          </p>
        </div>
        <Button asChild className="gap-2">
          <Link href="/submit"><PlusCircle size={15} /> New Sighting</Link>
        </Button>
      </div>

      {/* Filter */}
      <Select value={status} onValueChange={(v) => { setStatus(v); setPage(1); }}>
        <SelectTrigger className="w-48">
          <SelectValue placeholder="Filter by status" />
        </SelectTrigger>
        <SelectContent>
          <SelectItem value="all">All statuses</SelectItem>
          <SelectItem value="pending">Pending</SelectItem>
          <SelectItem value="ai_identified">AI Identified</SelectItem>
          <SelectItem value="expert_verified">Expert Verified</SelectItem>
          <SelectItem value="community_verified">Community Verified</SelectItem>
          <SelectItem value="rejected">Rejected</SelectItem>
        </SelectContent>
      </Select>

      {isLoading ? (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          {Array.from({ length: 6 }).map((_, i) => <Skeleton key={i} className="aspect-[4/3] rounded-lg" />)}
        </div>
      ) : observations.length === 0 ? (
        <div className="text-center py-20 space-y-4">
          <div className="text-6xl">🦋</div>
          <p className="text-muted-foreground">No sightings yet.</p>
          <Button asChild><Link href="/submit">Submit your first sighting</Link></Button>
        </div>
      ) : (
        <>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
            {observations.map((obs) => <SightingCard key={obs.id} observation={obs} />)}
          </div>
          {meta && meta.pages > 1 && (
            <div className="flex items-center justify-center gap-2 pt-4">
              <Button variant="outline" size="sm" disabled={!meta.has_prev} onClick={() => setPage((p) => p - 1)}>Previous</Button>
              <span className="text-sm text-muted-foreground">Page {meta.page} of {meta.pages}</span>
              <Button variant="outline" size="sm" disabled={!meta.has_next} onClick={() => setPage((p) => p + 1)}>Next</Button>
            </div>
          )}
        </>
      )}
    </div>
  );
}
