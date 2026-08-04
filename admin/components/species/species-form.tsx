"use client";

import { useState } from "react";
import { useForm, Controller, type Control } from "react-hook-form";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { ChevronDown, Loader2 } from "lucide-react";
import { toast } from "sonner";

import api, { apiErrorMessage } from "@/lib/api";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Switch } from "@/components/ui/switch";
import { cn } from "@/lib/utils";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { ListEditor } from "./list-editor";
import { CitationsEditor } from "./citations-editor";
import { CustomFieldsEditor } from "./custom-fields-editor";
import { SpeciesImagesEditor } from "./images-editor";
import {
  ALL_FIELD_SPECS,
  REQUIRED_FIELDS,
  SPECIES_SECTIONS,
  type FieldSpec,
} from "./field-specs";
import type { ApiResponse, Citation, CustomFieldValue, Species } from "@/types";

const MONTHS = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

type FormValues = Record<
  string,
  string | number | boolean | string[] | Citation[] | null | undefined
>;

function toDefaults(species?: Species | null): FormValues {
  const values: FormValues = {};
  for (const spec of ALL_FIELD_SPECS) {
    let current = species?.[spec.name as keyof Species] as unknown;

    // The API serialises the seasonal_appearance column as `flight_months`,
    // but writes still expect `seasonal_appearance`. Read from the response
    // name or the month picker silently starts empty and saving wipes it.
    if (spec.kind === "months") {
      current = species?.flight_months ?? current;
    }

    if (spec.kind === "citations") {
      values[spec.name] = Array.isArray(current)
        ? (current as unknown[]).filter(
            (c): c is Citation =>
              typeof c === "object" && c !== null && "source" in c
          )
        : [];
    } else if (spec.kind === "list" || spec.kind === "months") {
      values[spec.name] = Array.isArray(current) ? (current as string[]) : [];
    } else if (spec.kind === "switch") {
      values[spec.name] = current === true;
    } else {
      values[spec.name] = current === null || current === undefined ? "" : String(current);
    }
  }
  if (!species) values.conservation_status = "LC";
  return values;
}

/**
 * Build the request body.
 *
 * Two rules matter here. Empty strings become null so clearing a field actually
 * clears it rather than storing "". And nothing outside ALL_FIELD_SPECS is ever
 * sent — the backend runs Marshmallow with unknown=RAISE, so a single stray key
 * 422s the entire request.
 */
function toPayload(
  values: FormValues,
  customFields: Record<string, CustomFieldValue>
): Record<string, unknown> {
  const payload: Record<string, unknown> = {};

  for (const spec of ALL_FIELD_SPECS) {
    const raw = values[spec.name];

    if (spec.kind === "list" || spec.kind === "months" || spec.kind === "citations") {
      payload[spec.name] = Array.isArray(raw) ? raw : [];
    } else if (spec.kind === "switch") {
      payload[spec.name] = raw === true;
    } else if (spec.kind === "number") {
      const text = String(raw ?? "").trim();
      payload[spec.name] = text === "" ? null : Number(text);
    } else {
      const text = String(raw ?? "").trim();
      payload[spec.name] = text === "" ? null : text;
    }
  }

  // Flight months are integers in the DB; the month picker stores them as such.
  payload.seasonal_appearance = (values.seasonal_appearance as unknown as number[]) ?? [];
  payload.custom_fields = customFields;

  // Required strings must never go up as null.
  for (const key of REQUIRED_FIELDS) {
    payload[key] = String(values[key] ?? "").trim();
  }
  return payload;
}

export function SpeciesForm({
  species,
  onSaved,
  onCancel,
}: {
  species?: Species | null;
  onSaved: (saved: Species) => void;
  onCancel: () => void;
}) {
  const qc = useQueryClient();
  const isEdit = Boolean(species?.id);
  const [customFields, setCustomFields] = useState<Record<string, CustomFieldValue>>(
    species?.custom_fields ?? {}
  );

  const {
    register,
    handleSubmit,
    control,
    formState: { errors, isSubmitting },
  } = useForm<FormValues>({ defaultValues: toDefaults(species) });

  const mutation = useMutation({
    mutationFn: async (values: FormValues) => {
      const body = toPayload(values, customFields);
      const res = isEdit
        ? await api.put<ApiResponse<Species>>(`/admin/species/${species!.id}`, body)
        : await api.post<ApiResponse<Species>>("/admin/species/", body);
      return res.data.data;
    },
    onSuccess: (saved) => {
      // Same reason as the status dialog: the list refetch takes a few seconds,
      // so patch the cache first or an edit looks like it did not save.
      if (isEdit) {
        qc.setQueriesData<{ species: Species[] }>({ queryKey: ["species"] }, (old) =>
          old && Array.isArray(old.species)
            ? {
                ...old,
                species: old.species.map((s) => (s.id === saved.id ? { ...s, ...saved } : s)),
              }
            : old
        );
        qc.setQueriesData<Species>({ queryKey: ["species-detail"] }, (old) =>
          old && old.id === saved.id ? { ...old, ...saved } : old
        );
      }

      toast.success(isEdit ? "Species updated." : `“${saved.common_name}” created.`);
      qc.invalidateQueries({ queryKey: ["species"] });
      qc.invalidateQueries({ queryKey: ["species-detail"] });
      onSaved(saved);
    },
    onError: (err) => toast.error(apiErrorMessage(err)),
  });

  return (
    <form
      onSubmit={(e) => {
        e.preventDefault();
        void handleSubmit((v) => mutation.mutateAsync(v))(e);
      }}
      className="space-y-3"
    >
      {SPECIES_SECTIONS.map((section) => (
        <details
          key={section.id}
          open={section.defaultOpen}
          className="group rounded-lg border bg-card"
        >
          <summary className="flex cursor-pointer list-none items-center justify-between gap-3 p-3 hover:bg-muted/40">
            <div>
              <p className="text-sm font-medium">{section.title}</p>
              <p className="text-xs text-muted-foreground">{section.description}</p>
            </div>
            <ChevronDown
              size={16}
              className="shrink-0 text-muted-foreground transition-transform group-open:rotate-180"
            />
          </summary>

          <div className="grid gap-4 border-t p-4 sm:grid-cols-2">
            {section.fields.map((spec) => (
              <FormField
                key={spec.name}
                spec={spec}
                register={register}
                control={control}
                error={errors[spec.name]?.message as string | undefined}
              />
            ))}
          </div>
        </details>
      ))}

      <div className="rounded-lg border bg-card p-4">
        {isEdit && species ? (
          <SpeciesImagesEditor species={species} />
        ) : (
          <>
            <p className="text-sm font-medium">Images</p>
            <p className="mt-1 text-xs text-muted-foreground">
              Create the species first, then reopen it to add images — an upload
              has to attach to a saved record.
            </p>
          </>
        )}
      </div>

      <div className="rounded-lg border bg-card p-4">
        <CustomFieldsEditor values={customFields} onChange={setCustomFields} />
      </div>

      <div className="flex justify-end gap-2 pt-1">
        <Button type="button" variant="outline" onClick={onCancel}>
          Cancel
        </Button>
        <Button type="submit" disabled={isSubmitting || mutation.isPending}>
          {(isSubmitting || mutation.isPending) && (
            <Loader2 className="mr-2 size-4 animate-spin" />
          )}
          {isEdit ? "Save changes" : "Create species"}
        </Button>
      </div>
    </form>
  );
}

function FormField({
  spec,
  register,
  control,
  error,
}: {
  spec: FieldSpec;
  register: ReturnType<typeof useForm<FormValues>>["register"];
  control: Control<FormValues>;
  error?: string;
}) {
  const required = (REQUIRED_FIELDS as readonly string[]).includes(spec.name);

  return (
    <div className={cn("space-y-1.5", spec.wide && "sm:col-span-2")}>
      <Label htmlFor={`f-${spec.name}`} className="text-xs">
        {spec.label}
        {required && <span className="ml-0.5 text-destructive">*</span>}
      </Label>

      {spec.kind === "textarea" ? (
        <Textarea
          id={`f-${spec.name}`}
          rows={spec.rows ?? 3}
          placeholder={spec.placeholder}
          {...register(spec.name, required ? { required: `${spec.label} is required` } : {})}
        />
      ) : spec.kind === "number" ? (
        <Input
          id={`f-${spec.name}`}
          type="number"
          min={spec.min}
          max={spec.max}
          step={spec.step}
          placeholder={spec.placeholder}
          {...register(spec.name)}
        />
      ) : spec.kind === "switch" ? (
        <Controller
          name={spec.name}
          control={control}
          render={({ field }) => (
            <div className="flex h-9 items-center">
              <Switch checked={field.value === true} onCheckedChange={field.onChange} />
            </div>
          )}
        />
      ) : spec.kind === "select" ? (
        <Controller
          name={spec.name}
          control={control}
          render={({ field }) => (
            <Select
              value={(field.value as string) || undefined}
              onValueChange={field.onChange}
            >
              <SelectTrigger id={`f-${spec.name}`}>
                <SelectValue placeholder="Not set" />
              </SelectTrigger>
              <SelectContent>
                {spec.options?.map((o) => (
                  <SelectItem key={o.value} value={o.value}>
                    {o.label}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          )}
        />
      ) : spec.kind === "list" ? (
        <Controller
          name={spec.name}
          control={control}
          render={({ field }) => (
            <ListEditor
              value={Array.isArray(field.value) ? (field.value as string[]) : []}
              onChange={field.onChange}
              placeholder={`Add ${spec.label.toLowerCase()}`}
            />
          )}
        />
      ) : spec.kind === "citations" ? (
        <Controller
          name={spec.name}
          control={control}
          render={({ field }) => (
            <CitationsEditor
              value={Array.isArray(field.value) ? (field.value as Citation[]) : []}
              onChange={field.onChange}
            />
          )}
        />
      ) : spec.kind === "months" ? (
        <Controller
          name={spec.name}
          control={control}
          render={({ field }) => {
            const selected = (field.value as unknown as number[]) ?? [];
            return (
              <div className="flex flex-wrap gap-1">
                {MONTHS.map((label, i) => {
                  const month = i + 1;
                  const on = selected.includes(month);
                  return (
                    <button
                      key={label}
                      type="button"
                      onClick={() =>
                        field.onChange(
                          on
                            ? selected.filter((m) => m !== month)
                            : [...selected, month].sort((a, b) => a - b)
                        )
                      }
                      className={cn(
                        "rounded-md border px-2 py-1 text-xs transition-colors",
                        on
                          ? "border-primary bg-primary text-primary-foreground"
                          : "hover:bg-muted"
                      )}
                    >
                      {label}
                    </button>
                  );
                })}
              </div>
            );
          }}
        />
      ) : (
        <Input
          id={`f-${spec.name}`}
          placeholder={spec.placeholder}
          {...register(spec.name, required ? { required: `${spec.label} is required` } : {})}
        />
      )}

      {spec.help && <p className="text-[10px] text-muted-foreground">{spec.help}</p>}
      {error && <p className="text-xs text-destructive">{error}</p>}
    </div>
  );
}
