"use client";

import { useState } from "react";
import { Plus, X } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

/**
 * Chip editor for the JSONB array columns — synonyms, nectar_plants, countries,
 * protected_areas, citations, source_urls, color_tags.
 *
 * Entries are added one at a time rather than as comma-separated text, because
 * several of these legitimately contain commas (citations especially).
 */
export function ListEditor({
  value,
  onChange,
  placeholder = "Add an entry",
}: {
  value: string[];
  onChange: (next: string[]) => void;
  placeholder?: string;
}) {
  const [draft, setDraft] = useState("");

  function add() {
    const entry = draft.trim();
    if (!entry || value.includes(entry)) {
      setDraft("");
      return;
    }
    onChange([...value, entry]);
    setDraft("");
  }

  return (
    <div className="space-y-2">
      <div className="flex gap-1.5">
        <Input
          value={draft}
          placeholder={placeholder}
          onChange={(e) => setDraft(e.target.value)}
          onKeyDown={(e) => {
            // Enter must not submit the surrounding species form.
            if (e.key === "Enter") {
              e.preventDefault();
              add();
            }
          }}
        />
        <Button type="button" variant="outline" size="icon" onClick={add} aria-label="Add">
          <Plus size={14} />
        </Button>
      </div>

      {value.length > 0 && (
        <div className="flex flex-wrap gap-1.5">
          {value.map((entry) => (
            <Badge key={entry} variant="secondary" className="gap-1 font-normal">
              <span className="max-w-[22rem] truncate">{entry}</span>
              <button
                type="button"
                onClick={() => onChange(value.filter((v) => v !== entry))}
                aria-label={`Remove ${entry}`}
                className="hover:text-destructive"
              >
                <X size={11} />
              </button>
            </Badge>
          ))}
        </div>
      )}
    </div>
  );
}
