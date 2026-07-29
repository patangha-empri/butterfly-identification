"use client";

import Link from "next/link";
import { useQuery } from "@tanstack/react-query";
import { ArrowRight, MapPin, Users, Leaf, ShieldCheck } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { SightingCard } from "@/components/sightings/sighting-card";
import { SpeciesCard } from "@/components/species/species-card";
import api from "@/lib/api";
import type { ApiResponse, Observation, Species, PublicStats } from "@/types";

function StatPill({
  icon: Icon,
  value,
  label,
  loading,
}: {
  icon: React.ElementType;
  value?: number;
  label: string;
  loading: boolean;
}) {
  return (
    <div className="flex flex-col items-center gap-1">
      <div className="flex items-center gap-1.5 text-primary">
        <Icon size={18} />
        {loading ? (
          <Skeleton className="h-6 w-12" />
        ) : (
          <span className="text-2xl font-bold">{value?.toLocaleString("en-IN") ?? "—"}</span>
        )}
      </div>
      <span className="text-xs text-muted-foreground">{label}</span>
    </div>
  );
}

export default function HomePage() {
  const { data: stats, isLoading: statsLoading } = useQuery({
    queryKey: ["public-stats"],
    queryFn: async () => {
      const res = await api.get<ApiResponse<PublicStats>>("/stats");
      return res.data.data;
    },
    retry: false,
  });

  const { data: recentObs, isLoading: obsLoading } = useQuery({
    queryKey: ["recent-observations-home"],
    queryFn: async () => {
      const res = await api.get<ApiResponse<Observation[]>>(
        "/observations?per_page=6&status=expert_verified,community_verified,ai_identified&sort=created_at&order=desc"
      );
      return res.data.data;
    },
    retry: false,
  });

  const { data: featuredSpecies, isLoading: speciesLoading } = useQuery({
    queryKey: ["featured-species-home"],
    queryFn: async () => {
      const res = await api.get<ApiResponse<Species[]>>("/species?per_page=4&sort=observation_count&order=desc");
      return res.data.data;
    },
    retry: false,
  });

  return (
    <div className="flex flex-col">
      {/* Hero */}
      <section className="relative bg-gradient-to-br from-green-50 via-emerald-50 to-teal-50 dark:from-green-950/20 dark:via-emerald-950/20 dark:to-teal-950/20 py-20 px-4">
        <div className="container mx-auto max-w-4xl text-center space-y-6">
          <div className="text-7xl">🦋</div>
          <h1 className="text-4xl sm:text-5xl font-bold tracking-tight leading-tight">
            Discover India&apos;s
            <br />
            <span className="text-primary">Butterfly Diversity</span>
          </h1>
          <p className="text-lg text-muted-foreground max-w-xl mx-auto">
            Join thousands of citizen scientists tracking butterfly species across India.
            Submit sightings, explore maps, and contribute to biodiversity conservation.
          </p>
          <div className="flex flex-wrap gap-3 justify-center">
            <Button asChild size="lg" className="gap-2">
              <Link href="/submit">
                Submit a Sighting
                <ArrowRight size={16} />
              </Link>
            </Button>
            <Button asChild size="lg" variant="outline">
              <Link href="/sightings">Explore the Map</Link>
            </Button>
          </div>
        </div>
      </section>

      {/* Stats bar */}
      <section className="border-y bg-card py-6 px-4">
        <div className="container mx-auto">
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-6 max-w-2xl mx-auto">
            <StatPill icon={MapPin} value={stats?.total_observations} label="Sightings" loading={statsLoading} />
            <StatPill icon={Leaf} value={stats?.total_species} label="Species" loading={statsLoading} />
            <StatPill icon={Users} value={stats?.total_users} label="Contributors" loading={statsLoading} />
            <StatPill icon={ShieldCheck} value={stats?.verified_observations} label="Verified" loading={statsLoading} />
          </div>
        </div>
      </section>

      {/* Recent sightings */}
      <section className="py-12 px-4">
        <div className="container mx-auto space-y-6">
          <div className="flex items-center justify-between">
            <div>
              <h2 className="text-xl font-bold">Recent Sightings</h2>
              <p className="text-sm text-muted-foreground">Latest observations from across India</p>
            </div>
            <Button variant="outline" size="sm" asChild>
              <Link href="/sightings" className="gap-1">
                View all <ArrowRight size={14} />
              </Link>
            </Button>
          </div>

          {obsLoading ? (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
              {Array.from({ length: 6 }).map((_, i) => (
                <Card key={i}>
                  <Skeleton className="aspect-[4/3]" />
                  <CardContent className="p-3 space-y-2">
                    <Skeleton className="h-4 w-3/4" />
                    <Skeleton className="h-3 w-1/2" />
                  </CardContent>
                </Card>
              ))}
            </div>
          ) : (recentObs ?? []).length > 0 ? (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
              {(recentObs ?? []).map((obs) => (
                <SightingCard key={obs.id} observation={obs} />
              ))}
            </div>
          ) : (
            <div className="text-center py-16 text-muted-foreground">
              <div className="text-5xl mb-3">🦋</div>
              <p>No sightings yet. Be the first to{" "}
                <Link href="/submit" className="text-primary hover:underline">submit one</Link>!
              </p>
            </div>
          )}
        </div>
      </section>

      {/* Featured species */}
      <section className="py-12 px-4 bg-muted/30">
        <div className="container mx-auto space-y-6">
          <div className="flex items-center justify-between">
            <div>
              <h2 className="text-xl font-bold">Species Spotlight</h2>
              <p className="text-sm text-muted-foreground">Most frequently spotted species</p>
            </div>
            <Button variant="outline" size="sm" asChild>
              <Link href="/species" className="gap-1">
                Field guide <ArrowRight size={14} />
              </Link>
            </Button>
          </div>

          {speciesLoading ? (
            <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
              {Array.from({ length: 4 }).map((_, i) => (
                <Card key={i}>
                  <Skeleton className="aspect-[4/3]" />
                  <CardContent className="p-3 space-y-2">
                    <Skeleton className="h-4 w-3/4" />
                    <Skeleton className="h-3 w-1/2" />
                  </CardContent>
                </Card>
              ))}
            </div>
          ) : (
            <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
              {(featuredSpecies ?? []).map((sp) => (
                <SpeciesCard key={sp.id} species={sp} />
              ))}
            </div>
          )}
        </div>
      </section>

      {/* CTA */}
      <section className="py-16 px-4 text-center">
        <div className="container mx-auto max-w-xl space-y-4">
          <h2 className="text-2xl font-bold">Ready to contribute?</h2>
          <p className="text-muted-foreground">
            Every sighting helps scientists understand butterfly migration, habitat changes,
            and conservation needs across India.
          </p>
          <Button asChild size="lg">
            <Link href="/register">Create a free account</Link>
          </Button>
        </div>
      </section>
    </div>
  );
}
