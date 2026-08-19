"use client";

import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { Eye, EyeOff, Pencil, Plus, RotateCcw } from "lucide-react";
import { AppLink } from "@/components/shared/app-link";

import api from "@/lib/api";
import { DataTable, type Column } from "@/components/shared/data-table";
import { SearchInput } from "@/components/shared/search-input";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { SpeciesForm } from "@/components/species/species-form";
import { SpeciesStatusBadge } from "@/components/species/status-badge";
import { SpeciesStatusDialog } from "@/components/species/status-dialog";
import type { ApiResponse, Species, PaginationMeta } from "@/types";

type StatusFilter = "all" | "active" | "inactive";

export default function SpeciesPage() {
  const [page, setPage] = useState(1);
  const [search, setSearch] = useState("");
  const [status, setStatus] = useState<StatusFilter>("active");
  const [formOpen, setFormOpen] = useState(false);
  const [editing, setEditing] = useState<Species | null>(null);
  const [statusTarget, setStatusTarget] = useState<Species | null>(null);

  const { data, isLoading } = useQuery({
    queryKey: ["species", page, search, status],
    queryFn: async () => {
      const params = new URLSearchParams({
        page: String(page),
        per_page: "20",
        ...(search && { search }),
        ...(status !== "all" && { status }),
      });
      // /admin/species/ rather than the public /species/ — the public endpoint
      // filters is_active, so a deactivated species would vanish from the admin
      // panel and could never be found again to reactivate it.
      const res = await api.get<ApiResponse<Species[]>>(`/admin/species/?${params}`);
      return { species: res.data.data, meta: res.data.meta as PaginationMeta };
    },
  });

  // `editing`/`statusTarget` are snapshots taken at click time.
  const live = (s: Species | null) =>
    s ? (data?.species.find((row) => row.id === s.id) ?? s) : null;
  const editingLive = live(editing);
  const statusTargetLive = live(statusTarget);

  function openCreate() {
    setEditing(null);
    setFormOpen(true);
  }

  function openEdit(species: Species) {
    setEditing(species);
    setFormOpen(true);
  }

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
          <AppLink href={`/species/${s.id}`} className="text-sm font-medium hover:underline">
            {s.common_name}
          </AppLink>
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
      key: "app_status",
      header: "App visibility",
      cell: (s) => <SpeciesStatusBadge isActive={s.is_active} />,
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
      className: "w-36",
      cell: (s) => (
        <div className="flex items-center gap-0.5">
          <Button variant="ghost" size="icon-sm" asChild title="View details">
            <AppLink href={`/species/${s.id}`}>
              <Eye size={14} />
            </AppLink>
          </Button>
          <Button
            variant="ghost"
            size="icon-sm"
            title="Edit species"
            onClick={() => openEdit(s)}
          >
            <Pencil size={14} />
          </Button>
          <Button
            variant="ghost"
            size="icon-sm"
            title={
              s.is_active === false
                ? "Reactivate — show in the mobile app"
                : "Set inactive — hide from the mobile app"
            }
            onClick={() => setStatusTarget(s)}
          >
            {s.is_active === false ? (
              <RotateCcw size={14} className="text-green-600" />
            ) : (
              <EyeOff size={14} className="text-amber-600" />
            )}
          </Button>
        </div>
      ),
    },
  ];

  return (
    <div className="p-4 md:p-6 space-y-4">
      <div className="flex items-start justify-between gap-3">
        <div>
          <h2 className="text-base font-semibold">Species</h2>
          <p className="text-xs text-muted-foreground">
            {data?.meta?.total?.toLocaleString() ?? "—"} species
            {status !== "all" && ` (${status})`}
          </p>
        </div>
        <Button size="sm" onClick={openCreate}>
          <Plus size={14} className="mr-1" /> Add species
        </Button>
      </div>

      <div className="flex flex-wrap items-center gap-2">
        <SearchInput
          value={search}
          onChange={(v) => { setSearch(v); setPage(1); }}
          placeholder="Search common or scientific name…"
          className="max-w-72"
        />
        <Select
          value={status}
          onValueChange={(v) => { setStatus(v as StatusFilter); setPage(1); }}
        >
          <SelectTrigger className="w-44" aria-label="Filter by app visibility">
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="active">Active — in the app</SelectItem>
            <SelectItem value="inactive">Inactive — hidden</SelectItem>
            <SelectItem value="all">All species</SelectItem>
          </SelectContent>
        </Select>
      </div>

      <DataTable
        columns={columns}
        data={data?.species ?? []}
        loading={isLoading}
        meta={data?.meta}
        onPageChange={setPage}
        emptyMessage="No species found."
      />

      <Dialog open={formOpen} onOpenChange={setFormOpen}>
        <DialogContent className="max-h-[90vh] overflow-y-auto sm:max-w-3xl">
          <DialogHeader>
            <DialogTitle>{editingLive ? "Edit species" : "Add species"}</DialogTitle>
            <DialogDescription>
              Only the four fields marked with * are required. Everything else can be
              filled in now or later — sections are collapsed to keep this manageable.
            </DialogDescription>
          </DialogHeader>
          <SpeciesForm
            species={editingLive}
            onSaved={() => setFormOpen(false)}
            onCancel={() => setFormOpen(false)}
          />
        </DialogContent>
      </Dialog>

      <SpeciesStatusDialog
        species={statusTargetLive}
        open={Boolean(statusTarget)}
        onOpenChange={(o) => !o && setStatusTarget(null)}
      />
    </div>
  );
}
