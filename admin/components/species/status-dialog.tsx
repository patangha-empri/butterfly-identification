"use client";

import { useMutation, useQueryClient } from "@tanstack/react-query";
import { Eye, EyeOff, Loader2, Trash2 } from "lucide-react";
import { toast } from "sonner";

import api, { apiErrorMessage } from "@/lib/api";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import type { PaginationMeta, Species } from "@/types";

/**
 * Confirmation for toggling app visibility or soft-deleting a species.
 *
 * Soft deletion sets is_active = False so the species hides everywhere while
 * preserving database records and observation history intact.
 */
export function SpeciesStatusDialog({
  species,
  open,
  onOpenChange,
  onDone,
  mode = "status",
}: {
  species: Species | null;
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onDone?: () => void;
  mode?: "status" | "delete";
}) {
  const qc = useQueryClient();
  const isDeleteMode = mode === "delete";
  const deactivating = isDeleteMode || species?.is_active !== false;

  const mutation = useMutation({
    mutationFn: async () => {
      if (!species) return;
      if (deactivating) {
        await api.delete(`/admin/species/${species.id}`);
      } else {
        await api.post(`/admin/species/${species.id}/activate`);
      }
    },
    onSuccess: () => {
      const id = species!.id;
      const isActive = !deactivating;

      // Patch the cache before refetching so the row updates immediately.
      //
      // Flipping is_active in place is not enough on a filtered list: the
      // species list is keyed ["species", page, search, status], and on the
      // default "active" tab a just-deleted species would sit there wearing an
      // "Inactive" badge until the refetch landed. Against a cold backend that
      // is several seconds of looking like the delete did nothing. So when the
      // row no longer matches that list's own filter, drop it and correct the
      // count; other tabs ("all", "inactive") keep it and just update the flag.
      qc.getQueryCache()
        .findAll({ queryKey: ["species"] })
        .forEach((query) => {
          const listStatus = query.queryKey[3] as string | undefined;
          qc.setQueryData<{ species: Species[]; meta?: PaginationMeta }>(
            query.queryKey,
            (old) => {
              if (!old || !Array.isArray(old.species)) return old;
              if (!old.species.some((s) => s.id === id)) return old;

              const nowMismatched =
                (listStatus === "active" && !isActive) ||
                (listStatus === "inactive" && isActive);

              if (nowMismatched) {
                return {
                  ...old,
                  species: old.species.filter((s) => s.id !== id),
                  meta: old.meta
                    ? { ...old.meta, total: Math.max(0, old.meta.total - 1) }
                    : old.meta,
                };
              }
              return {
                ...old,
                species: old.species.map((s) =>
                  s.id === id ? { ...s, is_active: isActive } : s
                ),
              };
            }
          );
        });
      qc.setQueriesData<Species>({ queryKey: ["species-detail"] }, (old) =>
        old && old.id === id ? { ...old, is_active: isActive } : old
      );

      toast.success(
        isDeleteMode
          ? `“${species?.common_name}” deleted (hidden everywhere).`
          : deactivating
            ? `“${species?.common_name}” is now hidden from the mobile app.`
            : `“${species?.common_name}” is visible in the mobile app again.`
      );
      qc.invalidateQueries({ queryKey: ["species"] });
      qc.invalidateQueries({ queryKey: ["species-detail"] });
      onOpenChange(false);
      onDone?.();
    },
    onError: (err) => toast.error(apiErrorMessage(err)),
  });

  if (!species) return null;

  const observations = species.observation_count ?? 0;

  return (
    <AlertDialog open={open} onOpenChange={onOpenChange}>
      <AlertDialogContent>
        <AlertDialogHeader>
          <AlertDialogTitle className="flex items-center gap-2">
            {isDeleteMode ? (
              <Trash2 size={17} className="text-red-600" />
            ) : deactivating ? (
              <EyeOff size={17} />
            ) : (
              <Eye size={17} />
            )}
            {isDeleteMode
              ? `Delete species “${species.common_name}”?`
              : `${deactivating ? "Hide" : "Show"} “${species.common_name}” ${
                  deactivating ? "from" : "in"
                } the mobile app?`}
          </AlertDialogTitle>
          <AlertDialogDescription asChild>
            <div className="space-y-3 text-sm">
              {isDeleteMode ? (
                <>
                  <p>Deleting this species will soft-delete it and hide it everywhere:</p>
                  <ul className="list-disc space-y-1 pl-5 text-muted-foreground">
                    <li>
                      It will be hidden from the mobile app, public portal, AI suggestions,
                      and standard admin lists.
                    </li>
                    <li>
                      Its {observations > 0 ? <strong>{observations}</strong> : "0"}{" "}
                      existing observation{observations === 1 ? "" : "s"}{" "}
                      {observations === 1 ? "stays" : "stay"} safely preserved in the database
                      — nothing is deleted or unlinked.
                    </li>
                    <li>
                      It can be viewed and restored at any time from the{" "}
                      <strong>Inactive — hidden</strong> species filter tab.
                    </li>
                  </ul>
                </>
              ) : deactivating ? (
                <>
                  <p>Setting this species to Inactive means:</p>
                  <ul className="list-disc space-y-1 pl-5 text-muted-foreground">
                    <li>
                      It stops appearing in the app&apos;s species list, search and
                      identification results.
                    </li>
                    <li>
                      Its {observations > 0 ? <strong>{observations}</strong> : "0"}{" "}
                      existing observation{observations === 1 ? "" : "s"}{" "}
                      {observations === 1 ? "stays" : "stay"} exactly as{" "}
                      {observations === 1 ? "it is" : "they are"} — nothing is
                      deleted or unlinked.
                    </li>
                    <li>
                      It stays here in the admin panel, and you can reverse this at
                      any time with <strong>Reactivate</strong>.
                    </li>
                  </ul>
                </>
              ) : (
                <p className="text-muted-foreground">
                  This species will appear again in the app&apos;s species list,
                  search and identification results, exactly as it did before.
                </p>
              )}
            </div>
          </AlertDialogDescription>
        </AlertDialogHeader>
        <AlertDialogFooter>
          <AlertDialogCancel disabled={mutation.isPending}>Cancel</AlertDialogCancel>
          <AlertDialogAction
            onClick={(e) => {
              e.preventDefault();
              mutation.mutate();
            }}
            disabled={mutation.isPending}
            className={
              isDeleteMode
                ? "bg-red-600 hover:bg-red-700 text-white"
                : deactivating
                  ? "bg-amber-600 hover:bg-amber-700"
                  : ""
            }
          >
            {mutation.isPending && <Loader2 className="mr-2 size-4 animate-spin" />}
            {isDeleteMode
              ? "Delete Species"
              : deactivating
                ? "Set to Inactive"
                : "Reactivate"}
          </AlertDialogAction>
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  );
}
