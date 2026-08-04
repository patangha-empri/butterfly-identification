"use client";

import { useState } from "react";
import { ExternalLink, Plus, X } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import type { Citation } from "@/types";

/**
 * Editor for species.citations.
 *
 * Citations are {source, url} objects rather than plain strings — the research
 * ingestion pipeline records which database a fact came from alongside the link.
 * They therefore cannot use ListEditor: feeding those objects to it rendered an
 * object as a React child and took the whole species page down.
 *
 * `url` is optional because not every source has one (printed field guides).
 */
export function CitationsEditor({
  value,
  onChange,
}: {
  value: Citation[];
  onChange: (next: Citation[]) => void;
}) {
  const [source, setSource] = useState("");
  const [url, setUrl] = useState("");

  function add() {
    const nextSource = source.trim();
    if (!nextSource) return;
    const nextUrl = url.trim();
    const duplicate = value.some(
      (c) => c.source === nextSource && (c.url ?? "") === nextUrl
    );
    if (!duplicate) {
      onChange([...value, { source: nextSource, url: nextUrl || null }]);
    }
    setSource("");
    setUrl("");
  }

  function remove(index: number) {
    onChange(value.filter((_, i) => i !== index));
  }

  return (
    <div className="space-y-2">
      <div className="flex flex-wrap gap-1.5">
        <Input
          value={source}
          placeholder="Source, e.g. GBIF"
          className="w-40"
          onChange={(e) => setSource(e.target.value)}
          onKeyDown={(e) => {
            // Enter must not submit the surrounding species form.
            if (e.key === "Enter") {
              e.preventDefault();
              add();
            }
          }}
        />
        <Input
          value={url}
          placeholder="https://… (optional)"
          className="min-w-48 flex-1"
          onChange={(e) => setUrl(e.target.value)}
          onKeyDown={(e) => {
            if (e.key === "Enter") {
              e.preventDefault();
              add();
            }
          }}
        />
        <Button
          type="button"
          variant="outline"
          size="icon"
          onClick={add}
          disabled={!source.trim()}
          aria-label="Add citation"
        >
          <Plus size={14} />
        </Button>
      </div>

      {value.length > 0 && (
        <ul className="divide-y rounded-md border">
          {value.map((citation, i) => (
            <li
              key={`${citation.source}-${citation.url ?? ""}-${i}`}
              className="flex items-center justify-between gap-2 px-2.5 py-1.5"
            >
              <div className="min-w-0">
                <p className="text-xs font-medium">{citation.source}</p>
                {citation.url && (
                  <a
                    href={citation.url}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="inline-flex items-center gap-1 text-[10px] text-muted-foreground hover:text-primary hover:underline break-all"
                  >
                    <ExternalLink size={9} className="shrink-0" />
                    {citation.url}
                  </a>
                )}
              </div>
              <button
                type="button"
                onClick={() => remove(i)}
                aria-label={`Remove citation ${citation.source}`}
                className="shrink-0 text-muted-foreground hover:text-destructive"
              >
                <X size={12} />
              </button>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
