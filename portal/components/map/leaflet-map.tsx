"use client";

import { useEffect, useRef } from "react";
import type { Observation } from "@/types";

// Leaflet CSS must be imported client-side
import "leaflet/dist/leaflet.css";

interface LeafletMapProps {
  observations: Observation[];
  center?: [number, number];
  zoom?: number;
  onMarkerClick?: (obs: Observation) => void;
  className?: string;
  singlePin?: { lat: number; lng: number; label?: string };
}

export function LeafletMap({
  observations,
  center = [20.5937, 78.9629], // India center
  zoom = 5,
  onMarkerClick,
  className = "h-96",
  singlePin,
}: LeafletMapProps) {
  const mapRef = useRef<HTMLDivElement>(null);
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const mapInstanceRef = useRef<any>(null);

  useEffect(() => {
    if (!mapRef.current || mapInstanceRef.current) return;

    // Dynamic import — Leaflet must run client-side only
    import("leaflet").then((L) => {
      // Fix default icon path issue with webpack/turbopack
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      delete (L.Icon.Default.prototype as any)._getIconUrl;
      L.Icon.Default.mergeOptions({
        iconRetinaUrl: "https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png",
        iconUrl: "https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png",
        shadowUrl: "https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png",
      });

      const map = L.map(mapRef.current!).setView(center, zoom);
      mapInstanceRef.current = map;

      L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
        attribution: '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
        maxZoom: 19,
      }).addTo(map);

      // Single pin mode (e.g., sighting detail page)
      if (singlePin) {
        const marker = L.marker([singlePin.lat, singlePin.lng]).addTo(map);
        if (singlePin.label) marker.bindPopup(singlePin.label).openPopup();
        map.setView([singlePin.lat, singlePin.lng], 12);
        return;
      }

      // Multiple observation markers
      observations.forEach((obs) => {
        if (!obs.latitude || !obs.longitude) return;
        const marker = L.marker([obs.latitude, obs.longitude]).addTo(map);
        const title = obs.title ?? obs.species?.common_name ?? "Butterfly sighting";
        marker.bindPopup(
          `<div class="text-sm font-medium">${title}</div>` +
            (obs.species
              ? `<div class="text-xs text-gray-500 italic">${obs.species.scientific_name}</div>`
              : "") +
            `<div class="text-xs mt-1"><a href="/sightings/${obs.id}" class="text-blue-600 hover:underline">View details →</a></div>`
        );
        if (onMarkerClick) marker.on("click", () => onMarkerClick(obs));
      });
    });

    return () => {
      if (mapInstanceRef.current) {
        mapInstanceRef.current.remove();
        mapInstanceRef.current = null;
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // Update markers when observations change without re-creating the map
  useEffect(() => {
    if (!mapInstanceRef.current || singlePin) return;
    import("leaflet").then((L) => {
      const map = mapInstanceRef.current;
      // Clear existing layers except tile layer
      map.eachLayer((layer: unknown) => {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        if ((layer as any) instanceof L.Marker) map.removeLayer(layer as any);
      });
      observations.forEach((obs) => {
        if (!obs.latitude || !obs.longitude) return;
        const marker = L.marker([obs.latitude, obs.longitude]).addTo(map);
        const title = obs.title ?? obs.species?.common_name ?? "Butterfly sighting";
        marker.bindPopup(
          `<div class="text-sm font-medium">${title}</div>` +
            (obs.species
              ? `<div class="text-xs text-gray-500 italic">${obs.species.scientific_name}</div>`
              : "") +
            `<div class="text-xs mt-1"><a href="/sightings/${obs.id}" class="text-blue-600 hover:underline">View details →</a></div>`
        );
        if (onMarkerClick) marker.on("click", () => onMarkerClick(obs));
      });
    });
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [observations]);

  return <div ref={mapRef} className={`rounded-lg overflow-hidden ${className}`} />;
}
