"use client";

import { useMemo, useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { Info, Loader2, Plus, Settings2, X } from "lucide-react";
import { toast } from "sonner";

import api, { apiErrorMessage } from "@/lib/api";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Switch } from "@/components/ui/switch";
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { ListEditor } from "./list-editor";
import { ManageFieldsDialog } from "./manage-fields-dialog";
import type {
  ApiResponse,
  CustomFieldType,
  CustomFieldValue,
  SpeciesFieldDefinition,
} from "@/types";

const FIELD_TYPES: { value: CustomFieldType; label: string; hint: string }[] = [
  { value: "text", label: "Short text", hint: "A single line, e.g. “Velvety”" },
  { value: "textarea", label: "Long text", hint: "A paragraph or more" },
  { value: "number", label: "Number", hint: "Digits only" },
  { value: "boolean", label: "Yes / No", hint: "A simple toggle" },
  { value: "date", label: "Date", hint: "A calendar date" },
  { value: "url", label: "Link", hint: "A web address" },
  { value: "list", label: "List", hint: "Several values, added one at a time" },
];

/** "Wing texture" → "wing_texture" — the storage key derived from the label. */
function toFieldKey(label: string): string {
  return label
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "_")
    .replace(/^_+|_+$/g, "")
    .replace(/^([0-9])/, "f$1")
    .slice(0, 63);
}

export function CustomFieldsEditor({
  values,
  onChange,
}: {
  values: Record<string, CustomFieldValue>;
  onChange: (next: Record<string, CustomFieldValue>) => void;
}) {
  const qc = useQueryClient();
  const [addOpen, setAddOpen] = useState(false);
  const [manageOpen, setManageOpen] = useState(false);
  const [label, setLabel] = useState("");
  const [fieldKey, setFieldKey] = useState("");
  const [keyEdited, setKeyEdited] = useState(false);
  const [fieldType, setFieldType] = useState<CustomFieldType>("text");
  const [helpText, setHelpText] = useState("");

  const { data: definitions = [], isLoading } = useQuery({
    queryKey: ["species-field-definitions"],
    queryFn: async () => {
      const res = await api.get<ApiResponse<SpeciesFieldDefinition[]>>(
        "/admin/species/field-definitions"
      );
      return res.data.data;
    },
  });

  // Warn before creating a near-duplicate, so "Wing texture" and "Wing Texture"
  // don't end up as two separate fields meaning the same thing.
  const similar = useMemo(() => {
    const key = fieldKey.trim();
    if (key.length < 3) return null;
    return definitions.find(
      (d) =>
        d.field_key !== key &&
        (d.field_key.includes(key) || key.includes(d.field_key))
    );
  }, [fieldKey, definitions]);

  const createMutation = useMutation({
    mutationFn: async () => {
      const res = await api.post<ApiResponse<SpeciesFieldDefinition>>(
        "/admin/species/field-definitions",
        {
          field_key: fieldKey.trim(),
          label: label.trim(),
          field_type: fieldType,
          ...(helpText.trim() && { help_text: helpText.trim() }),
        }
      );
      return res.data.data;
    },
    onSuccess: (created) => {
      toast.success(`Field “${created.label}” added.`);
      qc.invalidateQueries({ queryKey: ["species-field-definitions"] });
      setAddOpen(false);
      setLabel("");
      setFieldKey("");
      setKeyEdited(false);
      setFieldType("text");
      setHelpText("");
    },
    onError: (err) => toast.error(apiErrorMessage(err)),
  });

  function setValue(key: string, value: CustomFieldValue) {
    onChange({ ...values, [key]: value });
  }

  function clearValue(key: string) {
    const next = { ...values };
    delete next[key];
    onChange(next);
  }

  return (
    <div className="space-y-4">
      <div className="flex items-start justify-between gap-3">
        <div className="flex items-center gap-1.5">
          <p className="text-sm font-medium">Custom fields</p>
          <Popover>
            <PopoverTrigger asChild>
              <button type="button" aria-label="About custom fields">
                <Info size={13} className="text-muted-foreground hover:text-foreground" />
              </button>
            </PopoverTrigger>
            <PopoverContent className="w-80 text-xs leading-relaxed">
              <p className="font-medium mb-1.5 text-sm">What are custom fields?</p>
              <p className="text-muted-foreground mb-2">
                Anything the built-in fields don&apos;t already cover. You name the
                field once and it becomes available on <em>every</em> species, so
                the same information is always recorded the same way.
              </p>
              <p className="text-muted-foreground mb-2">
                Leave a field blank on species where it doesn&apos;t apply. Clearing
                a field here only affects this species — it does not touch other
                species or delete the field itself.
              </p>
              <p className="text-muted-foreground">
                To rename, hide or delete a field for everyone, use{" "}
                <strong>Manage</strong>. Deleting always asks what should happen to
                data already saved.
              </p>
            </PopoverContent>
          </Popover>
        </div>
        <div className="flex gap-2">
          <Button
            type="button"
            variant="outline"
            size="sm"
            onClick={() => setManageOpen(true)}
          >
            <Settings2 size={14} className="mr-1" /> Manage
          </Button>
          <Button type="button" variant="outline" size="sm" onClick={() => setAddOpen(true)}>
            <Plus size={14} className="mr-1" /> Add field
          </Button>
        </div>
      </div>

      {isLoading ? (
        <p className="text-xs text-muted-foreground">Loading fields…</p>
      ) : definitions.length === 0 ? (
        <p className="text-xs text-muted-foreground border rounded-lg p-3 bg-muted/30">
          No custom fields yet. Use <strong>Add field</strong> to create one — for
          example “Wing texture” or “Local name” — and it will appear here for
          every species.
        </p>
      ) : (
        <div className="grid gap-3 sm:grid-cols-2">
          {definitions.map((def) => (
            <CustomFieldInput
              key={def.id}
              definition={def}
              value={values[def.field_key] ?? null}
              onChange={(v) => setValue(def.field_key, v)}
              onClear={() => clearValue(def.field_key)}
            />
          ))}
        </div>
      )}

      <ManageFieldsDialog open={manageOpen} onOpenChange={setManageOpen} />

      <Dialog open={addOpen} onOpenChange={setAddOpen}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>Add a custom field</DialogTitle>
            <DialogDescription>
              This creates the field for all species, not just this one. Existing
              species simply leave it blank until you fill it in.
            </DialogDescription>
          </DialogHeader>

          <div className="space-y-3">
            <div className="space-y-1.5">
              <Label htmlFor="cf-label">Field name</Label>
              <Input
                id="cf-label"
                value={label}
                placeholder="e.g. Wing texture"
                onChange={(e) => {
                  setLabel(e.target.value);
                  if (!keyEdited) setFieldKey(toFieldKey(e.target.value));
                }}
              />
            </div>

            <div className="space-y-1.5">
              <Label htmlFor="cf-key">
                Storage key{" "}
                <span className="font-normal text-muted-foreground">
                  — how it&apos;s saved; cannot be changed later
                </span>
              </Label>
              <Input
                id="cf-key"
                value={fieldKey}
                className="font-mono text-xs"
                onChange={(e) => {
                  setKeyEdited(true);
                  setFieldKey(e.target.value.toLowerCase());
                }}
              />
              {similar && (
                <p className="text-xs text-amber-700">
                  Similar field already exists: <strong>{similar.label}</strong> (
                  <code>{similar.field_key}</code>). Use that one instead unless
                  this is genuinely different.
                </p>
              )}
            </div>

            <div className="space-y-1.5">
              <Label>Type of value</Label>
              <Select
                value={fieldType}
                onValueChange={(v) => setFieldType(v as CustomFieldType)}
              >
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {FIELD_TYPES.map((t) => (
                    <SelectItem key={t.value} value={t.value}>
                      {t.label} — <span className="text-muted-foreground">{t.hint}</span>
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-1.5">
              <Label htmlFor="cf-help">Hint for admins (optional)</Label>
              <Input
                id="cf-help"
                value={helpText}
                placeholder="Shown under the field to explain what to enter"
                onChange={(e) => setHelpText(e.target.value)}
              />
            </div>
          </div>

          <DialogFooter>
            <Button type="button" variant="outline" onClick={() => setAddOpen(false)}>
              Cancel
            </Button>
            <Button
              type="button"
              disabled={
                !label.trim() ||
                !/^[a-z][a-z0-9_]*$/.test(fieldKey.trim()) ||
                createMutation.isPending
              }
              onClick={() => createMutation.mutate()}
            >
              {createMutation.isPending && (
                <Loader2 className="mr-2 size-4 animate-spin" />
              )}
              Add field
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}

function CustomFieldInput({
  definition,
  value,
  onChange,
  onClear,
}: {
  definition: SpeciesFieldDefinition;
  value: CustomFieldValue;
  onChange: (v: CustomFieldValue) => void;
  onClear: () => void;
}) {
  const { field_key, label, field_type, help_text } = definition;
  const hasValue = value !== null && value !== undefined && value !== "";

  return (
    <div className="space-y-1.5">
      <div className="flex items-center justify-between gap-2">
        <Label htmlFor={`cf-${field_key}`} className="text-xs">
          {label}
        </Label>
        {hasValue && (
          <button
            type="button"
            onClick={onClear}
            className="text-[10px] text-muted-foreground hover:text-destructive inline-flex items-center gap-0.5"
          >
            <X size={10} /> clear
          </button>
        )}
      </div>

      {field_type === "textarea" ? (
        <Textarea
          id={`cf-${field_key}`}
          rows={3}
          value={(value as string) ?? ""}
          onChange={(e) => onChange(e.target.value || null)}
        />
      ) : field_type === "boolean" ? (
        <div className="flex h-9 items-center">
          <Switch checked={value === true} onCheckedChange={(c) => onChange(c)} />
        </div>
      ) : field_type === "list" ? (
        <ListEditor
          value={Array.isArray(value) ? value : []}
          onChange={(v) => onChange(v.length ? v : null)}
          placeholder={`Add ${label.toLowerCase()}`}
        />
      ) : (
        <Input
          id={`cf-${field_key}`}
          type={
            field_type === "number" ? "number" : field_type === "date" ? "date" : "text"
          }
          inputMode={field_type === "number" ? "numeric" : undefined}
          value={value === null || value === undefined ? "" : String(value)}
          onChange={(e) => {
            const raw = e.target.value;
            if (raw === "") return onChange(null);
            onChange(field_type === "number" ? Number(raw) : raw);
          }}
        />
      )}

      {help_text && (
        <p className="text-[10px] text-muted-foreground">{help_text}</p>
      )}
    </div>
  );
}
