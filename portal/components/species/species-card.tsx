import Link from "next/link";
import Image from "next/image";
import { Eye } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import type { Species } from "@/types";

interface SpeciesCardProps {
  species: Species;
}

const CONSERVATION_COLORS: Record<string, string> = {
  LC: "bg-green-100 text-green-800",
  NT: "bg-lime-100 text-lime-800",
  VU: "bg-yellow-100 text-yellow-800",
  EN: "bg-orange-100 text-orange-800",
  CR: "bg-red-100 text-red-800",
};

export function SpeciesCard({ species }: SpeciesCardProps) {
  return (
    <Link href={`/species/${species.id}`}>
      <Card className="overflow-hidden hover:shadow-md transition-shadow group">
        <div className="relative aspect-[4/3] bg-muted overflow-hidden">
          {species.thumbnail_url ? (
            <Image
              src={species.thumbnail_url}
              alt={species.common_name}
              fill
              className="object-cover group-hover:scale-105 transition-transform duration-300"
              sizes="(max-width: 640px) 100vw, (max-width: 1024px) 50vw, 33vw"
            />
          ) : (
            <div className="absolute inset-0 flex items-center justify-center text-5xl text-muted-foreground/30">
              🦋
            </div>
          )}
          {species.conservation_status && (
            <div className="absolute top-2 right-2">
              <span
                className={`text-[10px] font-bold px-1.5 py-0.5 rounded ${
                  CONSERVATION_COLORS[species.conservation_status] ?? "bg-muted text-muted-foreground"
                }`}
              >
                {species.conservation_status}
              </span>
            </div>
          )}
        </div>
        <CardContent className="p-3 space-y-1">
          <p className="text-sm font-semibold leading-tight line-clamp-1">{species.common_name}</p>
          <p className="text-xs text-muted-foreground italic line-clamp-1">{species.scientific_name}</p>
          <div className="flex items-center justify-between">
            <Badge variant="secondary" className="text-[10px] h-5">
              {species.family}
            </Badge>
            {typeof species.observation_count === "number" && (
              <span className="flex items-center gap-1 text-[11px] text-muted-foreground">
                <Eye size={11} />
                {species.observation_count}
              </span>
            )}
          </div>
        </CardContent>
      </Card>
    </Link>
  );
}
