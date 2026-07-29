"use client";

import { use, useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { format } from "date-fns";
import {
  AlertTriangle,
  ArrowLeft,
  Ban,
  Flag,
  History,
  ShieldCheck,
  Trash2,
  UserCheck,
  UserX,
} from "lucide-react";
import Link from "next/link";

import api, { apiErrorMessage } from "@/lib/api";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Separator } from "@/components/ui/separator";
import { Skeleton } from "@/components/ui/skeleton";
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import type { ApiResponse, ModerationAction, User } from "@/types";

const ACTION_STYLES: Record<string, { label: string; className: string }> = {
  warning: { label: "Warning", className: "bg-amber-100 text-amber-800" },
  flag: { label: "Flag", className: "bg-orange-100 text-orange-800" },
  suspension: { label: "Suspended", className: "bg-red-100 text-red-800" },
  unsuspension: { label: "Unsuspended", className: "bg-green-100 text-green-800" },
  content_removed: { label: "Content removed", className: "bg-slate-200 text-slate-800" },
};

export default function UserDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = use(params);
  const qc = useQueryClient();
  const [warnOpen, setWarnOpen] = useState(false);
  const [flagOpen, setFlagOpen] = useState(false);

  const { data: user, isLoading } = useQuery({
    queryKey: ["user", id],
    queryFn: async () => {
      const res = await api.get<ApiResponse<User>>(`/admin/users/${id}`);
      return res.data.data;
    },
  });

  const { data: history } = useQuery({
    queryKey: ["moderation-history", id],
    queryFn: async () => {
      const res = await api.get<ApiResponse<ModerationAction[]>>(
        `/admin/users/${id}/moderation-history`
      );
      return res.data.data ?? [];
    },
  });

  function invalidate() {
    qc.invalidateQueries({ queryKey: ["user", id] });
    qc.invalidateQueries({ queryKey: ["moderation-history", id] });
  }

  const suspendMutation = useMutation({
    mutationFn: ({ suspend, reason }: { suspend: boolean; reason?: string }) =>
      api.patch(`/admin/users/${id}/suspend`, { suspend, ...(reason ? { reason } : {}) }),
    onSuccess: () => {
      toast.success("User status updated. The user has been notified.");
      invalidate();
    },
    onError: (err) => toast.error(apiErrorMessage(err)),
  });

  const roleMutation = useMutation({
    mutationFn: (roleName: string) =>
      api.patch(`/admin/users/${id}/role`, { role: roleName }),
    onSuccess: () => {
      toast.success("Role updated. The user has been notified.");
      invalidate();
    },
    onError: (err) => toast.error(apiErrorMessage(err)),
  });

  const warnMutation = useMutation({
    mutationFn: (reason: string) => api.post(`/admin/users/${id}/warn`, { reason }),
    onSuccess: () => {
      toast.success("Warning issued. The user has been notified.");
      setWarnOpen(false);
      invalidate();
    },
    onError: (err) => toast.error(apiErrorMessage(err)),
  });

  const flagMutation = useMutation({
    mutationFn: (reason: string) => api.post(`/admin/users/${id}/flag`, { reason }),
    onSuccess: () => {
      toast.success("User flagged (internal only — the user is not notified).");
      setFlagOpen(false);
      invalidate();
    },
    onError: (err) => toast.error(apiErrorMessage(err)),
  });

  const revokeMutation = useMutation({
    mutationFn: (actionId: string) =>
      api.delete(`/admin/users/moderation-actions/${actionId}`),
    onSuccess: () => {
      toast.success("Moderation action revoked.");
      invalidate();
    },
    onError: (err) => toast.error(apiErrorMessage(err)),
  });

  function promptSuspend() {
    const reason = window.prompt(
      "Reason for suspending this user?\n" +
        "It is shown to them at login and in their notification."
    );
    if (reason === null) return; // cancelled
    suspendMutation.mutate({ suspend: true, reason: reason.trim() || undefined });
  }

  if (isLoading) {
    return (
      <div className="p-4 md:p-6 space-y-4">
        <Skeleton className="h-8 w-32" />
        <div className="grid md:grid-cols-3 gap-4">
          <Skeleton className="h-48" />
          <Skeleton className="h-48 md:col-span-2" />
        </div>
      </div>
    );
  }

  if (!user) return <div className="p-6 text-muted-foreground">User not found.</div>;

  const warnings = user.active_warnings ?? 0;
  const flags = user.active_flags ?? 0;

  return (
    <div className="p-4 md:p-6 space-y-4">
      <div className="flex items-center gap-2">
        <Button variant="ghost" size="sm" asChild>
          <Link href="/users">
            <ArrowLeft size={14} className="mr-1" /> Users
          </Link>
        </Button>
      </div>

      <div className="grid md:grid-cols-3 gap-4">
        {/* Profile card */}
        <Card>
          <CardContent className="pt-6 text-center space-y-3">
            <Avatar className="size-20 mx-auto">
              <AvatarImage src={user.profile_image_url} />
              <AvatarFallback className="text-xl">
                {user.full_name?.slice(0, 2).toUpperCase()}
              </AvatarFallback>
            </Avatar>
            <div>
              <p className="font-semibold">{user.full_name}</p>
              <p className="text-sm text-muted-foreground">@{user.username}</p>
              <p className="text-xs text-muted-foreground mt-0.5">{user.email}</p>
            </div>
            <div className="flex items-center justify-center gap-1.5 flex-wrap">
              <Badge variant={user.is_suspended ? "secondary" : "default"}>
                {user.is_suspended ? "Suspended" : "Active"}
              </Badge>
              {warnings > 0 && (
                <Badge className="bg-amber-500 hover:bg-amber-500">
                  ⚠ {warnings} warning{warnings > 1 ? "s" : ""}
                </Badge>
              )}
              {flags > 0 && (
                <Badge className="bg-orange-500 hover:bg-orange-500">
                  🚩 {flags} flag{flags > 1 ? "s" : ""}
                </Badge>
              )}
            </div>
            {user.bio && <p className="text-xs text-muted-foreground">{user.bio}</p>}
          </CardContent>
        </Card>

        {/* Details */}
        <div className="md:col-span-2 space-y-4">
          {/* Escalation hint */}
          {warnings >= 3 && !user.is_suspended && (
            <div className="flex items-center gap-2 p-3 rounded-lg border border-amber-300 bg-amber-50 dark:bg-amber-900/20 dark:border-amber-800 text-sm">
              <AlertTriangle size={16} className="text-amber-600 shrink-0" />
              <span>
                This user has <b>{warnings} active warnings</b> — consider a suspension.
              </span>
            </div>
          )}

          {/* Stats */}
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm">Activity Stats</CardTitle>
            </CardHeader>
            <CardContent className="grid grid-cols-2 gap-4">
              {[
                ["Observations", user.stats?.total_observations ?? 0],
                ["Identifications", user.stats?.total_identifications ?? 0],
                ["Current Streak", `${user.streak?.current_streak ?? 0} days`],
                ["Longest Streak", `${user.streak?.longest_streak ?? 0} days`],
                ["Species Observed", user.stats?.total_species_observed ?? 0],
                ["Total Points", user.stats?.total_points ?? 0],
              ].map(([label, val]) => (
                <div key={String(label)}>
                  <p className="text-xs text-muted-foreground">{label}</p>
                  <p className="text-xl font-bold">{val}</p>
                </div>
              ))}
            </CardContent>
          </Card>

          {/* Actions */}
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm">Admin Actions</CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              {/* Role change */}
              <div className="flex items-center gap-2">
                <ShieldCheck size={14} className="text-muted-foreground shrink-0" />
                <span className="text-sm flex-1">Role</span>
                <Select
                  value={user.role ?? "user"}
                  onValueChange={(v) => roleMutation.mutate(v)}
                >
                  <SelectTrigger className="h-8 w-36 text-xs">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {["user", "moderator", "admin"].map((r) => (
                      <SelectItem key={r} value={r} className="text-xs capitalize">
                        {r}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

              <Separator />

              <div className="grid grid-cols-2 gap-2">
                <Button
                  variant="outline"
                  size="sm"
                  className="gap-2 text-amber-600 hover:text-amber-700"
                  onClick={() => setWarnOpen(true)}
                  disabled={warnMutation.isPending}
                >
                  <AlertTriangle size={14} /> Warn User
                </Button>
                <Button
                  variant="outline"
                  size="sm"
                  className="gap-2 text-orange-600 hover:text-orange-700"
                  onClick={() => setFlagOpen(true)}
                  disabled={flagMutation.isPending}
                >
                  <Flag size={14} /> Flag User
                </Button>
              </div>

              {/* Suspend/Unsuspend */}
              {!user.is_suspended ? (
                <Button
                  variant="destructive"
                  size="sm"
                  className="w-full gap-2"
                  onClick={promptSuspend}
                  disabled={suspendMutation.isPending}
                >
                  <UserX size={14} /> Suspend User
                </Button>
              ) : (
                <Button
                  variant="outline"
                  size="sm"
                  className="w-full gap-2"
                  onClick={() => suspendMutation.mutate({ suspend: false })}
                  disabled={suspendMutation.isPending}
                >
                  <UserCheck size={14} /> Unsuspend User
                </Button>
              )}
            </CardContent>
          </Card>

          {/* Moderation history */}
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm flex items-center gap-2">
                <History size={14} /> Moderation History
              </CardTitle>
            </CardHeader>
            <CardContent>
              {(history ?? []).length === 0 ? (
                <p className="text-xs text-muted-foreground">
                  No moderation actions against this user.
                </p>
              ) : (
                <div className="space-y-2">
                  {(history ?? []).map((action) => {
                    const style = ACTION_STYLES[action.action_type] ?? {
                      label: action.action_type,
                      className: "bg-muted text-foreground",
                    };
                    const revocable =
                      !action.revoked_at &&
                      (action.action_type === "warning" || action.action_type === "flag");
                    return (
                      <div
                        key={action.id}
                        className={`flex items-start justify-between gap-2 p-2.5 rounded-lg border text-xs ${
                          action.revoked_at ? "opacity-50" : ""
                        }`}
                      >
                        <div className="min-w-0">
                          <div className="flex items-center gap-1.5 flex-wrap">
                            <span
                              className={`text-[10px] font-medium px-1.5 py-0.5 rounded-full ${style.className}`}
                            >
                              {style.label}
                            </span>
                            <span className="text-muted-foreground">
                              {format(new Date(action.created_at), "dd MMM yyyy HH:mm")}
                            </span>
                            {action.admin_username && (
                              <span className="text-muted-foreground">
                                by @{action.admin_username}
                              </span>
                            )}
                            {action.revoked_at && (
                              <Badge variant="outline" className="text-[10px]">
                                revoked
                              </Badge>
                            )}
                          </div>
                          {action.reason && <p className="mt-1">{action.reason}</p>}
                          {action.related_entity_type === "Observation" &&
                            action.related_entity_id && (
                              <Link
                                href={`/observations/${action.related_entity_id}`}
                                className="text-primary hover:underline mt-0.5 inline-block"
                              >
                                View related observation →
                              </Link>
                            )}
                        </div>
                        {revocable && (
                          <Button
                            variant="ghost"
                            size="xs"
                            className="shrink-0 text-muted-foreground"
                            title="Revoke this action"
                            onClick={() => revokeMutation.mutate(action.id)}
                            disabled={revokeMutation.isPending}
                          >
                            <Trash2 size={12} />
                          </Button>
                        )}
                      </div>
                    );
                  })}
                </div>
              )}
            </CardContent>
          </Card>

          {/* Meta */}
          <Card>
            <CardContent className="pt-4 space-y-1">
              {[
                ["User ID", user.id],
                ["Joined", format(new Date(user.created_at), "dd MMM yyyy HH:mm")],
                ["Email Verified", user.is_verified ? "Yes" : "No"],
              ].map(([label, val]) => (
                <div key={String(label)} className="flex justify-between text-xs">
                  <span className="text-muted-foreground">{label}</span>
                  <span className="font-mono">{val}</span>
                </div>
              ))}
            </CardContent>
          </Card>
        </div>
      </div>

      <ReasonDialog
        key={warnOpen ? "warn-open" : "warn-closed"}
        open={warnOpen}
        onOpenChange={setWarnOpen}
        title="Warn this user"
        description="The user receives a notification with this reason. Minimum 5 characters."
        confirmLabel="Issue Warning"
        confirmIcon={<AlertTriangle size={14} />}
        minLength={5}
        pending={warnMutation.isPending}
        onConfirm={(reason) => warnMutation.mutate(reason)}
      />

      <ReasonDialog
        key={flagOpen ? "flag-open" : "flag-closed"}
        open={flagOpen}
        onOpenChange={setFlagOpen}
        title="Flag this user (internal)"
        description="Flags are visible to staff only — the user is NOT notified."
        confirmLabel="Flag User"
        confirmIcon={<Flag size={14} />}
        minLength={3}
        pending={flagMutation.isPending}
        onConfirm={(reason) => flagMutation.mutate(reason)}
      />
    </div>
  );
}

function ReasonDialog({
  open,
  onOpenChange,
  title,
  description,
  confirmLabel,
  confirmIcon,
  minLength,
  pending,
  onConfirm,
}: {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  title: string;
  description: string;
  confirmLabel: string;
  confirmIcon: React.ReactNode;
  minLength: number;
  pending: boolean;
  onConfirm: (reason: string) => void;
}) {
  const [reason, setReason] = useState("");
  const tooShort = reason.trim().length < minLength;

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-md">
        <DialogHeader>
          <DialogTitle>{title}</DialogTitle>
        </DialogHeader>
        <div className="space-y-2">
          <p className="text-xs text-muted-foreground">{description}</p>
          <Label htmlFor="mod-reason" className="sr-only">
            Reason
          </Label>
          <Textarea
            id="mod-reason"
            value={reason}
            onChange={(e) => setReason(e.target.value)}
            rows={3}
            maxLength={500}
            placeholder="Reason…"
          />
        </div>
        <DialogFooter>
          <Button variant="outline" size="sm" onClick={() => onOpenChange(false)}>
            Cancel
          </Button>
          <Button
            size="sm"
            className="gap-2"
            onClick={() => onConfirm(reason.trim())}
            disabled={tooShort || pending}
          >
            {confirmIcon}
            {pending ? "Working…" : confirmLabel}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
