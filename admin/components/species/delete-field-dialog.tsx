"use client";

import { useMemo, useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { AlertTriangle, Loader2, Search } from "lucide-react";
import { toast } from "sonner";

import api, { apiErrorMessage } from "@/lib/api";
import { Button } from "@/components/ui/button";
import { Checkbox } from "@/components/ui/checkbox";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import { ScrollArea } from "@/components/ui/scroll-area";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import type {
  ApiResponse,
  CustomFieldValue,
  FieldDefinitionUsage,
  FieldDeleteMode,
  SpeciesFieldDefinition,
} from "@/types";

/**
 * The four ways to remove a custom field.
 *
 * `selected` is not a server delete mode — it clears values on chosen species
 * and leaves the definition alone — but from the admin's point of view it is
 * one of the answers to "delete this field", so it belongs in the same list.
 */
type Choice = FieldDeleteMode | "selected";

function previewValue(value: CustomFieldValue): string {
  if (value === null || value === undefined) return "—";
  if (Array.isArray(value)) return value.join(", ");
  if (typeof value === "boolean") return value ? "Yes" : "No";
  return String(value);
}

export function DeleteFieldDialog({
  definition,
  open,
  onOpenChange,
}: {
  definition: SpeciesFieldDefinition | null;
  open: boolean;
  onOpenChange: (open: boolean) => void;
}) {
  const qc = useQueryClient();
  const [choice, setChoice] = useState<Choice>("retire");
  const [confirmKey, setConfirmKey] = useState("");
  const [selectedIds, setSelectedIds] = useState<string[]>([]);
  const [search, setSearch] = useState("");

  // Every open starts from the safe option, never from the last destructive
  // choice the admin happened to make on a different field. Reset during render
  // rather than in an effect — the dialog is controlled by its parent, so there
  // is no remount to rely on.
  const session = open && definition ? definition.id : null;
  const [lastSession, setLastSession] = useState<string | null>(null);
  if (session !== lastSession) {
    setLastSession(session);
    setChoice("retire");
    setConfirmKey("");
    setSelectedIds([]);
    setSearch("");
  }

  const { data: usage, isLoading } = useQuery({
    queryKey: ["species-field-usage", definition?.id],
    queryFn: async () => {
      const res = await api.get<ApiResponse<FieldDefinitionUsage>>(
        `/admin/species/field-definitions/${definition!.id}/usage`
      );
      return res.data.data;
    },
    enabled: open && !!definition,
  });

  const holders = useMemo(() => usage?.species ?? [], [usage]);
  const total = usage?.total ?? 0;

  const visibleHolders = useMemo(() => {
    const term = search.trim().toLowerCase();
    if (!term) return holders;
    return holders.filter(
      (h) =>
        h.common_name?.toLowerCase().includes(term) ||
        h.scientific_name?.toLowerCase().includes(term)
    );
  }, [holders, search]);

  const needsConfirm = choice === "purge" || choice === "definition_only" || choice === "selected";
  const confirmed = confirmKey.trim() === definition?.field_key;

  function invalidate() {
    qc.invalidateQueries({ queryKey: ["species-field-definitions"] });
    qc.invalidateQueries({ queryKey: ["species-field-usage"] });
    qc.invalidateQueries({ queryKey: ["species"] });
  }

  const mutation = useMutation({
    mutationFn: async () => {
      if (choice === "selected") {
        const res = await api.delete<ApiResponse<{ cleared_species: number }>>(
          `/admin/species/field-definitions/${definition!.id}/values`,
          { data: { species_ids: selectedIds, confirm_key: confirmKey.trim() } }
        );
        return res.data;
      }
      const res = await api.delete<ApiResponse<{ cleared_species: number }>>(
        `/admin/species/field-definitions/${definition!.id}?mode=${choice}`,
        { data: choice === "retire" ? {} : { confirm_key: confirmKey.trim() } }
      );
      return res.data;
    },
    onSuccess: (body) => {
      toast.success(body.message ?? "Done.");
      invalidate();
      onOpenChange(false);
    },
    onError: (err) => toast.error(apiErrorMessage(err)),
  });

  const canSubmit =
    !!definition &&
    !mutation.isPending &&
    (!needsConfirm || confirmed) &&
    (choice !== "selected" || selectedIds.length > 0);

  if (!definition) return null;

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-lg">
        <DialogHeader>
          <DialogTitle>Delete “{definition.label}”</DialogTitle>
          <DialogDescription>
            {isLoading
              ? "Checking which species use this field…"
              : total === 0
                ? "No species have a value for this field yet, so nothing will be lost."
                : `${total} ${total === 1 ? "species has" : "species have"} data in this field. Choose what happens to it.`}
          </DialogDescription>
        </DialogHeader>

        <RadioGroup
          value={choice}
          onValueChange={(v) => setChoice(v as Choice)}
          className="gap-3"
        >
          <Option
            value="retire"
            title="Hide the field, keep all data"
            hint="Recommended. It disappears from the form but every value stays saved, and switching it back on brings them into view again."
          />
          <Option
            value="definition_only"
            title="Delete the field, keep the data"
            hint="The field is gone from the panel but the values stay in the database, hidden. They only reappear if you re-create a field with the same storage key."
          />
          <Option
            value="purge"
            title={`Delete the field and its data on all ${total} species`}
            hint="Permanent. The field and every value it holds are removed. This cannot be undone."
            danger
          />
          <Option
            value="selected"
            title="Only clear it on species I choose"
            hint="The field stays available; only the species you tick lose their value."
            disabled={total === 0}
          />
        </RadioGroup>

        {choice === "selected" && (
          <div className="space-y-2 rounded-lg border p-3">
            <div className="flex items-center gap-2">
              <Search size={13} className="text-muted-foreground" />
              <Input
                value={search}
                placeholder="Search species"
                className="h-8"
                onChange={(e) => setSearch(e.target.value)}
              />
            </div>
            <div className="flex items-center justify-between text-[11px] text-muted-foreground">
              <span>{selectedIds.length} selected</span>
              <button
                type="button"
                className="hover:text-foreground"
                onClick={() =>
                  setSelectedIds(
                    selectedIds.length === holders.length ? [] : holders.map((h) => h.id)
                  )
                }
              >
                {selectedIds.length === holders.length ? "Clear all" : "Select all"}
              </button>
            </div>
            <ScrollArea className="h-48">
              <div className="space-y-1 pr-3">
                {visibleHolders.map((holder) => {
                  const checked = selectedIds.includes(holder.id);
                  return (
                    <label
                      key={holder.id}
                      className="flex cursor-pointer items-start gap-2 rounded-md p-1.5 hover:bg-muted/60"
                    >
                      <Checkbox
                        checked={checked}
                        className="mt-0.5"
                        onCheckedChange={(c) =>
                          setSelectedIds((prev) =>
                            c ? [...prev, holder.id] : prev.filter((id) => id !== holder.id)
                          )
                        }
                      />
                      <span className="min-w-0 flex-1">
                        <span className="block text-xs font-medium">{holder.common_name}</span>
                        <span className="block truncate text-[10px] text-muted-foreground">
                          {previewValue(holder.value)}
                        </span>
                      </span>
                    </label>
                  );
                })}
                {visibleHolders.length === 0 && (
                  <p className="p-2 text-xs text-muted-foreground">No species match.</p>
                )}
              </div>
            </ScrollArea>
          </div>
        )}

        {needsConfirm && (
          <div className="space-y-1.5">
            <Label htmlFor="cf-confirm" className="text-xs">
              Type <code className="font-mono">{definition.field_key}</code> to confirm
            </Label>
            <Input
              id="cf-confirm"
              value={confirmKey}
              className="font-mono text-xs"
              autoComplete="off"
              onChange={(e) => setConfirmKey(e.target.value)}
            />
            {choice === "purge" && (
              <p className="flex items-start gap-1.5 text-xs text-destructive">
                <AlertTriangle size={13} className="mt-0.5 shrink-0" />
                Data on {total} {total === 1 ? "species" : "species"} will be deleted permanently.
              </p>
            )}
          </div>
        )}

        <DialogFooter>
          <Button type="button" variant="outline" onClick={() => onOpenChange(false)}>
            Cancel
          </Button>
          <Button
            type="button"
            variant={choice === "retire" ? "default" : "destructive"}
            disabled={!canSubmit}
            onClick={() => mutation.mutate()}
          >
            {mutation.isPending && <Loader2 className="mr-2 size-4 animate-spin" />}
            {choice === "retire"
              ? "Hide field"
              : choice === "selected"
                ? `Clear on ${selectedIds.length} species`
                : "Delete field"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

function Option({
  value,
  title,
  hint,
  danger,
  disabled,
}: {
  value: Choice;
  title: string;
  hint: string;
  danger?: boolean;
  disabled?: boolean;
}) {
  return (
    <label
      className={`flex items-start gap-2.5 rounded-lg border p-2.5 ${
        disabled ? "cursor-not-allowed opacity-50" : "cursor-pointer hover:bg-muted/50"
      }`}
    >
      <RadioGroupItem value={value} disabled={disabled} className="mt-0.5" />
      <span className="space-y-0.5">
        <span
          className={`block text-xs font-medium ${danger ? "text-destructive" : ""}`}
        >
          {title}
        </span>
        <span className="block text-[11px] leading-relaxed text-muted-foreground">
          {hint}
        </span>
      </span>
    </label>
  );
}
