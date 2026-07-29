"use client";

import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { Search, X } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Button } from "@/components/ui/button";
import { Skeleton } from "@/components/ui/skeleton";
import { SpeciesCard } from "@/components/species/species-card";
import api from "@/lib/api";
import type { ApiResponse, Species } from "@/types";

const FAMILIES = ["All", "Papilionidae", "Pieridae", "Nymphalidae", "Lycaenidae", "Hesperiidae", "Riodinidae"];

export default function SpeciesPage() {
  const [search, setSearch] = useState("");
  const [family, setFamily] = useState("All");
  const [page, setPage] = useState(1);

  const { data, isLoading } = useQuery({
    queryKey: ["species", search, family, page],
    queryFn: async () => {
      const params = new URLSearchParams({ page: String(page), per_page: "16" });
      if (search) params.set("search", search);
      if (family !== "All") params.set("family", family);
      const res = await api.get<ApiResponse<Species[]>>(`/species?${params}`);
      return res.data;
    },
  });

  const species = data?.data ?? [];
  const meta = data?.meta;

  return (
    <div className="container mx-auto px-4 py-8 space-y-6">
      <div>
        <h1 className="text-2xl font-bold">Species Field Guide</h1>
        <p className="text-sm text-muted-foreground">
          {meta ? `${meta.total} butterfly species documented in India` : "Browse all butterfly species"}
        </p>
      </div>

      {/* Filters */}
      <div className="flex flex-col sm:flex-row gap-3">
        <div className="relative flex-1 max-w-sm">
          <Search size={15} className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
          <Input placeholder="Search species name…" value={search}
            onChange={(e) => { setSearch(e.target.value); setPage(1); }} className="pl-9 pr-8" />
          {search && (
            <button onClick={() => { setSearch(""); setPage(1); }}
              className="absolute right-2.5 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground">
              <X size={14} />
            </button>
          )}
        </div>
        <Select value={family} onValueChange={(v) => { setFamily(v); setPage(1); }}>
          <SelectTrigger className="w-44">
            <SelectValue placeholder="Family" />
          </SelectTrigger>
          <SelectContent>
            {FAMILIES.map((f) => (
              <SelectItem key={f} value={f}>{f === "All" ? "All families" : f}</SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      {/* Grid */}
      {isLoading ? (
        <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-4">
          {Array.from({ length: 16 }).map((_, i) => (
            <Skeleton key={i} className="aspect-[4/3] rounded-lg" />
          ))}
        </div>
      ) : species.length === 0 ? (
        <div className="text-center py-20 text-muted-foreground">
          <div className="text-5xl mb-3">🔍</div>
          <p>No species found. Try adjusting your search.</p>
        </div>
      ) : (
        <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-4">
          {species.map((sp) => (
            <SpeciesCard key={sp.id} species={sp} />
          ))}
        </div>
      )}

      {/* Pagination */}
      {meta && meta.pages > 1 && (
        <div className="flex items-center justify-center gap-2 pt-4">
          <Button variant="outline" size="sm" disabled={!meta.has_prev}
            onClick={() => setPage((p) => p - 1)}>Previous</Button>
          <span className="text-sm text-muted-foreground">Page {meta.page} of {meta.pages}</span>
          <Button variant="outline" size="sm" disabled={!meta.has_next}
            onClick={() => setPage((p) => p + 1)}>Next</Button>
        </div>
      )}
    </div>
  );
}
