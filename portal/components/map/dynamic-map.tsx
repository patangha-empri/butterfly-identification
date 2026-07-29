"use client";

// Wrapper that disables SSR for Leaflet (window is not defined on server)
import dynamic from "next/dynamic";
import { Skeleton } from "@/components/ui/skeleton";

export const DynamicMap = dynamic(
  () => import("./leaflet-map").then((m) => m.LeafletMap),
  {
    ssr: false,
    loading: () => <Skeleton className="w-full h-full rounded-lg" />,
  }
);
