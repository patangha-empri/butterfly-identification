"use client";

import { use } from "react";
import { useQuery } from "@tanstack/react-query";
import Image from "next/image";
import Link from "next/link";
import { ArrowLeft, Leaf, MapPin, Calendar } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { SightingCard } from "@/components/sightings/sighting-card";
import api from "@/lib/api";
import type { ApiResponse, Species, Observation } from "@/types";

const CONSERVATION_LABELS: Record<string, string> = {
  LC: "Least Concern", NT: "Near Threatened", VU: "Vulnerable",
  EN: "Endangered", CR: "Critically Endangered",
};

export default function SpeciesDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = use(params);

  const { data: species, isLoading } = useQuery({
    queryKey: ["species", id],
    queryFn: async () => {
      const res = await api.get<ApiResponse<Species>>(`/species/${id}`);
      return res.data.data;
    },
  });

  const { data: sightings } = useQuery({
    queryKey: ["species-sightings", id],
    queryFn: async () => {
      const res = await api.get<ApiResponse<Observation[]>>(
        `/observations?species_id=${id}&per_page=6&sort=created_at&order=desc`
      );
      return res.data.data;
    },
    enabled: !!id,
  });

  if (isLoading) {
    return (
      <div className="container mx-auto px-4 py-8 max-w-4xl space-y-6">
        <Skeleton className="h-8 w-48" />
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          <Skeleton className="aspect-square rounded-xl" />
          <div className="space-y-3">
            <Skeleton className="h-8 w-3/4" />
            <Skeleton className="h-5 w-1/2" />
            <Skeleton className="h-24 w-full" />
          </div>
        </div>
      </div>
    );
  }

  if (!species) {
    return (
      <div className="container mx-auto px-4 py-20 text-center">
        <div className="text-5xl mb-4">🔍</div>
        <h2 className="text-xl font-bold mb-2">Species not found</h2>
        <Button asChild variant="outline"><Link href="/species">Back to field guide</Link></Button>
      </div>
    );
  }

  return (
    <div className="container mx-auto px-4 py-8 max-w-4xl space-y-8">
      <Button variant="ghost" size="sm" asChild className="gap-1.5 -ml-2">
        <Link href="/species"><ArrowLeft size={15} /> Field Guide</Link>
      </Button>

      {/* Hero */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 items-start">
        <div className="relative aspect-square rounded-xl overflow-hidden bg-muted">
          {species.image_url ?? species.thumbnail_url ? (
            <Image
              src={species.image_url ?? species.thumbnail_url!}
              alt={species.common_name}
              fill
              className="object-cover"
              sizes="(max-width: 1024px) 100vw, 50vw"
              priority
            />
          ) : (
            <div className="absolute inset-0 flex items-center justify-center text-8xl text-muted-foreground/20">🦋</div>
          )}
        </div>

        <div className="space-y-4">
          <div>
            <h1 className="text-3xl font-bold">{species.common_name}</h1>
            <p className="text-lg text-muted-foreground italic">{species.scientific_name}</p>
          </div>

          <div className="flex flex-wrap gap-2">
            <Badge variant="secondary">{species.family}</Badge>
            {species.conservation_status && (
              <Badge variant="outline" className="gap-1">
                {species.conservation_status}
                {CONSERVATION_LABELS[species.conservation_status] &&
                  ` — ${CONSERVATION_LABELS[species.conservation_status]}`}
              </Badge>
            )}
            {typeof species.observation_count === "number" && (
              <Badge variant="outline" className="gap-1">
                <MapPin size={11} /> {species.observation_count} sightings
              </Badge>
            )}
          </div>

          {species.description && (
            <p className="text-sm text-muted-foreground leading-relaxed">{species.description}</p>
          )}

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            {species.habitat && (
              <div className="flex items-start gap-2">
                <Leaf size={15} className="text-green-500 mt-0.5 shrink-0" />
                <div>
                  <p className="text-xs font-medium">Habitat</p>
                  <p className="text-xs text-muted-foreground">{species.habitat}</p>
                </div>
              </div>
            )}
            {species.flight_period && (
              <div className="flex items-start gap-2">
                <Calendar size={15} className="text-blue-500 mt-0.5 shrink-0" />
                <div>
                  <p className="text-xs font-medium">Flight Period</p>
                  <p className="text-xs text-muted-foreground">{species.flight_period}</p>
                </div>
              </div>
            )}
          </div>

          {species.host_plants && species.host_plants.length > 0 && (
            <div>
              <p className="text-xs font-medium mb-1.5">Host Plants</p>
              <div className="flex flex-wrap gap-1.5">
                {species.host_plants.map((p) => (
                  <Badge key={p} variant="secondary" className="text-xs">{p}</Badge>
                ))}
              </div>
            </div>
          )}

          {species.color_tags && species.color_tags.length > 0 && (
            <div>
              <p className="text-xs font-medium mb-1.5">Colours</p>
              <div className="flex flex-wrap gap-1.5">
                {species.color_tags.map((c) => (
                  <Badge key={c} variant="outline" className="text-xs capitalize">{c}</Badge>
                ))}
              </div>
            </div>
          )}
        </div>
      </div>

      {/* Recent sightings of this species */}
      {sightings && sightings.length > 0 && (
        <div className="space-y-4">
          <div className="flex items-center justify-between">
            <h2 className="text-lg font-bold">Recent Sightings</h2>
            <Button variant="outline" size="sm" asChild>
              <Link href={`/sightings?species=${id}`}>View all</Link>
            </Button>
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
            {sightings.map((obs) => (
              <SightingCard key={obs.id} observation={obs} />
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
