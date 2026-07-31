"use client";

import { use, useState } from "react";
import { useRouter } from "next/navigation";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { format, formatDistanceToNow } from "date-fns";
import {
  ArrowLeft,
  Bug,
  CheckCircle2,
  Cpu,
  Heart,
  Leaf,
  MapPin,
  Map as MapIcon,
  MessageCircle,
  Pencil,
  ShieldCheck,
  StickyNote,
  Trash2,
  User,
  XCircle,
} from "lucide-react";
import Link from "next/link";

import api, { apiErrorMessage } from "@/lib/api";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Skeleton } from "@/components/ui/skeleton";
import { Separator } from "@/components/ui/separator";
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import type {
  ApiResponse,
  Observation,
  IdentificationResult,
  ObservationSocial,
  Species,
} from "@/types";

const STATUS_COLORS: Record<string, string> = {
  pending: "bg-yellow-100 text-yellow-800",
  ai_identified: "bg-blue-100 text-blue-800",
  expert_verified: "bg-green-100 text-green-800",
  community_verified: "bg-emerald-100 text-emerald-800",
  rejected: "bg-red-100 text-red-800",
};

const MONTHS = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

function InfoRow({ label, value }: { label: string; value?: React.ReactNode }) {
  if (value === undefined || value === null || value === "") return null;
  return (
    <div className="flex justify-between gap-4 text-xs py-1">
      <span className="text-muted-foreground shrink-0">{label}</span>
      <span className="font-medium text-right">{value}</span>
    </div>
  );
}

export default function ObservationDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = use(params);
  const qc = useQueryClient();
  const router = useRouter();
  const [editOpen, setEditOpen] = useState(false);

  const { data: obs, isLoading } = useQuery({
    queryKey: ["observation", id],
    queryFn: async () => {
      // There is no /admin/observations/:id detail route; the public endpoint
      // returns full detail (staff bypass private visibility) for admins.
      const res = await api.get<ApiResponse<Observation>>(`/observations/${id}`);
      return res.data.data;
    },
  });

  const { data: idResult } = useQuery({
    queryKey: ["id-result", id],
    queryFn: async () => {
      try {
        const res = await api.get<ApiResponse<IdentificationResult>>(
          `/identifications/observations/${id}/result`
        );
        return res.data.data;
      } catch {
        return null;
      }
    },
    enabled: !!obs,
  });

  // Social — who liked, who commented
  const { data: social, isLoading: socialLoading } = useQuery({
    queryKey: ["observation-social", id],
    queryFn: async () => {
      const res = await api.get<ApiResponse<ObservationSocial>>(
        `/admin/observations/${id}/social`
      );
      return res.data.data;
    },
    enabled: !!obs,
  });

  // Species insights — same data the mobile app shows under an identification.
  const speciesId = obs?.species_id ?? obs?.identified_species_id;
  const { data: species } = useQuery({
    queryKey: ["species-detail", speciesId],
    queryFn: async () => {
      try {
        const res = await api.get<ApiResponse<Species>>(`/species/${speciesId}`);
        return res.data.data;
      } catch {
        return null;
      }
    },
    enabled: !!speciesId,
  });

  const verifyMutation = useMutation({
    mutationFn: () => api.patch(`/admin/observations/${id}/verify`),
    onSuccess: () => {
      toast.success("Observation verified.");
      qc.invalidateQueries({ queryKey: ["observation", id] });
    },
    onError: (err) => toast.error(apiErrorMessage(err)),
  });

  const rejectMutation = useMutation({
    mutationFn: (notes: string) =>
      api.patch(`/admin/observations/${id}/reject`, { admin_notes: notes }),
    onSuccess: () => {
      toast.success("Observation rejected.");
      qc.invalidateQueries({ queryKey: ["observation", id] });
    },
    onError: (err) => toast.error(apiErrorMessage(err)),
  });

  // Reject requires a reason (backend enforces min 5 chars).
  function promptReject() {
    const notes = window.prompt(
      "Reason for rejecting this observation?\n" +
        "The observer will be notified, and the sighting will be hidden from the community."
    );
    if (notes === null) return; // cancelled
    if (notes.trim().length < 5) {
      toast.error("Please provide a reason of at least 5 characters.");
      return;
    }
    rejectMutation.mutate(notes.trim());
  }

  const editMutation = useMutation({
    mutationFn: (body: Partial<Observation>) => api.put(`/observations/${id}`, body),
    onSuccess: () => {
      toast.success("Observation updated. The observer has been notified.");
      setEditOpen(false);
      qc.invalidateQueries({ queryKey: ["observation", id] });
    },
    onError: (err) => toast.error(apiErrorMessage(err)),
  });

  const deleteMutation = useMutation({
    mutationFn: (reason: string) =>
      api.delete(`/observations/${id}`, { data: reason ? { reason } : {} }),
    onSuccess: () => {
      toast.success("Observation deleted. The observer has been notified.");
      router.push("/observations");
    },
    onError: (err) => toast.error(apiErrorMessage(err)),
  });

  function promptDelete() {
    const reason = window.prompt(
      "Delete this observation?\n" +
        "This removes it for everyone. Enter a reason for the observer (optional):"
    );
    if (reason === null) return; // cancelled
    deleteMutation.mutate(reason.trim());
  }

  if (isLoading) {
    return (
      <div className="p-4 md:p-6 space-y-4">
        <Skeleton className="h-8 w-32" />
        <div className="grid md:grid-cols-3 gap-4">
          <Skeleton className="h-64 md:col-span-2" />
          <Skeleton className="h-64" />
        </div>
      </div>
    );
  }

  if (!obs) return <div className="p-6 text-muted-foreground">Observation not found.</div>;

  const statusInfo = STATUS_COLORS[obs.verification_status] ?? "";
  const locationText = [obs.location_name, obs.district_name, obs.state_name]
    .filter(Boolean)
    .join(", ");
  const flightMonths = (species?.flight_months ?? [])
    .filter((m) => m >= 1 && m <= 12)
    .map((m) => MONTHS[m - 1]);

  return (
    <div className="p-4 md:p-6 space-y-4">
      <Button variant="ghost" size="sm" asChild>
        <Link href="/observations">
          <ArrowLeft size={14} className="mr-1" /> Observations
        </Link>
      </Button>

      <div className="grid md:grid-cols-3 gap-4">
        {/* Main info */}
        <div className="md:col-span-2 space-y-4">
          {/* Images */}
          {obs.images && obs.images.length > 0 && (
            <Card>
              <CardContent className="pt-4">
                <div className="flex gap-2 overflow-x-auto">
                  {obs.images.map((img) => (
                    <img
                      key={img.id}
                      src={img.optimized_url ?? img.original_url}
                      alt="Observation"
                      className="h-48 w-auto rounded-lg object-cover shrink-0"
                    />
                  ))}
                </div>
              </CardContent>
            </Card>
          )}

          {/* Details */}
          <Card>
            <CardHeader className="pb-2">
              <div className="flex items-start justify-between gap-2">
                <CardTitle className="text-sm">
                  {obs.title || obs.identified_species_name || "Untitled Observation"}
                </CardTitle>
                <span className={`text-[11px] font-medium px-2 py-0.5 rounded-full shrink-0 ${statusInfo}`}>
                  {obs.verification_status.replace("_", " ")}
                </span>
              </div>
              {locationText && (
                <p className="text-xs text-muted-foreground flex items-center gap-1">
                  <MapPin size={12} /> {locationText}
                </p>
              )}
            </CardHeader>
            <CardContent className="space-y-2 text-sm">
              {obs.notes && <p className="text-muted-foreground">{obs.notes}</p>}

              {/* Same meta chips the mobile app shows */}
              <div className="flex flex-wrap gap-1.5 pt-1">
                {obs.weather && (
                  <Badge variant="secondary" className="text-xs capitalize">☀ {obs.weather}</Badge>
                )}
                {obs.butterfly_activity && (
                  <Badge variant="secondary" className="text-xs capitalize">
                    🦋 {obs.butterfly_activity}
                  </Badge>
                )}
                {obs.count_observed != null && (
                  <Badge variant="secondary" className="text-xs">
                    # {obs.count_observed} seen
                  </Badge>
                )}
              </div>

              <Separator />
              <div className="grid grid-cols-2 gap-y-1.5 text-xs">
                {[
                  ["Observer", `@${obs.user?.username ?? "anonymous"}`],
                  ["Coordinates", obs.latitude != null ? `${Number(obs.latitude).toFixed(4)}, ${Number(obs.longitude).toFixed(4)}` : "—"],
                  ["Privacy", obs.privacy?.replace("_", " ")],
                  ["Observed", obs.observed_at ? format(new Date(obs.observed_at), "dd MMM yyyy") : "—"],
                  ["Submitted", format(new Date(obs.created_at), "dd MMM yyyy HH:mm")],
                ].map(([k, v]) => (
                  <div key={k}>
                    <span className="text-muted-foreground">{k}: </span>
                    <span className="font-medium capitalize">{v}</span>
                  </div>
                ))}
              </div>

              <Separator />
              <div className="flex items-center gap-4 text-xs text-muted-foreground">
                <span className="flex items-center gap-1">
                  <Heart size={13} className="text-rose-500" />
                  <span className="font-medium text-foreground">{obs.like_count ?? 0}</span> likes
                </span>
                <span className="flex items-center gap-1">
                  <MessageCircle size={13} className="text-blue-500" />
                  <span className="font-medium text-foreground">{obs.comment_count ?? 0}</span> comments
                </span>
              </div>
            </CardContent>
          </Card>

          {/* AI Identification result — what the user sees in the app */}
          {(idResult || obs.identified_species_name) && (
            <Card>
              <CardHeader className="pb-2">
                <CardTitle className="text-sm flex items-center gap-2">
                  <Cpu size={14} /> AI Identification
                  <Badge variant="outline" className="text-xs ml-auto">
                    {idResult?.status ?? obs.identification_status ?? "—"}
                  </Badge>
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-2">
                {idResult?.error_message && (
                  <p className="text-xs text-destructive">{idResult.error_message}</p>
                )}

                {obs.identified_species_name && (
                  <div className="p-2.5 rounded-lg bg-muted/60">
                    <p className="text-xs text-muted-foreground">Identified as</p>
                    <p className="text-sm font-semibold">
                      {obs.identified_species_name}
                      {obs.identification_confidence != null && (
                        <span className="ml-2 text-primary font-bold">
                          {Math.round(obs.identification_confidence * 100)}%
                        </span>
                      )}
                    </p>
                    {obs.identification_reasoning && (
                      <p className="text-xs text-muted-foreground mt-1 leading-relaxed">
                        {obs.identification_reasoning}
                      </p>
                    )}
                  </div>
                )}

                {(idResult?.matches ?? []).length > 1 && (
                  <p className="text-[10px] text-muted-foreground leading-snug">
                    AI suggested {idResult!.matches.length} candidates — #1 is its top match,
                    the rest are similar-looking species it also considered.
                  </p>
                )}
                {(idResult?.matches ?? []).map((match) => (
                  <div
                    key={match.id}
                    className={`flex items-center justify-between p-2.5 rounded-lg border text-xs ${
                      match.is_accepted ? "bg-green-50 border-green-200 dark:bg-green-900/20 dark:border-green-800" : ""
                    }`}
                  >
                    <div>
                      <p className="font-medium">
                        #{match.rank} {match.matched_common_name}
                      </p>
                      <p className="text-muted-foreground italic">{match.matched_scientific_name}</p>
                    </div>
                    <div className="flex items-center gap-2 shrink-0">
                      <span
                        className={`text-[9px] font-semibold uppercase tracking-wide px-1.5 py-0.5 rounded-full ${
                          match.rank === 1
                            ? "bg-primary/10 text-primary"
                            : "bg-muted text-muted-foreground"
                        }`}
                      >
                        {match.rank === 1 ? "Top match" : "Alternative"}
                      </span>
                      <span className="font-semibold text-primary">
                        {Math.round(match.confidence_score * 100)}%
                      </span>
                    </div>
                  </div>
                ))}
                {idResult?.processing_time_ms && (
                  <p className="text-[10px] text-muted-foreground">
                    Processed in {idResult.processing_time_ms}ms · {idResult.gemini_model_version}
                  </p>
                )}
              </CardContent>
            </Card>
          )}

          {/* Species Insights — mirrors the app's insights card */}
          {species && (
            <Card>
              <CardHeader className="pb-2">
                <div className="flex items-start justify-between gap-2">
                  <CardTitle className="text-sm flex items-center gap-2">
                    <Bug size={14} /> Species Insights
                  </CardTitle>
                  <Button variant="ghost" size="sm" asChild className="h-6 text-xs -mt-0.5">
                    <Link href={`/species/${species.id}`}>View species →</Link>
                  </Button>
                </div>
                <p className="text-xs">
                  <span className="font-medium">{species.common_name}</span>{" "}
                  <span className="text-muted-foreground italic">{species.scientific_name}</span>
                </p>
              </CardHeader>
              <CardContent className="space-y-3">
                {species.description && (
                  <p className="text-xs text-muted-foreground leading-relaxed">
                    {species.description}
                  </p>
                )}

                <div className="grid sm:grid-cols-2 gap-x-6">
                  <div>
                    <p className="text-xs font-semibold flex items-center gap-1.5 mb-1">
                      <Bug size={12} /> Taxonomy
                    </p>
                    <InfoRow label="Family" value={species.family} />
                    <InfoRow label="Genus" value={species.genus} />
                    <InfoRow label="Wingspan" value={species.wingspan_mm || undefined} />
                  </div>
                  <div>
                    <p className="text-xs font-semibold flex items-center gap-1.5 mb-1">
                      <ShieldCheck size={12} /> Conservation & Season
                    </p>
                    <InfoRow label="Status" value={species.conservation_status} />
                    <InfoRow label="Rarity" value={species.rarity} />
                    <InfoRow
                      label="Flight months"
                      value={flightMonths.length > 0 ? flightMonths.join(", ") : undefined}
                    />
                  </div>
                </div>

                {species.habitat && (
                  <div>
                    <p className="text-xs font-semibold mb-1">Habitat</p>
                    <p className="text-xs text-muted-foreground">{species.habitat}</p>
                  </div>
                )}

                {(species.host_plants?.length ?? 0) > 0 && (
                  <div>
                    <p className="text-xs font-semibold flex items-center gap-1.5 mb-1">
                      <Leaf size={12} /> Host Plants
                    </p>
                    <p className="text-xs text-muted-foreground">
                      {species.host_plants!.map((p) => p.name).join(", ")}
                    </p>
                  </div>
                )}

                {(species.states?.length ?? 0) > 0 && (
                  <div>
                    <p className="text-xs font-semibold flex items-center gap-1.5 mb-1">
                      <MapIcon size={12} /> Distribution
                    </p>
                    <div className="flex flex-wrap gap-1">
                      {species.states!.map((s) => (
                        <Badge key={s} variant="outline" className="text-[10px]">{s}</Badge>
                      ))}
                    </div>
                  </div>
                )}
              </CardContent>
            </Card>
          )}

          {/* ── Likes & Comments ───────────────────────────────────────── */}
          <LikesAndComments social={social} isLoading={socialLoading} />
        </div>

        {/* Sidebar */}
        <div className="space-y-4">
          {/* Observer */}
          {obs.user && (
            <Card>
              <CardHeader className="pb-2">
                <CardTitle className="text-sm">Observer</CardTitle>
              </CardHeader>
              <CardContent className="flex items-center gap-2.5">
                <Avatar className="size-9">
                  <AvatarImage src={obs.user.profile_image_url} />
                  <AvatarFallback className="text-xs">
                    {obs.user.full_name?.slice(0, 2).toUpperCase()}
                  </AvatarFallback>
                </Avatar>
                <div className="min-w-0">
                  {obs.user_id ? (
                    <Link
                      href={`/users/${obs.user_id}`}
                      className="text-sm font-medium hover:underline block truncate"
                    >
                      {obs.user.full_name}
                    </Link>
                  ) : (
                    <p className="text-sm font-medium truncate">{obs.user.full_name}</p>
                  )}
                  <p className="text-xs text-muted-foreground truncate">@{obs.user.username}</p>
                </div>
              </CardContent>
            </Card>
          )}

          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm">Actions</CardTitle>
            </CardHeader>
            <CardContent className="space-y-2">
              {obs.identified_species_name && (
                <div className="p-2.5 bg-muted rounded-lg">
                  <p className="text-xs text-muted-foreground">Identified Species</p>
                  <p className="text-sm font-medium">{obs.identified_species_name}</p>
                  {species?.scientific_name && (
                    <p className="text-xs text-muted-foreground italic">
                      {species.scientific_name}
                    </p>
                  )}
                </div>
              )}

              <Button
                size="sm"
                className="w-full gap-2 bg-green-600 hover:bg-green-700"
                onClick={() => verifyMutation.mutate()}
                disabled={verifyMutation.isPending || obs.verification_status === "expert_verified"}
              >
                <CheckCircle2 size={14} />
                {obs.verification_status === "expert_verified" ? "Already Verified" : "Verify Observation"}
              </Button>

              <Button
                variant="destructive"
                size="sm"
                className="w-full gap-2"
                onClick={() => promptReject()}
                disabled={rejectMutation.isPending || obs.verification_status === "rejected"}
              >
                <XCircle size={14} />
                {obs.verification_status === "rejected" ? "Already Rejected" : "Reject Observation"}
              </Button>

              <Separator />

              <Button
                variant="outline"
                size="sm"
                className="w-full gap-2"
                onClick={() => setEditOpen(true)}
              >
                <Pencil size={14} /> Edit Details
              </Button>

              <Button
                variant="outline"
                size="sm"
                className="w-full gap-2 text-destructive hover:text-destructive"
                onClick={() => promptDelete()}
                disabled={deleteMutation.isPending}
              >
                <Trash2 size={14} /> Delete Observation
              </Button>
            </CardContent>
          </Card>

          {/* Moderation note (verify/reject reason) */}
          {obs.admin_notes && (
            <Card>
              <CardHeader className="pb-2">
                <CardTitle className="text-sm flex items-center gap-2">
                  <StickyNote size={14} /> Moderation Note
                </CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-xs text-muted-foreground leading-relaxed">
                  {obs.admin_notes}
                </p>
              </CardContent>
            </Card>
          )}

          <Card>
            <CardContent className="pt-4 space-y-1">
              {[
                ["ID", obs.id ? obs.id.slice(0, 8) + "…" : "—"],
                ["User ID", obs.user_id ? obs.user_id.slice(0, 8) + "…" : "—"],
                ["Images", obs.images?.length ?? 0],
              ].map(([k, v]) => (
                <div key={String(k)} className="flex justify-between text-xs">
                  <span className="text-muted-foreground">{k}</span>
                  <span className="font-mono">{v}</span>
                </div>
              ))}
            </CardContent>
          </Card>
        </div>
      </div>

      <EditObservationDialog
        key={editOpen ? "open" : "closed"} // remount per open → fresh field values
        open={editOpen}
        onOpenChange={setEditOpen}
        observation={obs}
        onSave={(body) => editMutation.mutate(body)}
        saving={editMutation.isPending}
      />
    </div>
  );
}

function EditObservationDialog({
  open,
  onOpenChange,
  observation,
  onSave,
  saving,
}: {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  observation: Observation;
  onSave: (body: Partial<Observation>) => void;
  saving: boolean;
}) {
  const [title, setTitle] = useState(observation.title ?? "");
  const [notes, setNotes] = useState(observation.notes ?? "");
  const [locationName, setLocationName] = useState(observation.location_name ?? "");
  const [countObserved, setCountObserved] = useState(String(observation.count_observed ?? 1));
  const [privacy, setPrivacy] = useState<string>(observation.privacy ?? "public");

  function handleSave() {
    const count = parseInt(countObserved, 10);
    onSave({
      title: title.trim(),
      notes: notes.trim(),
      location_name: locationName.trim(),
      count_observed: Number.isFinite(count) && count >= 1 ? count : 1,
      privacy: privacy as Observation["privacy"],
    });
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-md">
        <DialogHeader>
          <DialogTitle>Edit Observation</DialogTitle>
        </DialogHeader>
        <div className="space-y-3">
          <div className="space-y-1.5">
            <Label htmlFor="edit-title">Title</Label>
            <Input
              id="edit-title"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              maxLength={300}
            />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="edit-notes">Notes</Label>
            <Textarea
              id="edit-notes"
              value={notes}
              onChange={(e) => setNotes(e.target.value)}
              rows={3}
              maxLength={5000}
            />
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1.5">
              <Label htmlFor="edit-location">Location name</Label>
              <Input
                id="edit-location"
                value={locationName}
                onChange={(e) => setLocationName(e.target.value)}
                maxLength={500}
              />
            </div>
            <div className="space-y-1.5">
              <Label htmlFor="edit-count">Count observed</Label>
              <Input
                id="edit-count"
                type="number"
                min={1}
                max={9999}
                value={countObserved}
                onChange={(e) => setCountObserved(e.target.value)}
              />
            </div>
          </div>
          <div className="space-y-1.5">
            <Label>Privacy</Label>
            <Select value={privacy} onValueChange={setPrivacy}>
              <SelectTrigger className="w-full">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="public">Public</SelectItem>
                <SelectItem value="anonymous_public">Anonymous public</SelectItem>
                <SelectItem value="private">Private</SelectItem>
              </SelectContent>
            </Select>
          </div>
          <p className="text-xs text-muted-foreground">
            The observer will be notified that a moderator edited their sighting.
          </p>
        </div>
        <DialogFooter>
          <Button variant="outline" size="sm" onClick={() => onOpenChange(false)}>
            Cancel
          </Button>
          <Button size="sm" onClick={handleSave} disabled={saving}>
            {saving ? "Saving…" : "Save Changes"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// ── LikesAndComments ──────────────────────────────────────────────────────────
function UserChip({
  user,
  sub,
}: {
  user: { id: string; username?: string | null; full_name?: string | null; profile_image_url?: string | null } | null;
  sub?: string;
}) {
  if (!user) return <span className="text-muted-foreground text-xs italic">Unknown user</span>;
  const initials = user.full_name?.slice(0, 2).toUpperCase() ?? "?";
  return (
    <Link href={`/users/${user.id}`} className="flex items-center gap-2 group hover:opacity-80 transition-opacity">
      <Avatar className="size-7 shrink-0">
        <AvatarImage src={user.profile_image_url ?? undefined} />
        <AvatarFallback className="text-[10px]">{initials}</AvatarFallback>
      </Avatar>
      <div className="min-w-0">
        <p className="text-xs font-medium leading-tight truncate group-hover:underline">
          {user.full_name ?? user.username ?? "—"}
        </p>
        {user.username && (
          <p className="text-[10px] text-muted-foreground leading-tight">@{user.username}</p>
        )}
        {sub && <p className="text-[10px] text-muted-foreground leading-tight">{sub}</p>}
      </div>
    </Link>
  );
}

function LikesAndComments({
  social,
  isLoading,
}: {
  social?: ObservationSocial;
  isLoading: boolean;
}) {
  const [tab, setTab] = useState<"likes" | "comments">("likes");

  return (
    <Card>
      <CardHeader className="pb-0">
        {/* Tab headers */}
        <div className="flex gap-0 border-b">
          <button
            className={`flex items-center gap-1.5 px-3 py-2 text-xs font-medium border-b-2 transition-colors ${
              tab === "likes"
                ? "border-rose-500 text-rose-600"
                : "border-transparent text-muted-foreground hover:text-foreground"
            }`}
            onClick={() => setTab("likes")}
          >
            <Heart size={13} className={tab === "likes" ? "text-rose-500" : ""} />
            Likes
            {social && (
              <span className={`ml-0.5 rounded-full px-1.5 py-0.5 text-[10px] font-semibold ${
                tab === "likes" ? "bg-rose-100 text-rose-700" : "bg-muted text-muted-foreground"
              }`}>
                {social.like_count}
              </span>
            )}
          </button>
          <button
            className={`flex items-center gap-1.5 px-3 py-2 text-xs font-medium border-b-2 transition-colors ${
              tab === "comments"
                ? "border-blue-500 text-blue-600"
                : "border-transparent text-muted-foreground hover:text-foreground"
            }`}
            onClick={() => setTab("comments")}
          >
            <MessageCircle size={13} className={tab === "comments" ? "text-blue-500" : ""} />
            Comments
            {social && (
              <span className={`ml-0.5 rounded-full px-1.5 py-0.5 text-[10px] font-semibold ${
                tab === "comments" ? "bg-blue-100 text-blue-700" : "bg-muted text-muted-foreground"
              }`}>
                {social.comment_count}
              </span>
            )}
          </button>
        </div>
      </CardHeader>

      <CardContent className="pt-3">
        {isLoading && (
          <div className="space-y-2">
            {[1, 2, 3].map((i) => (
              <div key={i} className="flex items-center gap-2">
                <Skeleton className="size-7 rounded-full" />
                <div className="space-y-1 flex-1">
                  <Skeleton className="h-3 w-24" />
                  <Skeleton className="h-2 w-16" />
                </div>
              </div>
            ))}
          </div>
        )}

        {!isLoading && tab === "likes" && (
          <>
            {(!social || social.likers.length === 0) ? (
              <div className="flex flex-col items-center justify-center py-6 text-center gap-2">
                <Heart size={24} className="text-muted-foreground/40" />
                <p className="text-xs text-muted-foreground">No likes yet.</p>
              </div>
            ) : (
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-x-4 gap-y-3">
                {social.likers.map((liker, i) => (
                  <div key={i} className="flex items-center justify-between gap-2">
                    <UserChip user={liker.user} />
                    <span className="text-[10px] text-muted-foreground shrink-0">
                      {formatDistanceToNow(new Date(liker.liked_at), { addSuffix: true })}
                    </span>
                  </div>
                ))}
              </div>
            )}
          </>
        )}

        {!isLoading && tab === "comments" && (
          <>
            {(!social || social.comments.length === 0) ? (
              <div className="flex flex-col items-center justify-center py-6 text-center gap-2">
                <MessageCircle size={24} className="text-muted-foreground/40" />
                <p className="text-xs text-muted-foreground">No comments yet.</p>
              </div>
            ) : (
              <div className="space-y-4">
                {social.comments.map((comment) => (
                  <div key={comment.id} className="flex gap-3">
                    {/* Avatar */}
                    {comment.user ? (
                      <Link href={`/users/${comment.user.id}`} className="shrink-0 hover:opacity-80">
                        <Avatar className="size-7">
                          <AvatarImage src={comment.user.profile_image_url ?? undefined} />
                          <AvatarFallback className="text-[10px]">
                            {comment.user.full_name?.slice(0, 2).toUpperCase() ?? "?"}
                          </AvatarFallback>
                        </Avatar>
                      </Link>
                    ) : (
                      <div className="size-7 rounded-full bg-muted flex items-center justify-center shrink-0">
                        <User size={12} className="text-muted-foreground" />
                      </div>
                    )}

                    {/* Bubble */}
                    <div className="flex-1 min-w-0 bg-muted/50 rounded-lg px-3 py-2">
                      <div className="flex items-baseline gap-2 mb-1">
                        {comment.user ? (
                          <Link
                            href={`/users/${comment.user.id}`}
                            className="text-xs font-semibold hover:underline truncate"
                          >
                            {comment.user.full_name ?? comment.user.username ?? "Unknown"}
                          </Link>
                        ) : (
                          <span className="text-xs font-semibold text-muted-foreground">Unknown</span>
                        )}
                        {comment.user?.username && (
                          <span className="text-[10px] text-muted-foreground">
                            @{comment.user.username}
                          </span>
                        )}
                        <span className="text-[10px] text-muted-foreground ml-auto shrink-0">
                          {formatDistanceToNow(new Date(comment.created_at), { addSuffix: true })}
                        </span>
                      </div>
                      <p className="text-xs leading-relaxed text-foreground break-words">
                        {comment.body}
                      </p>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </>
        )}
      </CardContent>
    </Card>
  );
}
