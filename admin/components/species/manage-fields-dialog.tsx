"use client";

import { useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { Loader2, Pencil, Trash2 } from "lucide-react";
import { toast } from "sonner";

import api, { apiErrorMessage } from "@/lib/api";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Switch } from "@/components/ui/switch";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { DeleteFieldDialog } from "./delete-field-dialog";
import type { ApiResponse, SpeciesFieldDefinition } from "@/types";

/**
 * Edit, retire and delete the shared custom-field vocabulary.
 *
 * Retired fields are listed too — without them a field switched off by mistake
 * would be unreachable, and its saved values invisible forever.
 */
export function ManageFieldsDialog({
  open,
  onOpenChange,
}: {
  open: boolean;
  onOpenChange: (open: boolean) => void;
}) {
  const qc = useQueryClient();
  const [editing, setEditing] = useState<SpeciesFieldDefinition | null>(null);
  const [deleting, setDeleting] = useState<SpeciesFieldDefinition | null>(null);

  const { data: definitions = [], isLoading } = useQuery({
    queryKey: ["species-field-definitions", "manage"],
    queryFn: async () => {
      const res = await api.get<ApiResponse<SpeciesFieldDefinition[]>>(
        "/admin/species/field-definitions?include_retired=true&with_usage=true"
      );
      return res.data.data;
    },
    enabled: open,
  });

  const patchMutation = useMutation({
    mutationFn: async ({
      id,
      body,
    }: {
      id: string;
      body: Partial<SpeciesFieldDefinition>;
    }) => {
      const res = await api.patch<ApiResponse<SpeciesFieldDefinition>>(
        `/admin/species/field-definitions/${id}`,
        body
      );
      return res.data.data;
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["species-field-definitions"] });
      setEditing(null);
    },
    onError: (err) => toast.error(apiErrorMessage(err)),
  });

  return (
    <>
      <Dialog open={open} onOpenChange={onOpenChange}>
        <DialogContent className="sm:max-w-xl">
          <DialogHeader>
            <DialogTitle>Manage custom fields</DialogTitle>
            <DialogDescription>
              These fields are shared by every species. Switching one off hides it
              from the form without touching any saved data.
            </DialogDescription>
          </DialogHeader>

          {isLoading ? (
            <p className="text-xs text-muted-foreground">Loading fields…</p>
          ) : definitions.length === 0 ? (
            <p className="rounded-lg border bg-muted/30 p-3 text-xs text-muted-foreground">
              No custom fields yet.
            </p>
          ) : (
            <ScrollArea className="max-h-[60vh]">
              <div className="space-y-2 pr-3">
                {definitions.map((def) => (
                  <div
                    key={def.id}
                    className="flex items-start gap-3 rounded-lg border p-2.5"
                  >
                    <div className="min-w-0 flex-1 space-y-0.5">
                      <div className="flex flex-wrap items-center gap-1.5">
                        <span className="text-xs font-medium">{def.label}</span>
                        <code className="font-mono text-[10px] text-muted-foreground">
                          {def.field_key}
                        </code>
                        {!def.is_active && (
                          <Badge variant="secondary" className="h-4 px-1 text-[9px]">
                            hidden
                          </Badge>
                        )}
                      </div>
                      <p className="text-[10px] text-muted-foreground">
                        {def.field_type}
                        {typeof def.usage_count === "number" && (
                          <>
                            {" · "}
                            {def.usage_count === 0
                              ? "not used yet"
                              : `used on ${def.usage_count} ${
                                  def.usage_count === 1 ? "species" : "species"
                                }`}
                          </>
                        )}
                      </p>
                    </div>

                    <div className="flex items-center gap-1">
                      <Switch
                        checked={def.is_active !== false}
                        aria-label={def.is_active === false ? "Show field" : "Hide field"}
                        onCheckedChange={(checked) =>
                          patchMutation.mutate({
                            id: def.id,
                            body: { is_active: checked },
                          })
                        }
                      />
                      <Button
                        type="button"
                        variant="ghost"
                        size="icon"
                        className="size-7"
                        aria-label={`Edit ${def.label}`}
                        onClick={() => setEditing(def)}
                      >
                        <Pencil size={13} />
                      </Button>
                      <Button
                        type="button"
                        variant="ghost"
                        size="icon"
                        className="size-7 text-muted-foreground hover:text-destructive"
                        aria-label={`Delete ${def.label}`}
                        onClick={() => setDeleting(def)}
                      >
                        <Trash2 size={13} />
                      </Button>
                    </div>
                  </div>
                ))}
              </div>
            </ScrollArea>
          )}

          <DialogFooter>
            <Button type="button" variant="outline" onClick={() => onOpenChange(false)}>
              Done
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <EditFieldDialog
        definition={editing}
        pending={patchMutation.isPending}
        onCancel={() => setEditing(null)}
        onSave={(body) =>
          editing && patchMutation.mutate({ id: editing.id, body })
        }
      />

      <DeleteFieldDialog
        definition={deleting}
        open={!!deleting}
        onOpenChange={(next) => !next && setDeleting(null)}
      />
    </>
  );
}

/** Label and hint only — the storage key and type are fixed once data exists. */
function EditFieldDialog({
  definition,
  pending,
  onCancel,
  onSave,
}: {
  definition: SpeciesFieldDefinition | null;
  pending: boolean;
  onCancel: () => void;
  onSave: (body: Partial<SpeciesFieldDefinition>) => void;
}) {
  const [label, setLabel] = useState("");
  const [helpText, setHelpText] = useState("");
  const [groupName, setGroupName] = useState("");
  const [sortOrder, setSortOrder] = useState("0");
  const [loadedFor, setLoadedFor] = useState<string | null>(null);

  // Seed the inputs the first time a given definition is opened, without an
  // effect that would fight the admin's typing on every render.
  if (definition && loadedFor !== definition.id) {
    setLoadedFor(definition.id);
    setLabel(definition.label);
    setHelpText(definition.help_text ?? "");
    setGroupName(definition.group_name ?? "");
    setSortOrder(String(definition.sort_order ?? 0));
  }
  if (!definition && loadedFor !== null) setLoadedFor(null);

  return (
    <Dialog open={!!definition} onOpenChange={(next) => !next && onCancel()}>
      <DialogContent className="sm:max-w-md">
        <DialogHeader>
          <DialogTitle>Edit field</DialogTitle>
          <DialogDescription>
            The storage key{" "}
            <code className="font-mono text-[11px]">{definition?.field_key}</code>{" "}
            cannot change — every saved value is filed under it.
          </DialogDescription>
        </DialogHeader>

        <div className="space-y-3">
          <div className="space-y-1.5">
            <Label htmlFor="cf-edit-label">Field name</Label>
            <Input
              id="cf-edit-label"
              value={label}
              onChange={(e) => setLabel(e.target.value)}
            />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="cf-edit-help">Hint for admins</Label>
            <Input
              id="cf-edit-help"
              value={helpText}
              placeholder="Shown under the field"
              onChange={(e) => setHelpText(e.target.value)}
            />
          </div>
          <div className="grid gap-3 sm:grid-cols-2">
            <div className="space-y-1.5">
              <Label htmlFor="cf-edit-group">Group</Label>
              <Input
                id="cf-edit-group"
                value={groupName}
                placeholder="Custom fields"
                onChange={(e) => setGroupName(e.target.value)}
              />
            </div>
            <div className="space-y-1.5">
              <Label htmlFor="cf-edit-sort">
                Order{" "}
                <span className="font-normal text-muted-foreground">— lower first</span>
              </Label>
              <Input
                id="cf-edit-sort"
                type="number"
                inputMode="numeric"
                value={sortOrder}
                onChange={(e) => setSortOrder(e.target.value)}
              />
            </div>
          </div>
        </div>

        <DialogFooter>
          <Button type="button" variant="outline" onClick={onCancel}>
            Cancel
          </Button>
          <Button
            type="button"
            disabled={!label.trim() || pending}
            onClick={() =>
              onSave({
                label: label.trim(),
                help_text: helpText.trim() || null,
                group_name: groupName.trim() || "Custom fields",
                sort_order: Number(sortOrder) || 0,
              })
            }
          >
            {pending && <Loader2 className="mr-2 size-4 animate-spin" />}
            Save
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
