"use client";

import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { formatDistanceToNow } from "date-fns";
import { MoreHorizontal, CheckCircle2, XCircle, Eye } from "lucide-react";
import Link from "next/link";

import api, { apiErrorMessage } from "@/lib/api";
import { DataTable, type Column } from "@/components/shared/data-table";
import { SearchInput } from "@/components/shared/search-input";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import type { ApiResponse, Observation, PaginationMeta } from "@/types";

const STATUS_LABELS: Record<string, { label: string; cls: string }> = {
  pending: { label: "Pending", cls: "bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-400" },
  ai_identified: { label: "AI Identified", cls: "bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400" },
  expert_verified: { label: "Expert Verified", cls: "bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400" },
  community_verified: { label: "Community Verified", cls: "bg-emerald-100 text-emerald-800 dark:bg-emerald-900/30 dark:text-emerald-400" },
  rejected: { label: "Rejected", cls: "bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400" },
};

// An observation with no title, no species, and no photo has nothing to
// moderate — hide these empty records so the table stays clean.
function hasContent(o: Observation): boolean {
  return Boolean(
    o.title ||
    o.identified_species_name ||
    o.species_id ||
    o.primary_image_url ||
    (o.images?.length ?? 0) > 0
  );
}

export default function ObservationsPage() {
  const qc = useQueryClient();
  const [page, setPage] = useState(1);
  const [search, setSearch] = useState("");
  const [status, setStatus] = useState("all");

  const { data, isLoading } = useQuery({
    queryKey: ["admin-observations", page, search, status],
    queryFn: async () => {
      const params = new URLSearchParams({
        page: String(page),
        per_page: "20",
        ...(search && { search }),
        ...(status !== "all" && { verification_status: status }),
      });
      const res = await api.get<ApiResponse<Observation[]>>(`/admin/observations/?${params}`);
      return { observations: res.data.data, meta: res.data.meta as PaginationMeta };
    },
  });

  const verifyMutation = useMutation({
    mutationFn: (id: string) => api.patch(`/admin/observations/${id}/verify`),
    onSuccess: () => {
      toast.success("Observation verified.");
      qc.invalidateQueries({ queryKey: ["admin-observations"] });
    },
    onError: (err) => toast.error(apiErrorMessage(err)),
  });

  const rejectMutation = useMutation({
    mutationFn: ({ id, notes }: { id: string; notes: string }) =>
      api.patch(`/admin/observations/${id}/reject`, { admin_notes: notes }),
    onSuccess: () => {
      toast.success("Observation rejected.");
      qc.invalidateQueries({ queryKey: ["admin-observations"] });
    },
    onError: (err) => toast.error(apiErrorMessage(err)),
  });

  // Reject requires a reason (backend enforces min 5 chars).
  function promptReject(id: string) {
    const notes = window.prompt("Reason for rejecting this observation?");
    if (notes === null) return; // cancelled
    if (notes.trim().length < 5) {
      toast.error("Please provide a reason of at least 5 characters.");
      return;
    }
    rejectMutation.mutate({ id, notes: notes.trim() });
  }

  const columns: Column<Observation>[] = [
    {
      key: "image",
      header: "",
      className: "w-10",
      cell: (o) => (
        <div className="size-9 rounded-lg bg-muted overflow-hidden shrink-0">
          {o.primary_image_url ? (
            <img src={o.primary_image_url} alt="" className="size-full object-cover" />
          ) : (
            <div className="size-full flex items-center justify-center text-base">🦋</div>
          )}
        </div>
      ),
    },
    {
      key: "obs",
      header: "Observation",
      cell: (o) => (
        <div>
          <Link href={`/observations/${o.id}`} className="text-sm font-medium hover:underline">
            {o.title || o.identified_species_name || "Untitled observation"}
          </Link>
          <p className="text-xs text-muted-foreground">
            by @{o.user?.username ?? "anonymous"}
            {o.state_name ? ` · ${o.state_name}` : ""}
          </p>
        </div>
      ),
    },
    {
      key: "species",
      header: "Species",
      cell: (o) =>
        o.identified_species_name ? (
          <div>
            <p className="text-xs font-medium">{o.identified_species_name}</p>
            {o.identification_confidence != null && (
              <p className="text-[10px] text-muted-foreground">
                {Math.round(o.identification_confidence * 100)}% confidence
              </p>
            )}
          </div>
        ) : (
          <span className="text-xs text-muted-foreground">—</span>
        ),
    },
    {
      key: "status",
      header: "Status",
      cell: (o) => {
        const s = STATUS_LABELS[o.verification_status] ?? { label: o.verification_status, cls: "" };
        return (
          <span className={`text-[11px] font-medium px-2 py-0.5 rounded-full ${s.cls}`}>
            {s.label}
          </span>
        );
      },
    },
    {
      key: "privacy",
      header: "Privacy",
      cell: (o) => (
        <Badge variant="outline" className="text-xs capitalize">
          {o.privacy?.replace("_", " ")}
        </Badge>
      ),
    },
    {
      key: "date",
      header: "Submitted",
      cell: (o) => (
        <span className="text-xs text-muted-foreground">
          {formatDistanceToNow(new Date(o.created_at), { addSuffix: true })}
        </span>
      ),
    },
    {
      key: "actions",
      header: "",
      className: "w-10",
      cell: (o) => (
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="ghost" size="icon-sm">
              <MoreHorizontal size={14} />
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end" className="w-44">
            <DropdownMenuItem asChild>
              <Link href={`/observations/${o.id}`} className="gap-2">
                <Eye size={13} /> View details
              </Link>
            </DropdownMenuItem>
            <DropdownMenuSeparator />
            <DropdownMenuItem
              className="gap-2 text-green-600 focus:text-green-600"
              onClick={() => verifyMutation.mutate(o.id)}
            >
              <CheckCircle2 size={13} /> Verify
            </DropdownMenuItem>
            <DropdownMenuItem
              className="gap-2 text-destructive focus:text-destructive"
              onClick={() => promptReject(o.id)}
            >
              <XCircle size={13} /> Reject
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      ),
    },
  ];

  return (
    <div className="p-4 md:p-6 space-y-4">
      <div>
        <h2 className="text-base font-semibold">Observations</h2>
        <p className="text-xs text-muted-foreground">
          {data?.meta?.total?.toLocaleString() ?? "—"} total observations
        </p>
      </div>

      <div className="flex items-center gap-2">
        <SearchInput
          value={search}
          onChange={(v) => { setSearch(v); setPage(1); }}
          placeholder="Search title, notes, location…"
          className="max-w-72"
        />
        <Select value={status} onValueChange={(v) => { setStatus(v); setPage(1); }}>
          <SelectTrigger className="h-8 w-44 text-xs">
            <SelectValue placeholder="All statuses" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All statuses</SelectItem>
            <SelectItem value="pending">Pending</SelectItem>
            <SelectItem value="ai_identified">AI Identified</SelectItem>
            <SelectItem value="expert_verified">Expert Verified</SelectItem>
            <SelectItem value="rejected">Rejected</SelectItem>
          </SelectContent>
        </Select>
      </div>

      <DataTable
        columns={columns}
        data={(data?.observations ?? []).filter(hasContent)}
        loading={isLoading}
        meta={data?.meta}
        onPageChange={setPage}
        emptyMessage="No observations found."
      />
    </div>
  );
}
