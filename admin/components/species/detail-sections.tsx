"use client";

import { useQuery } from "@tanstack/react-query";
import { Info } from "lucide-react";

import api from "@/lib/api";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
import { SPECIES_SECTIONS } from "./field-specs";
import type { ApiResponse, Citation, Species, SpeciesFieldDefinition } from "@/types";

const MONTHS = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

/**
 * The value a spec'd field actually holds on an API response.
 *
 * Everything maps name-for-name except the flight months: the column is
 * `seasonal_appearance` (which is what writes use) but responses serialise it
 * as `flight_months`, so reading by spec name alone always came back empty.
 */
function fieldValue(species: Species, spec: { name: string; kind: string }): unknown {
  if (spec.kind === "months") {
    return species.flight_months ?? species[spec.name as keyof Species];
  }
  return species[spec.name as keyof Species];
}

function isEmpty(value: unknown): boolean {
  if (value === null || value === undefined || value === "") return true;
  if (Array.isArray(value)) return value.length === 0;
  return false;
}

function renderValue(value: unknown, kind: string) {
  if (kind === "months" && Array.isArray(value)) {
    return (
      <div className="flex flex-wrap gap-1">
        {(value as number[])
          .filter((m) => m >= 1 && m <= 12)
          .map((m) => (
            <Badge key={m} variant="outline" className="text-[10px]">
              {MONTHS[m - 1]}
            </Badge>
          ))}
      </div>
    );
  }
  if (kind === "citations" && Array.isArray(value)) {
    return (
      <ul className="space-y-0.5">
        {(value as Citation[]).map((c, i) => (
          <li key={`${c.source}-${i}`}>
            {c.url ? (
              <a
                href={c.url}
                target="_blank"
                rel="noopener noreferrer"
                className="text-primary hover:underline break-all"
              >
                {c.source}
              </a>
            ) : (
              <span>{c.source}</span>
            )}
          </li>
        ))}
      </ul>
    );
  }
  if (Array.isArray(value)) {
    return (
      <div className="flex flex-wrap gap-1">
        {value.map((v, i) => (
          <Badge key={`${String(v)}-${i}`} variant="secondary" className="text-[10px] font-normal">
            {typeof v === "object" && v !== null ? JSON.stringify(v) : String(v)}
          </Badge>
        ))}
      </div>
    );
  }
  if (typeof value === "boolean") return value ? "Yes" : "No";

  const text = String(value);
  if (/^https?:\/\//i.test(text)) {
    return (
      <a
        href={text}
        target="_blank"
        rel="noopener noreferrer"
        className="text-primary hover:underline break-all"
      >
        {text}
      </a>
    );
  }
  return <span className="whitespace-pre-wrap">{text}</span>;
}

/**
 * Read-only view of the research columns and custom fields.
 *
 * Driven by the same spec as the form, so a field added there shows up here for
 * free. Sections and rows with no value are hidden — most species populate only
 * a fraction of ~60 columns, and rendering rows of dashes buries the real data.
 */
export function SpeciesDetailSections({ species }: { species: Species }) {
  const { data: definitions = [] } = useQuery({
    queryKey: ["species-field-definitions"],
    queryFn: async () => {
      const res = await api.get<ApiResponse<SpeciesFieldDefinition[]>>(
        "/admin/species/field-definitions"
      );
      return res.data.data;
    },
  });

  // "Basics" is already rendered by the page header, so skip it here.
  const sections = SPECIES_SECTIONS.filter((s) => s.id !== "basics")
    .map((section) => ({
      ...section,
      populated: section.fields.filter((f) => !isEmpty(fieldValue(species, f))),
    }))
    .filter((section) => section.populated.length > 0);

  const customEntries = Object.entries(species.custom_fields ?? {}).filter(
    ([, v]) => !isEmpty(v)
  );

  if (sections.length === 0 && customEntries.length === 0) return null;

  return (
    <div className="space-y-4">
      {sections.map((section) => (
        <Card key={section.id}>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm">{section.title}</CardTitle>
          </CardHeader>
          <CardContent className="space-y-2.5">
            {section.populated.map((field) => (
              <div key={field.name} className="grid gap-1 sm:grid-cols-3">
                <p className="text-xs text-muted-foreground">{field.label}</p>
                <div className="text-xs sm:col-span-2">
                  {renderValue(fieldValue(species, field), field.kind)}
                </div>
              </div>
            ))}
          </CardContent>
        </Card>
      ))}

      {customEntries.length > 0 && (
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="flex items-center gap-1.5 text-sm">
              Custom fields
              <Popover>
                <PopoverTrigger asChild>
                  <button type="button" aria-label="About custom fields">
                    <Info size={12} className="text-muted-foreground hover:text-foreground" />
                  </button>
                </PopoverTrigger>
                <PopoverContent className="w-72 text-xs leading-relaxed">
                  Fields defined by your team rather than built into the system.
                  They are shared across all species — edit them from the species
                  form.
                </PopoverContent>
              </Popover>
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-2.5">
            {customEntries.map(([key, value]) => {
              const def = definitions.find((d) => d.field_key === key);
              return (
                <div key={key} className="grid gap-1 sm:grid-cols-3">
                  <p className="text-xs text-muted-foreground">
                    {def?.label ?? key}
                    {/* A value whose definition was retired still shows, so data
                        is never silently hidden. */}
                    {def && def.is_active === false && (
                      <span className="ml-1 text-[10px] text-amber-700">(retired)</span>
                    )}
                  </p>
                  <div className="text-xs sm:col-span-2">
                    {renderValue(value, def?.field_type ?? "text")}
                  </div>
                </div>
              );
            })}
          </CardContent>
        </Card>
      )}
    </div>
  );
}
