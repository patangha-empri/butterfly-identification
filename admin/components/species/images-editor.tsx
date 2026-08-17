"use client";

import { useRef, useState } from "react";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { Loader2, Pencil, Star, Trash2, Upload } from "lucide-react";
import { toast } from "sonner";

import api, { apiErrorMessage } from "@/lib/api";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import type { ApiResponse, Species, SpeciesImage } from "@/types";

import { SpeciesImageEditDialog } from "./image-edit-dialog";
import { IMAGE_ACCEPT, IMAGE_TYPES, MAX_IMAGE_BYTES } from "./image-constants";

/**
 * Image manager for a species.
 *
 * Images are their own rows in species_images, uploaded as multipart rather
 * than as part of the species JSON body, so this cannot be a field on the main
 * form — it acts on the server immediately. That is also why it needs a saved
 * species: there is no id to attach an upload to until the record exists.
 *
 * The first image uploaded becomes primary automatically (backend rule); the
 * primary one is what the mobile app and every list thumbnail show.
 */
export function SpeciesImagesEditor({ species }: { species: Species }) {
  const qc = useQueryClient();
  const fileRef = useRef<HTMLInputElement>(null);
  const [imageType, setImageType] = useState("reference");
  const [credit, setCredit] = useState("");
  const [editing, setEditing] = useState<SpeciesImage | null>(null);

  const images = species.images ?? [];

  function refresh() {
    qc.invalidateQueries({ queryKey: ["species"] });
    qc.invalidateQueries({ queryKey: ["species-detail"] });
  }

  const uploadMutation = useMutation({
    mutationFn: async (file: File) => {
      const fd = new FormData();
      fd.append("image", file);
      fd.append("image_type", imageType);
      if (credit.trim()) fd.append("credit", credit.trim());
      // No Content-Type here on purpose — the request interceptor in lib/api.ts
      // clears it for FormData so the browser can add the multipart boundary.
      const res = await api.post<ApiResponse<SpeciesImage>>(
        `/admin/species/${species.id}/images`,
        fd
      );
      return res.data.data;
    },
    onSuccess: () => {
      toast.success("Image uploaded.");
      setCredit("");
      if (fileRef.current) fileRef.current.value = "";
      refresh();
    },
    onError: (err) => toast.error(apiErrorMessage(err)),
  });

  const primaryMutation = useMutation({
    mutationFn: async (imageId: string) => {
      await api.patch(`/admin/species/${species.id}/images/${imageId}/primary`);
    },
    onSuccess: () => {
      toast.success("Primary image updated.");
      refresh();
    },
    onError: (err) => toast.error(apiErrorMessage(err)),
  });

  const deleteMutation = useMutation({
    mutationFn: async (imageId: string) => {
      await api.delete(`/admin/species/${species.id}/images/${imageId}`);
    },
    onSuccess: () => {
      toast.success("Image deleted.");
      refresh();
    },
    onError: (err) => toast.error(apiErrorMessage(err)),
  });

  function onPick(file: File | undefined) {
    if (!file) return;
    // Checked here as well as server-side so a 10 MB upload isn't sent just to
    // be rejected on arrival.
    if (file.size > MAX_IMAGE_BYTES) {
      toast.error(
        `“${file.name}” is ${(file.size / 1024 / 1024).toFixed(1)} MB. The limit is 10 MB.`
      );
      if (fileRef.current) fileRef.current.value = "";
      return;
    }
    uploadMutation.mutate(file);
  }

  const busy =
    uploadMutation.isPending || primaryMutation.isPending || deleteMutation.isPending;

  return (
    <div className="space-y-4">
      <div>
        <p className="text-sm font-medium">Images</p>
        <p className="text-xs text-muted-foreground">
          The primary image is the one shown in the mobile app and in every list.
          Changes here save immediately — they don&apos;t wait for the button below.
        </p>
      </div>

      {images.length > 0 ? (
        <div className="grid grid-cols-2 gap-3 sm:grid-cols-3">
          {images.map((img) => {
            const isPrimary = img.is_primary === true;
            return (
              <div
                key={img.id ?? img.image_url}
                className={`group relative overflow-hidden rounded-lg border ${
                  isPrimary ? "border-primary ring-1 ring-primary" : ""
                }`}
              >
                <img
                  src={img.thumbnail_url ?? img.image_url}
                  alt={img.image_type ?? species.common_name}
                  className="h-28 w-full object-cover"
                />

                {isPrimary && (
                  <span className="absolute left-1.5 top-1.5 inline-flex items-center gap-0.5 rounded bg-primary px-1.5 py-0.5 text-[10px] font-medium text-primary-foreground">
                    <Star size={9} className="fill-current" /> Primary
                  </span>
                )}

                <div className="flex items-center justify-between gap-1 border-t bg-card px-1.5 py-1">
                  <span className="truncate text-[10px] text-muted-foreground">
                    {[img.image_type, img.credit && `© ${img.credit}`]
                      .filter(Boolean)
                      .join(" · ") || "—"}
                  </span>
                  <div className="flex shrink-0 items-center">
                    {img.id && (
                      <Button
                        type="button"
                        variant="ghost"
                        size="icon-sm"
                        title="Edit details or replace this picture"
                        disabled={busy}
                        onClick={() => setEditing(img)}
                      >
                        <Pencil size={12} />
                      </Button>
                    )}
                    {!isPrimary && img.id && (
                      <Button
                        type="button"
                        variant="ghost"
                        size="icon-sm"
                        title="Make this the primary image"
                        disabled={busy}
                        onClick={() => primaryMutation.mutate(img.id!)}
                      >
                        <Star size={12} />
                      </Button>
                    )}
                    {img.id && (
                      <Button
                        type="button"
                        variant="ghost"
                        size="icon-sm"
                        title="Delete this image"
                        disabled={busy}
                        onClick={() => {
                          if (
                            confirm(
                              "Delete this image? This cannot be undone. The species and its observations are not affected."
                            )
                          ) {
                            deleteMutation.mutate(img.id!);
                          }
                        }}
                      >
                        <Trash2 size={12} className="text-destructive" />
                      </Button>
                    )}
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      ) : (
        <p className="rounded-lg border bg-muted/30 p-3 text-xs text-muted-foreground">
          No images yet. The first one you upload becomes the primary image
          automatically.
        </p>
      )}

      <div className="grid gap-3 rounded-lg border p-3 sm:grid-cols-2">
        <div className="space-y-1.5">
          <Label className="text-xs">Image type</Label>
          <Select value={imageType} onValueChange={setImageType}>
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

        <div className="space-y-1.5">
          <Label htmlFor="img-credit" className="text-xs">
            Credit <span className="font-normal text-muted-foreground">(optional)</span>
          </Label>
          <Input
            id="img-credit"
            value={credit}
            placeholder="Photographer or source"
            onChange={(e) => setCredit(e.target.value)}
          />
        </div>

        <div className="sm:col-span-2">
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
            {uploadMutation.isPending ? (
              <Loader2 className="mr-1 size-4 animate-spin" />
            ) : (
              <Upload size={14} className="mr-1" />
            )}
            Upload image
          </Button>
          <p className="mt-1 text-[10px] text-muted-foreground">
            JPG, PNG or WebP, up to 10 MB. Set the type and credit above before
            choosing the file — they are saved with it.
          </p>
        </div>
      </div>

      <SpeciesImageEditDialog
        speciesId={species.id}
        // Read from the refreshed list, not the click-time snapshot, so the
        // preview updates after replacing the picture.
        image={editing ? (images.find((i) => i.id === editing.id) ?? editing) : null}
        open={Boolean(editing)}
        onOpenChange={(o) => !o && setEditing(null)}
      />
    </div>
  );
}
