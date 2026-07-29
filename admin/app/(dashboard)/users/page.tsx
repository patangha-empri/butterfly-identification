"use client";

import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { formatDistanceToNow } from "date-fns";
import { MoreHorizontal, UserCheck, UserX, ShieldCheck } from "lucide-react";
import Link from "next/link";

import api, { apiErrorMessage } from "@/lib/api";
import { DataTable, type Column } from "@/components/shared/data-table";
import { SearchInput } from "@/components/shared/search-input";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
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
import type { ApiResponse, User, PaginationMeta } from "@/types";

const ROLE_COLORS: Record<string, string> = {
  super_admin: "bg-purple-100 text-purple-700 dark:bg-purple-900/30 dark:text-purple-300",
  admin: "bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-300",
  moderator: "bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-300",
  user: "bg-muted text-muted-foreground",
};

interface UsersResponse {
  users: User[];
  meta: PaginationMeta;
}

export default function UsersPage() {
  const qc = useQueryClient();
  const [page, setPage] = useState(1);
  const [search, setSearch] = useState("");
  const [role, setRole] = useState("all");

  const { data, isLoading } = useQuery({
    queryKey: ["users", page, search, role],
    queryFn: async () => {
      const params = new URLSearchParams({
        page: String(page),
        per_page: "20",
        ...(search && { search }),
        ...(role !== "all" && { role }),
      });
      const res = await api.get<ApiResponse<User[]>>(`/admin/users/?${params}`);
      return { users: res.data.data, meta: res.data.meta } as UsersResponse;
    },
  });

  const suspendMutation = useMutation({
    mutationFn: ({ id, suspend }: { id: string; suspend: boolean }) =>
      api.patch(`/admin/users/${id}/suspend`, { suspend }),
    onSuccess: () => {
      toast.success("User status updated.");
      qc.invalidateQueries({ queryKey: ["users"] });
    },
    onError: (err) => toast.error(apiErrorMessage(err)),
  });

  const roleMutation = useMutation({
    mutationFn: ({ id, roleName }: { id: string; roleName: string }) =>
      api.patch(`/admin/users/${id}/role`, { role: roleName }),
    onSuccess: () => {
      toast.success("Role updated.");
      qc.invalidateQueries({ queryKey: ["users"] });
    },
    onError: (err) => toast.error(apiErrorMessage(err)),
  });

  const columns: Column<User>[] = [
    {
      key: "user",
      header: "User",
      cell: (u) => (
        <div className="flex items-center gap-2.5">
          <Avatar className="size-7 shrink-0">
            <AvatarImage src={u.profile_image_url} />
            <AvatarFallback className="text-[10px]">
              {u.full_name?.slice(0, 2).toUpperCase()}
            </AvatarFallback>
          </Avatar>
          <div>
            <Link href={`/users/${u.id}`} className="text-sm font-medium hover:underline">
              {u.full_name}
            </Link>
            <p className="text-xs text-muted-foreground">{u.email}</p>
          </div>
        </div>
      ),
    },
    {
      key: "username",
      header: "Username",
      cell: (u) => <span className="text-xs text-muted-foreground">@{u.username}</span>,
    },
    {
      key: "role",
      header: "Role",
      cell: (u) => (
        <span
          className={`text-[11px] font-medium px-2 py-0.5 rounded-full ${ROLE_COLORS[u.role ?? "user"]}`}
        >
          {u.role ?? "user"}
        </span>
      ),
    },
    {
      key: "status",
      header: "Status",
      cell: (u) => (
        <div className="flex items-center gap-1 flex-wrap">
          <Badge variant={u.is_suspended ? "secondary" : "default"} className="text-xs">
            {u.is_suspended ? "Suspended" : "Active"}
          </Badge>
          {(u.active_warnings ?? 0) > 0 && (
            <span
              className="text-[11px] font-medium px-1.5 py-0.5 rounded-full bg-amber-100 text-amber-800"
              title={`${u.active_warnings} active warning(s)`}
            >
              ⚠ {u.active_warnings}
            </span>
          )}
          {(u.active_flags ?? 0) > 0 && (
            <span
              className="text-[11px] font-medium px-1.5 py-0.5 rounded-full bg-orange-100 text-orange-800"
              title={`${u.active_flags} active flag(s) — internal`}
            >
              🚩 {u.active_flags}
            </span>
          )}
        </div>
      ),
    },
    {
      key: "joined",
      header: "Joined",
      cell: (u) => (
        <span className="text-xs text-muted-foreground">
          {formatDistanceToNow(new Date(u.created_at), { addSuffix: true })}
        </span>
      ),
    },
    {
      key: "actions",
      header: "",
      className: "w-10",
      cell: (u) => (
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="ghost" size="icon-sm">
              <MoreHorizontal size={14} />
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end" className="w-44">
            <DropdownMenuItem asChild>
              <Link href={`/users/${u.id}`} className="gap-2">
                <UserCheck size={13} /> View profile
              </Link>
            </DropdownMenuItem>
            <DropdownMenuSeparator />
            <DropdownMenuItem
              className="gap-2"
              onClick={() => roleMutation.mutate({ id: u.id, roleName: "moderator" })}
            >
              <ShieldCheck size={13} /> Make moderator
            </DropdownMenuItem>
            <DropdownMenuSeparator />
            {!u.is_suspended ? (
              <DropdownMenuItem
                className="gap-2 text-destructive focus:text-destructive"
                onClick={() => suspendMutation.mutate({ id: u.id, suspend: true })}
              >
                <UserX size={13} /> Suspend user
              </DropdownMenuItem>
            ) : (
              <DropdownMenuItem
                className="gap-2"
                onClick={() => suspendMutation.mutate({ id: u.id, suspend: false })}
              >
                <UserCheck size={13} /> Unsuspend user
              </DropdownMenuItem>
            )}
          </DropdownMenuContent>
        </DropdownMenu>
      ),
    },
  ];

  return (
    <div className="p-4 md:p-6 space-y-4">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-base font-semibold">Users</h2>
          <p className="text-xs text-muted-foreground">
            {data?.meta?.total?.toLocaleString() ?? "—"} total registered users
          </p>
        </div>
      </div>

      {/* Filters */}
      <div className="flex items-center gap-2">
        <SearchInput
          value={search}
          onChange={(v) => { setSearch(v); setPage(1); }}
          placeholder="Search name, email, username…"
          className="max-w-72"
        />
        <Select value={role} onValueChange={(v) => { setRole(v); setPage(1); }}>
          <SelectTrigger className="h-8 w-36 text-xs">
            <SelectValue placeholder="All roles" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All roles</SelectItem>
            <SelectItem value="user">User</SelectItem>
            <SelectItem value="moderator">Moderator</SelectItem>
            <SelectItem value="admin">Admin</SelectItem>
          </SelectContent>
        </Select>
      </div>

      <DataTable
        columns={columns}
        data={data?.users ?? []}
        loading={isLoading}
        meta={data?.meta}
        onPageChange={setPage}
        emptyMessage="No users found."
      />
    </div>
  );
}
