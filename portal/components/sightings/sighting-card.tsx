import Link from "next/link";
import Image from "next/image";
import { MapPin, Clock } from "lucide-react";
import { formatDistanceToNow } from "date-fns";
import { Card, CardContent } from "@/components/ui/card";
import { StatusBadge } from "./status-badge";
import type { Observation } from "@/types";

interface SightingCardProps {
  observation: Observation;
}

export function SightingCard({ observation: obs }: SightingCardProps) {
  const primaryImage = obs.images?.find((i) => i.is_primary) ?? obs.images?.[0];
  const title =
    obs.title ?? obs.species?.common_name ?? "Unknown butterfly";

  return (
    <Link href={`/sightings/${obs.id}`}>
      <Card className="overflow-hidden hover:shadow-md transition-shadow group">
        {/* Image */}
        <div className="relative aspect-[4/3] bg-muted overflow-hidden">
          {primaryImage ? (
            <Image
              src={primaryImage.thumbnail_url ?? primaryImage.original_url}
              alt={title}
              fill
              className="object-cover group-hover:scale-105 transition-transform duration-300"
              sizes="(max-width: 640px) 100vw, (max-width: 1024px) 50vw, 33vw"
            />
          ) : (
            <div className="absolute inset-0 flex items-center justify-center text-4xl text-muted-foreground/40">
              🦋
            </div>
          )}
          <div className="absolute top-2 left-2">
            <StatusBadge status={obs.verification_status} />
          </div>
        </div>

        <CardContent className="p-3 space-y-1.5">
          <p className="text-sm font-semibold leading-tight line-clamp-1">{title}</p>
          {obs.species && (
            <p className="text-xs text-muted-foreground italic line-clamp-1">
              {obs.species.scientific_name}
            </p>
          )}
          <div className="flex items-center justify-between text-[11px] text-muted-foreground">
            <span className="flex items-center gap-1">
              <MapPin size={11} />
              {obs.state?.name ?? obs.location_name ?? "India"}
            </span>
            <span className="flex items-center gap-1">
              <Clock size={11} />
              {formatDistanceToNow(new Date(obs.created_at), { addSuffix: true })}
            </span>
          </div>
          {obs.user && (
            <p className="text-[11px] text-muted-foreground">
              by <span className="font-medium">@{obs.user.username}</span>
            </p>
          )}
        </CardContent>
      </Card>
    </Link>
  );
}
