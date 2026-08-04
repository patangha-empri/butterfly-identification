"use client";

import { useEffect, useRef, useState } from "react";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { ImageUp, Loader2 } from "lucide-react";
import { toast } from "sonner";

import api, { apiErrorMessage } from "@/lib/api";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
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
import { IMAGE_TYPES, MAX_IMAGE_BYTES, IMAGE_ACCEPT } from "./image-constants";
import type { ApiResponse, SpeciesImage } from "@/types";

/** The fields SpeciesImageUpdateSchema accepts, minus image_type (its own control). */
const TEXT_FIELDS = [
  { key: "credit", label: "Credit", placeholder: "How the photo must be attributed" },
  { key: "photographer", label: "Photographer", placeholder: "Who took it" },
  { key: "license", label: "Licence", placeholder: "e.g. CC BY 4.0" },
  { key: "source", label: "Source", placeholder: "e.g. Wikimedia Commons" },
  { key: "source_page_url", label: "Source page URL", placeholder: "https://…" },
  { key: "capture_location", label: "Capture location", placeholder: "Where it was taken" },
] as const;

type FormState = Record<string, string>;

function toFormState(image: SpeciesImage): FormState {
  const state: FormState = { image_type: image.image_type ?? "reference" };
  for (const f of TEXT_FIELDS) state[f.key] = (image[f.key] as string | null) ?? "";
  // <input type="date"> needs bare YYYY-MM-DD.
  state.capture_date = (image.capture_date ?? "").slice(0, 10);
  return state;
}

/**
 * Edit one species photo: its details, and optionally the picture itself.
 *
 * Replacing the file goes to a dedicated endpoint rather than delete-then-upload
 * so the image keeps its id, its primary flag and everything typed here — fixing
 * a wrong photo shouldn't cost the credit and licence data attached to it.
 */
export function SpeciesImageEditDialog({
  speciesId,
  image,
  open,
  onOpenChange,
}: {
  speciesId: string;
  image: SpeciesImage | null;
  open: boolean;
  onOpenChange: (open: boolean) => void;
}) {
  const qc = useQueryClient();
  const fileRef = useRef<HTMLInputElement>(null);
  const [form, setForm] = useState<FormState>({});

  // Reload when a different image is opened, so the dialog never shows the
  // previous photo's details.
  useEffect(() => {
    if (image && open) setForm(toFormState(image));
  }, [image, open]);

  function refresh() {
    qc.invalidateQueries({ queryKey: ["species"] });
    qc.invalidateQueries({ queryKey: ["species-detail"] });
  }

  const saveMutation = useMutation({
    mutationFn: async () => {
      // Empty string clears a field; the backend accepts null for all of them.
      const body: Record<string, string | null> = { image_type: form.image_type };
      for (const f of TEXT_FIELDS) body[f.key] = form[f.key]?.trim() || null;
      body.capture_date = form.capture_date || null;
      const res = await api.patch<ApiResponse<SpeciesImage>>(
        `/admin/species/${speciesId}/images/${image!.id}`,
        body
      );
      return res.data.data;
    },
    onSuccess: () => {
      toast.success("Image details updated.");
      refresh();
      onOpenChange(false);
    },
    onError: (err) => toast.error(apiErrorMessage(err)),
  });

  const replaceMutation = useMutation({
    mutationFn: async (file: File) => {
      const fd = new FormData();
      fd.append("image", file);
      const res = await api.post<ApiResponse<SpeciesImage>>(
        `/admin/species/${speciesId}/images/${image!.id}/file`,
        fd
      );
      return res.data.data;
    },
    onSuccess: () => {
      toast.success("Photo replaced. Its details were kept.");
      if (fileRef.current) fileRef.current.value = "";
      refresh();
    },
    onError: (err) => toast.error(apiErrorMessage(err)),
  });

  function onPick(file: File | undefined) {
    if (!file) return;
    if (file.size > MAX_IMAGE_BYTES) {
      toast.error(
        `“${file.name}” is ${(file.size / 1024 / 1024).toFixed(1)} MB. The limit is 10 MB.`
      );
      if (fileRef.current) fileRef.current.value = "";
      return;
    }
    replaceMutation.mutate(file);
  }

  if (!image) return null;
  const busy = saveMutation.isPending || replaceMutation.isPending;

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-h-[90vh] overflow-y-auto sm:max-w-lg">
        <DialogHeader>
          <DialogTitle>Edit photo</DialogTitle>
          <DialogDescription>
            Change the details, or swap the picture for a better one. Replacing
            the picture keeps everything below.
          </DialogDescription>
        </DialogHeader>

        <div className="space-y-3">
          <div className="flex items-start gap-3">
            <img
              src={image.thumbnail_url ?? image.image_url}
              alt={image.image_type ?? "Species photo"}
              className="h-24 w-24 shrink-0 rounded-lg border object-cover"
            />
            <div className="space-y-1.5">
              <input
                ref={fileRef}
                type="file"
                accept={IMAGE_ACCEPT}
                className="hidden"
                onChange={(e) => onPick(e.target.files?.[0])}
              />
              <Button
                type="button"
                variant="outline"
                size="sm"
                disabled={busy}
                onClick={() => fileRef.current?.click()}
              >
                {replaceMutation.isPending ? (
                  <Loader2 className="mr-1 size-4 animate-spin" />
                ) : (
                  <ImageUp size={14} className="mr-1" />
                )}
                Replace picture
              </Button>
              <p className="text-[10px] text-muted-foreground">
                JPG, PNG or WebP, up to 10 MB. Replacing saves immediately.
              </p>
            </div>
          </div>

          <div className="space-y-1.5">
            <Label className="text-xs">Image type</Label>
            <Select
              value={form.image_type}
              onValueChange={(v) => setForm((f) => ({ ...f, image_type: v }))}
            >
              <SelectTrigger>
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                {IMAGE_TYPES.map((t) => (
                  <SelectItem key={t.value} value={t.value}>
                    {t.label}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          <div className="grid gap-3 sm:grid-cols-2">
            {TEXT_FIELDS.map((f) => (
              <div key={f.key} className="space-y-1.5">
                <Label htmlFor={`img-${f.key}`} className="text-xs">
                  {f.label}
                </Label>
                <Input
                  id={`img-${f.key}`}
                  value={form[f.key] ?? ""}
                  placeholder={f.placeholder}
                  onChange={(e) =>
                    setForm((prev) => ({ ...prev, [f.key]: e.target.value }))
                  }
                />
              </div>
            ))}

            <div className="space-y-1.5">
              <Label htmlFor="img-capture_date" className="text-xs">
                Capture date
              </Label>
              <Input
                id="img-capture_date"
                type="date"
                value={form.capture_date ?? ""}
                onChange={(e) =>
                  setForm((prev) => ({ ...prev, capture_date: e.target.value }))
                }
              />
            </div>
          </div>
        </div>

        <DialogFooter>
          <Button
            type="button"
            variant="outline"
            onClick={() => onOpenChange(false)}
            disabled={busy}
          >
            Cancel
          </Button>
          <Button type="button" onClick={() => saveMutation.mutate()} disabled={busy}>
            {saveMutation.isPending && <Loader2 className="mr-2 size-4 animate-spin" />}
            Save details
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
