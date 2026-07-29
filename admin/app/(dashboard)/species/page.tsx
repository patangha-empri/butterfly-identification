"use client";

import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { Eye } from "lucide-react";
import Link from "next/link";

import api from "@/lib/api";
import { DataTable, type Column } from "@/components/shared/data-table";
import { SearchInput } from "@/components/shared/search-input";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import type { ApiResponse, Species, PaginationMeta } from "@/types";

export default function SpeciesPage() {
  const [page, setPage] = useState(1);
  const [search, setSearch] = useState("");

  const { data, isLoading } = useQuery({
    queryKey: ["species", page, search],
    queryFn: async () => {
      const params = new URLSearchParams({
        page: String(page),
        per_page: "20",
        ...(search && { search }),
      });
      const res = await api.get<ApiResponse<Species[]>>(`/species/?${params}`);
      return { species: res.data.data, meta: res.data.meta as PaginationMeta };
    },
  });

  const columns: Column<Species>[] = [
    {
      key: "image",
      header: "",
      className: "w-10",
      cell: (s) => {
        const thumb = s.primary_image?.thumbnail_url ?? s.primary_image_url;
        return (
          <div className="size-9 rounded-lg bg-muted overflow-hidden shrink-0">
            {thumb ? (
              <img src={thumb} alt={s.common_name} className="size-full object-cover" />
            ) : (
              <div className="size-full flex items-center justify-center text-base">🦋</div>
            )}
          </div>
        );
      },
    },
    {
      key: "name",
      header: "Species",
      cell: (s) => (
        <div>
          <Link href={`/species/${s.id}`} className="text-sm font-medium hover:underline">
            {s.common_name}
          </Link>
          <p className="text-xs text-muted-foreground italic">{s.scientific_name}</p>
        </div>
      ),
    },
    {
      key: "family",
      header: "Family",
      cell: (s) => <span className="text-xs text-muted-foreground">{s.family}</span>,
    },
    {
      key: "wingspan",
      header: "Wingspan",
      cell: (s) =>
        s.wingspan_mm ? (
          <span className="text-xs">{s.wingspan_mm}</span>
        ) : (
          <span className="text-xs text-muted-foreground">—</span>
        ),
    },
    {
      key: "status",
      header: "Conservation",
      cell: (s) =>
        s.conservation_status ? (
          <Badge variant="outline" className="text-xs">{s.conservation_status}</Badge>
        ) : (
          <span className="text-xs text-muted-foreground">—</span>
        ),
    },
    {
      key: "observations",
      header: "Observations",
      cell: (s) => (
        <span className="text-xs font-medium">{s.observation_count ?? 0}</span>
      ),
    },
    {
      key: "actions",
      header: "",
      className: "w-10",
      cell: (s) => (
        <Button variant="ghost" size="icon-sm" asChild title="View details">
          <Link href={`/species/${s.id}`}>
            <Eye size={14} />
          </Link>
        </Button>
      ),
    },
  ];

  return (
    <div className="p-4 md:p-6 space-y-4">
      <div>
        <h2 className="text-base font-semibold">Species</h2>
        <p className="text-xs text-muted-foreground">
          {data?.meta?.total?.toLocaleString() ?? "—"} species in database
        </p>
      </div>

      <SearchInput
        value={search}
        onChange={(v) => { setSearch(v); setPage(1); }}
        placeholder="Search common or scientific name…"
        className="max-w-72"
      />

      <DataTable
        columns={columns}
        data={data?.species ?? []}
        loading={isLoading}
        meta={data?.meta}
        onPageChange={setPage}
        emptyMessage="No species found."
      />
    </div>
  );
}
