"use client";

import { use } from "react";
import { useQuery } from "@tanstack/react-query";
import Image from "next/image";
import Link from "next/link";
import { ArrowLeft, MapPin, Calendar, User as UserIcon, CheckCircle2 } from "lucide-react";
import { format } from "date-fns";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { Badge } from "@/components/ui/badge";
import { StatusBadge } from "@/components/sightings/status-badge";
import { DynamicMap } from "@/components/map/dynamic-map";
import api from "@/lib/api";
import type { ApiResponse, Observation } from "@/types";

export default function SightingDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = use(params);

  const { data: obs, isLoading } = useQuery({
    queryKey: ["observation", id],
    queryFn: async () => {
      const res = await api.get<ApiResponse<Observation>>(`/observations/${id}`);
      return res.data.data;
    },
  });

  if (isLoading) {
    return (
      <div className="container mx-auto px-4 py-8 max-w-4xl space-y-6">
        <Skeleton className="h-8 w-48" />
        <Skeleton className="aspect-video rounded-xl" />
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div className="lg:col-span-2 space-y-4">
            <Skeleton className="h-6 w-3/4" />
            <Skeleton className="h-4 w-full" />
            <Skeleton className="h-4 w-2/3" />
          </div>
          <Skeleton className="h-48 rounded-lg" />
        </div>
      </div>
    );
  }

  if (!obs) {
    return (
      <div className="container mx-auto px-4 py-20 text-center">
        <div className="text-5xl mb-4">🔍</div>
        <h2 className="text-xl font-bold mb-2">Sighting not found</h2>
        <Button asChild variant="outline">
          <Link href="/sightings">Back to sightings</Link>
        </Button>
      </div>
    );
  }

  const primaryImage = obs.images?.find((i) => i.is_primary) ?? obs.images?.[0];
  const title = obs.title ?? obs.species?.common_name ?? "Unknown butterfly";

  return (
    <div className="container mx-auto px-4 py-8 max-w-4xl space-y-6">
      {/* Back */}
      <Button variant="ghost" size="sm" asChild className="gap-1.5 -ml-2">
        <Link href="/sightings">
          <ArrowLeft size={15} /> Back to sightings
        </Link>
      </Button>

      {/* Image gallery */}
      {obs.images && obs.images.length > 0 && (
        <div className={`grid gap-2 ${obs.images.length > 1 ? "grid-cols-3" : "grid-cols-1"}`}>
          {obs.images.map((img, idx) => (
            <div
              key={img.id}
              className={`relative rounded-xl overflow-hidden bg-muted ${
                idx === 0 && obs.images!.length > 1 ? "col-span-2 row-span-2 aspect-video" : "aspect-square"
              } ${idx === 0 && obs.images!.length === 1 ? "aspect-video" : ""}`}
            >
              <Image
                src={img.optimized_url ?? img.original_url}
                alt={`${title} image ${idx + 1}`}
                fill
                className="object-cover"
                sizes="(max-width: 768px) 100vw, 66vw"
                priority={idx === 0}
              />
            </div>
          ))}
        </div>
      )}

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Main info */}
        <div className="lg:col-span-2 space-y-4">
          <div className="space-y-2">
            <div className="flex items-start gap-3 flex-wrap">
              <h1 className="text-2xl font-bold flex-1">{title}</h1>
              <StatusBadge status={obs.verification_status} />
            </div>
            {obs.species && (
              <div className="flex items-center gap-2">
                <Link href={`/species/${obs.species.id}`}
                  className="text-muted-foreground italic hover:text-primary transition-colors">
                  {obs.species.scientific_name}
                </Link>
                <Badge variant="secondary" className="text-xs">Species confirmed</Badge>
              </div>
            )}
          </div>

          {/* Meta */}
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            {(obs.state?.name || obs.location_name) && (
              <div className="flex items-center gap-2 text-sm text-muted-foreground">
                <MapPin size={15} className="shrink-0 text-primary" />
                <span>{obs.location_name ?? obs.state?.name}</span>
              </div>
            )}
            {obs.observed_at && (
              <div className="flex items-center gap-2 text-sm text-muted-foreground">
                <Calendar size={15} className="shrink-0 text-primary" />
                <span>{format(new Date(obs.observed_at), "PPP")}</span>
              </div>
            )}
            {obs.user && (
              <div className="flex items-center gap-2 text-sm text-muted-foreground">
                <UserIcon size={15} className="shrink-0 text-primary" />
                <span>Reported by <span className="font-medium text-foreground">@{obs.user.username}</span></span>
              </div>
            )}
          </div>

          {obs.notes && (
            <Card>
              <CardHeader className="pb-2">
                <CardTitle className="text-sm">Observer Notes</CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-sm text-muted-foreground leading-relaxed">{obs.notes}</p>
              </CardContent>
            </Card>
          )}

          {/* AI result */}
          {obs.identification && obs.identification.status === "completed" && obs.identification.top_match && (
            <Card className="border-blue-200 dark:border-blue-800">
              <CardHeader className="pb-2">
                <CardTitle className="text-sm flex items-center gap-2">
                  <CheckCircle2 size={15} className="text-blue-500" />
                  AI Identification Result
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-2">
                <div>
                  <p className="font-medium">{obs.identification.top_match.common_name}</p>
                  <p className="text-xs text-muted-foreground italic">{obs.identification.top_match.scientific_name}</p>
                </div>
                <div className="flex items-center gap-2">
                  <div className="flex-1 bg-muted rounded-full h-2">
                    <div
                      className="bg-blue-500 h-2 rounded-full"
                      style={{ width: `${Math.round(obs.identification.top_match.confidence_score * 100)}%` }}
                    />
                  </div>
                  <span className="text-xs font-medium text-blue-600">
                    {Math.round(obs.identification.top_match.confidence_score * 100)}% confidence
                  </span>
                </div>
              </CardContent>
            </Card>
          )}
        </div>

        {/* Sidebar — map + species link */}
        <div className="space-y-4">
          {obs.latitude && obs.longitude && (
            <Card>
              <CardHeader className="pb-2">
                <CardTitle className="text-sm">Location</CardTitle>
              </CardHeader>
              <CardContent className="p-2">
                <DynamicMap
                  observations={[]}
                  singlePin={{ lat: obs.latitude, lng: obs.longitude, label: title }}
                  className="h-48 w-full"
                />
                <p className="text-xs text-muted-foreground mt-2 text-center">
                  {obs.latitude.toFixed(4)}°N, {obs.longitude.toFixed(4)}°E
                </p>
              </CardContent>
            </Card>
          )}

          {obs.species && (
            <Card>
              <CardHeader className="pb-2">
                <CardTitle className="text-sm">Species Info</CardTitle>
              </CardHeader>
              <CardContent className="space-y-2">
                {primaryImage && (
                  <div className="relative aspect-video rounded-md overflow-hidden bg-muted">
                    <Image
                      src={obs.species.thumbnail_url ?? primaryImage.thumbnail_url ?? primaryImage.original_url}
                      alt={obs.species.common_name}
                      fill
                      className="object-cover"
                      sizes="300px"
                    />
                  </div>
                )}
                <p className="text-sm font-medium">{obs.species.common_name}</p>
                <p className="text-xs text-muted-foreground italic">{obs.species.scientific_name}</p>
                <Button asChild size="sm" variant="outline" className="w-full">
                  <Link href={`/species/${obs.species.id}`}>View species page</Link>
                </Button>
              </CardContent>
            </Card>
          )}
        </div>
      </div>
    </div>
  );
}
