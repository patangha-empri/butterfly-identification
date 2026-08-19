"use client";

import { use, useState } from "react";
import { usePathname } from "next/navigation";
import { useQuery } from "@tanstack/react-query";
import {
  ArrowLeft, Bug, EyeOff, Leaf, Map as MapIcon, Pencil, RotateCcw, ShieldCheck, Trash2,
} from "lucide-react";
import { AppLink } from "@/components/shared/app-link";

import api from "@/lib/api";
import { routeId } from "@/lib/navigation";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Separator } from "@/components/ui/separator";
import { Skeleton } from "@/components/ui/skeleton";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { SpeciesForm } from "@/components/species/species-form";
import { SpeciesStatusBadge } from "@/components/species/status-badge";
import { SpeciesStatusDialog } from "@/components/species/status-dialog";
import { SpeciesDetailSections } from "@/components/species/detail-sections";
import { QueryError } from "@/components/shared/query-error";
import type { ApiResponse, Species } from "@/types";

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

export default function SpeciesDetailPage({ params }: { params: Promise<{ id: string }> }) {
  // See observations/[id]/page_client.tsx — params.id is the exported "id"
  // placeholder; the real id comes from the rewritten URL.
  const { id: fallbackId } = use(params);
  const id = routeId(usePathname(), fallbackId);

  const [formOpen, setFormOpen] = useState(false);
  const [statusOpen, setStatusOpen] = useState(false);
  const [deleteOpen, setDeleteOpen] = useState(false);

  const { data: species, isLoading, isError, error, refetch } = useQuery({
    queryKey: ["species-detail", id],
    queryFn: async () => {
      // The admin detail route, not the public /species/:id — the public one
      // filters is_active and would 404 on a deactivated species, leaving no way
      // to open it and reactivate it.
      const res = await api.get<ApiResponse<Species>>(`/admin/species/${id}`);
      return res.data.data;
    },
  });

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

  if (isError) return <QueryError error={error} entity="Species" onRetry={() => refetch()} />;
  if (!species) return <div className="p-6 text-muted-foreground">Species not found.</div>;

  const flightMonths = (species.flight_months ?? [])
    .filter((m) => m >= 1 && m <= 12)
    .map((m) => MONTHS[m - 1]);

  return (
    <div className="p-4 md:p-6 space-y-4">
      <div className="flex flex-wrap items-center justify-between gap-2">
        <div className="flex items-center gap-2">
          <Button variant="ghost" size="sm" asChild>
            <AppLink href="/species">
              <ArrowLeft size={14} className="mr-1" /> Species
            </AppLink>
          </Button>
          <SpeciesStatusBadge isActive={species.is_active} />
        </div>

        <div className="flex items-center gap-2">
          <Button variant="outline" size="sm" onClick={() => setFormOpen(true)}>
            <Pencil size={14} className="mr-1" /> Edit
          </Button>
          <Button
            variant={species.is_active === false ? "default" : "outline"}
            size="sm"
            onClick={() => setStatusOpen(true)}
          >
            {species.is_active === false ? (
              <><RotateCcw size={14} className="mr-1" /> Reactivate</>
            ) : (
              <><EyeOff size={14} className="mr-1" /> Set inactive</>
            )}
          </Button>
          <Button
            variant="outline"
            size="sm"
            className="text-red-600 hover:text-red-700 hover:bg-red-50 border-red-200"
            onClick={() => setDeleteOpen(true)}
          >
            <Trash2 size={14} className="mr-1" /> Delete
          </Button>
        </div>
      </div>

      {species.is_active === false && (
        <div className="rounded-lg border border-amber-300 bg-amber-50 p-3 text-xs text-amber-900">
          <p className="font-medium">This species is hidden from the mobile app.</p>
          <p className="mt-0.5 text-amber-800">
            It will not appear in species search, browsing or identification results.
            Its {species.observation_count ?? 0} existing observation
            {species.observation_count === 1 ? "" : "s"} are unaffected. Use{" "}
            <strong>Reactivate</strong> to make it visible again.
          </p>
        </div>
      )}

      <div className="grid md:grid-cols-3 gap-4">
        {/* Main info */}
        <div className="md:col-span-2 space-y-4">
          {/* Images */}
          {species.images && species.images.length > 0 && (
            <Card>
              <CardContent className="pt-4">
                <div className="flex gap-2 overflow-x-auto">
                  {species.images.map((img, i) => (
                    <figure key={i} className="shrink-0">
                      <img
                        src={img.image_url}
                        alt={img.caption ?? species.common_name}
                        className="h-48 w-auto rounded-lg object-cover"
                      />
                      {(img.image_type || img.credit) && (
                        <figcaption className="text-[10px] text-muted-foreground mt-1">
                          {[img.image_type, img.credit && `© ${img.credit}`]
                            .filter(Boolean)
                            .join(" · ")}
                        </figcaption>
                      )}
                    </figure>
                  ))}
                </div>
              </CardContent>
            </Card>
          )}

          {/* Identity + description */}
          <Card>
            <CardHeader className="pb-2">
              <div className="flex items-start justify-between gap-2">
                <div>
                  <CardTitle className="text-base">{species.common_name}</CardTitle>
                  <p className="text-sm text-muted-foreground italic">
                    {species.scientific_name}
                  </p>
                </div>
                <div className="flex gap-1.5 shrink-0">
                  {species.conservation_status && (
                    <Badge variant="outline">{species.conservation_status}</Badge>
                  )}
                  {species.rarity && <Badge variant="secondary">{species.rarity}</Badge>}
                </div>
              </div>
            </CardHeader>
            <CardContent className="space-y-3 text-sm">
              {species.description && (
                <p className="text-muted-foreground leading-relaxed">{species.description}</p>
              )}
              {species.habitat && (
                <>
                  <Separator />
                  <div>
                    <p className="text-xs font-semibold mb-1">Habitat</p>
                    <p className="text-xs text-muted-foreground">{species.habitat}</p>
                  </div>
                </>
              )}
              {(species.color_tags?.length ?? 0) > 0 && (
                <>
                  <Separator />
                  <div className="flex flex-wrap items-center gap-1.5">
                    <span className="text-xs font-semibold mr-1">Colors:</span>
                    {species.color_tags!.map((c) => (
                      <Badge key={c} variant="outline" className="text-[10px] capitalize">
                        {c}
                      </Badge>
                    ))}
                  </div>
                </>
              )}
            </CardContent>
          </Card>

          {/* Host plants */}
          {(species.host_plants?.length ?? 0) > 0 && (
            <Card>
              <CardHeader className="pb-2">
                <CardTitle className="text-sm flex items-center gap-2">
                  <Leaf size={14} /> Host Plants
                </CardTitle>
              </CardHeader>
              <CardContent>
                <ul className="space-y-1.5">
                  {species.host_plants!.map((p, i) => (
                    <li key={i} className="text-xs">
                      <span className="font-medium">{p.name}</span>
                      {p.scientific_name && (
                        <span className="text-muted-foreground italic"> · {p.scientific_name}</span>
                      )}
                    </li>
                  ))}
                </ul>
              </CardContent>
            </Card>
          )}

          {/* Distribution */}
          {(species.distribution_states?.length ?? 0) > 0 && (
            <Card>
              <CardHeader className="pb-2">
                <CardTitle className="text-sm flex items-center gap-2">
                  <MapIcon size={14} /> Distribution (India)
                </CardTitle>
              </CardHeader>
              <CardContent className="flex flex-wrap gap-1.5">
                {species.distribution_states!.map((d) => (
                  <Badge key={d.state_id} variant="outline" className="text-xs">
                    {d.state_name ?? `State ${d.state_id}`}
                    {d.abundance && (
                      <span className="text-muted-foreground ml-1 capitalize">· {d.abundance}</span>
                    )}
                  </Badge>
                ))}
              </CardContent>
            </Card>
          )}

          {/* Research columns and admin-defined fields. Renders nothing when the
              record has none of them populated. */}
          <SpeciesDetailSections species={species} />
        </div>

        {/* Facts sidebar */}
        <div className="space-y-4">
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm flex items-center gap-2">
                <Bug size={14} /> Taxonomy
              </CardTitle>
            </CardHeader>
            <CardContent>
              <InfoRow label="Class" value="Insecta" />
              <InfoRow label="Order" value="Lepidoptera" />
              <InfoRow label="Family" value={species.family} />
              <InfoRow label="Genus" value={species.genus} />
              <InfoRow
                label="Species"
                value={species.scientific_name?.split(" ")[1]}
              />
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm flex items-center gap-2">
                <ShieldCheck size={14} /> Details
              </CardTitle>
            </CardHeader>
            <CardContent>
              <InfoRow label="Wingspan" value={species.wingspan_mm || undefined} />
              <InfoRow
                label="Flight months"
                value={flightMonths.length > 0 ? flightMonths.join(", ") : undefined}
              />
              <InfoRow label="Conservation" value={species.conservation_status} />
              <InfoRow label="Rarity" value={species.rarity} />
              <InfoRow label="Observations" value={species.observation_count ?? 0} />
              <InfoRow label="Slug" value={<span className="font-mono">{species.slug}</span>} />
            </CardContent>
          </Card>
        </div>
      </div>

      <Dialog open={formOpen} onOpenChange={setFormOpen}>
        <DialogContent className="max-h-[90vh] overflow-y-auto sm:max-w-3xl">
          <DialogHeader>
            <DialogTitle>Edit {species.common_name}</DialogTitle>
            <DialogDescription>
              Sections are collapsed by default — open the ones you need. Only the
              four fields marked with * are required.
            </DialogDescription>
          </DialogHeader>
          <SpeciesForm
            species={species}
            onSaved={() => setFormOpen(false)}
            onCancel={() => setFormOpen(false)}
          />
        </DialogContent>
      </Dialog>

      <SpeciesStatusDialog
        species={species}
        open={statusOpen}
        onOpenChange={setStatusOpen}
      />

      <SpeciesStatusDialog
        species={species}
        open={deleteOpen}
        onOpenChange={setDeleteOpen}
        mode="delete"
      />
    </div>
  );
}
